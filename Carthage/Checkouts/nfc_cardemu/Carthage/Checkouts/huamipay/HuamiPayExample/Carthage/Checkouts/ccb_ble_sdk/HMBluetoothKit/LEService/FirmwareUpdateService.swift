//
//  FirmwareUpdateService.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/4/14.
//

import Foundation
import CoreBluetooth

public enum UpgradeFirmwareType: UInt8 {
    case system = 0
    case font = 0x01
    case resource = 0x02
    case tempoResource = 0x80
    case gps = 0x03
    case agpsCEP = 0x04
    case agpsALM = 0x05
    case agpsNMEA = 0x06
    case taipingHuAS7000 = 0x07
    case dialPlate = 0x08
    case packResource = 0x82
}

public class FirmwareUpdateService: FirmwareUpdateProtocol {
    var peripheral: LEPeripheral
    fileprivate let FLAG_RSP: UInt8 = 0x10
    fileprivate let FLAG_RSP_OK: UInt8 = 0x01
    fileprivate let CMD_REQ_GKIBUFFER: UInt8 = 0x00
    fileprivate let CMD_REQ_LENGTH: UInt8 = 0x01
    fileprivate let CMD_REQ_TRANSFER: UInt8 = 0x03
    fileprivate let CMD_REQ_CRC: UInt8 = 0x04
    fileprivate let CMD_REQ_RESTART: UInt8 = 0x05
    fileprivate var canContinueFirmwareUpdate = false
    
    init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    public func firmwareUpdate(_ fileData: Data, type: UpgradeFirmwareType, callback: FirmwareUpdateCallback?) throws {
        let service = CBUUID(string: "00001530-0000-3512-2118-0009AF100700")
        let fwPointCharacteristic = try peripheral.characteristic(CBUUID(string:"00001531-0000-3512-2118-0009AF100700"), in: service)
        let fwDataCharacteristic = try peripheral.characteristic(CBUUID(string:"00001532-0000-3512-2118-0009AF100700"), in: service)
        let deviceCharacteristic = try peripheral.characteristic(CBUUID(string: "2A28"), in: CBUUID(string: "180A"))
        
        let dataGroups = fileData.group(by: 20)
        var defaultCommands = 3
        if type == .system { defaultCommands = 4 }
        // 需要发送命令的数量
        let allCommand = dataGroups.count + defaultCommands
        
        let queue = BlockingQueue()
        try peripheral.setNotify(true, for: fwPointCharacteristic) {
            print("固件升级返回: \($1.value!.toHexString())")
            queue.push(($1.value!, $2))
            
            if $1.value!.toHexString().hasPrefix("\(self.FLAG_RSP)\(self.CMD_REQ_TRANSFER)") {
                if !($1.value!.elementsEqual([self.FLAG_RSP, self.CMD_REQ_TRANSFER, self.FLAG_RSP_OK])) {
                    self.canContinueFirmwareUpdate = false
                }
            }
        }
        
        defer { try? peripheral.setNotify(false, for: fwPointCharacteristic) }
        
        // write length
        let fileLength = fileData.count
        var lengthBytes: [UInt8] = [CMD_REQ_LENGTH, UInt8(fileLength & 0xFF), UInt8((fileLength >> 8) & 0xFF), UInt8((fileLength >> 16) & 0xFF)]
        if type != .system { lengthBytes += [type.rawValue] }
        try peripheral.write(Data(bytes: lengthBytes), to: fwPointCharacteristic)
        let (lengthRsp, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard lengthRsp.elementsEqual([FLAG_RSP, CMD_REQ_LENGTH, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(lengthRsp) }
        // progress
        callback?(progress(1, total: allCommand))
        
        // write transfer
        try peripheral.write(Data(bytes: [CMD_REQ_TRANSFER]), to: fwPointCharacteristic)
        // progress
        callback?(progress(2, total: allCommand))
        
        // write data
        var currentBuffer = 0
        canContinueFirmwareUpdate = true
        for (index, fileBytes) in dataGroups.enumerated() {
            guard canContinueFirmwareUpdate else { throw LEPeripheralError.firmwareUpdateFailed }
            currentBuffer += fileBytes.count
            try peripheral.writeNoRsp(Data(bytes: fileBytes), to: fwDataCharacteristic, timeout: 1)
            // progress
            callback?(progress((3 + index), total: allCommand))
            
            // 由于iOS底层队列最大值为多少，无法得知，为了防止溢出
            if currentBuffer >= 200 {
                currentBuffer = 0
                // 这个地方是防止溢出，做的一次读操作,1s超时
                let _ = try? peripheral.read(deviceCharacteristic, timeout: 1)
            }
        }
        
        let (transferRsp, transferError) = try queue.pop()
        guard transferError == nil else { throw LEPeripheralError.unlikely(error!) }
        guard transferRsp.elementsEqual([FLAG_RSP, CMD_REQ_TRANSFER, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(transferRsp) }
        
        // write crc
        let bytes = fileData.bytes
        let crc: UInt16 = self.crc16(bytes)
        let crcData = Data(bytes: [CMD_REQ_CRC, UInt8(crc & 0xFF), UInt8((crc >> 8) & 0xFF)])
        try peripheral.write(crcData, to: fwPointCharacteristic)
        let (crcRsp, crcError) = try queue.pop()
        guard crcError == nil else { throw LEPeripheralError.unlikely(error!) }
        guard crcRsp.elementsEqual([FLAG_RSP, CMD_REQ_CRC, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(crcRsp) }
        // progress
        let _ = progress((3 + dataGroups.count), total: allCommand)
        callback?(progress((3 + dataGroups.count), total: allCommand))
        
        // write restart
        if type == .system {
            try peripheral.write(Data(bytes: [CMD_REQ_RESTART]), to: fwPointCharacteristic)
            let (restartRsp, restartError) = try queue.pop()
            guard restartError == nil else { throw LEPeripheralError.unlikely(error!) }
            guard restartRsp.elementsEqual([FLAG_RSP, CMD_REQ_RESTART, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(restartRsp) }
            let _ = progress((4 + dataGroups.count), total: allCommand)
            callback?(progress((4 + dataGroups.count), total: allCommand))
        }
    }
    
    public func firmwareUpdateCancel() {
        canContinueFirmwareUpdate = false
    }
    
    func progress(_ currentIndex: Int, total: Int) -> Int {
        return Int((Double(currentIndex) / Double(total)) * 100)
    }

    func crc16(_ buffer: [UInt8], initValue: UInt16 = 0xffff) -> UInt16 {
        var crc: UInt16 = initValue
        for b in buffer {
            crc = (crc >> 8) | (crc << 8)
            crc ^= UInt16(b)
            crc ^= (crc & 0xff) >> 4
            crc ^= crc << 12
            crc ^= (crc & 0xff) << 5
        }
        
        return crc
    }
}
