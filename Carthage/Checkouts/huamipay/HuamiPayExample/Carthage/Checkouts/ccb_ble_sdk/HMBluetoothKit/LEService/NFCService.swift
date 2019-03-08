//
//  NFCService.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/2/5.
//

import Foundation
import CoreBluetooth


/// 切换aid
///
/// - bus: 公交aid
/// - access: 门禁aid
public enum SwapAidType: UInt8 {
    case bus = 0x01
    case access = 0x02
}


public class NFCService: NFCProtocol {
    var peripheral: LEPeripheral
    lazy fileprivate var queue = BlockingQueue()
    lazy var keepConnectQueue = DispatchQueue(label: "keepConnect")
    fileprivate let serviceUUID = CBUUID(string: "FEE0")
    fileprivate let characteristicUUID = CBUUID(string: "00000011-0000-3512-2118-0009af100700")
    fileprivate var characteristic: CBCharacteristic?
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    /// 打开通道
    ///
    /// - Throws: Error
    public func openApdu() throws {
        characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        var chunkData = Data()
        let openQueue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic!, callback: { [weak self] in
            let data = $1.value!
            print("蓝牙返回的原始Apdu: \(data.toHexString())")
            let index = data.bytes[0]
            if index == 0x83 || index == 0x84 || index == 0x85 || index == 0x86 {
                chunkData.append(data.subdata(in: 1..<data.count))
                if index == 0x83 || index == 0x85 {
                    self?.queue.push((chunkData, $2))
                    chunkData = Data()
                }
            } else {
                openQueue.push((data, $2))
            }
        })
        
        try peripheral.writeNoRsp(Data([0x01]), to: characteristic!)
        let (value, error) = try openQueue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.elementsEqual([0x81, 0x00]) else { throw LEPeripheralError.invailedResponse(value) }
    }
    
    /// 关闭通道
    ///
    /// - Throws: Error
    public func closeApdu() throws {
        guard let ch = characteristic else { throw LEPeripheralError.unFindCharacteristic }
        let closeQueue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic!, callback: {
            let data = $1.value!
            print("蓝牙返回的原始Apdu: \(data.toHexString())")
            let index = data.bytes[0]
            if index == 0x82 {
                closeQueue.push((data, $2))
            }
        })
        try peripheral.writeNoRsp(Data([0x02]), to: ch)
        let (value, error) = try closeQueue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.elementsEqual([0x82, 0x00]) else { throw LEPeripheralError.invailedResponse(value) }
        try peripheral.setNotify(false, for: ch)
    }
    
    /// 发送Apdu
    ///
    /// - Parameters:
    ///   - apdu: apdu数据
    ///   - cmdLength: 长度
    ///   - isEncryp: 是否加密(默认不加密)
    /// - Returns: 返回的数据及数据有效长度
    /// - Throws: Error
    public func sendApdu(_ apdu: Data, cmdLength: Int, isEncryp: Bool) throws -> (rawData: Data, length: Int) {
        guard let ch = characteristic else { throw LEPeripheralError.unFindCharacteristic }
        var apduWithLength = apdu
        apduWithLength.append(Data.Element(cmdLength & 0xff))
        apduWithLength.append(Data.Element((cmdLength >> 8) & 0xff))
        let group = apduWithLength.group(by: 19)
        let headerContinueCmd: UInt8 = isEncryp == true ? 0x06 : 0x04
        let headerCmd: UInt8 = isEncryp == true ? 0x05 : 0x03
        for (index, var a) in group.enumerated() {
            if (index != (group.count - 1))  {
                a.insert(headerContinueCmd, at: 0)
            } else  {
                a.insert(headerCmd, at: 0)
            }
            
            let apduData = Data.init(bytes: a)
            print("当前发送Apdu: \(apduData.toHexString())")
            try peripheral.writeNoRsp(apduData, to: ch)
        }
        
        let (value, error) = try queue.pop(timeout: 60)
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        let count = value.count
        guard count >= 2 else { throw LEPeripheralError.invailedResponse(value)}
        let length = Int((value.bytes[(count - 1)] & 0xff) | (value.bytes[(count - 2)] & 0xff))
        return (rawData: value.subdata(in: 0..<(value.count - 2)), length: length)
    }
    
    public func getMiFareTag() throws -> Data {
        characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        let openQueue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic!, callback: {
            let data = $1.value!
            print("蓝牙返回的原始Apdu: \(data.toHexString())")
            guard data.starts(with: [0x8D]) else { return }
            openQueue.push((data, $2))
        })
        
        try peripheral.writeNoRsp(Data([0x0D]), to: characteristic!)
        let (value, error) = try openQueue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        return value
    }
    
    /// 切换aid
    ///
    /// - Parameters:
    ///   - aid: aid，可为空，如果是删卡则为空
    ///   - type: 公交卡还是门禁卡
    /// - Throws: Error
    public func swapAid(_ aid: Data?, for type: SwapAidType) throws {
        let ecfCH = try peripheral.characteristic(CBUUID(string: "00000003-0000-3512-2118-0009AF100700"), in: CBUUID(string: "FEE0"))
        let openQueue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic!, callback: {
            let data = $1.value!
            print("蓝牙返回的原始Apdu: \(data.toHexString())")
            openQueue.push((data, $2))
        })
        let bytes: [UInt8] = [0x06,
                              0x18 & 0xFF,
                              (0x18 >> 8) & 0xFF,
                              type.rawValue]
        var cmd = Data(bytes: bytes)
        if let aid = aid {
            cmd.append(aid.count.toU8)
            cmd.append(aid)
        } else {
            cmd.append(0x00)
        }
        
        try peripheral.writeNoRsp(cmd, to: ecfCH)
        let (value, error) = try openQueue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.starts(with: [0x10, 0x06]) && value.count >= 3 else { throw LEPeripheralError.invailedResponse(value) }
    }
}
