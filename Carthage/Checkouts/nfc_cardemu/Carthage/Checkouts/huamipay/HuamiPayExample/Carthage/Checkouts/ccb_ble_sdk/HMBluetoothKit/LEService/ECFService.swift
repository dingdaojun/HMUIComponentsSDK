//
//  ECFService.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/7/18.
//

import Foundation
import CoreBluetooth

public enum ECFType: UInt8 {
    // 蓝牙广播
    case advertisement = 0x01
    // 时间格式, 12/24小时制
    case timeFormat = 0x02
    // 里程单位(0:KM, 1: mile)
    case mileAgeUnit = 0x03
    // 显示选项
    case displayItem = 0x04
    // 抬腕亮屏
    case wristBright = 0x05
    // 目标提醒
    case goalReminder = 0x06
    // 时间样式
    case timeDisplay = 0x0A
    // 转腕切屏
    case wristFlip = 0x0D
}


public class ECFService: ECFProtocol {
    var peripheral: LEPeripheral
    fileprivate let serviceUUID = CBUUID(string: "FEE0")
    fileprivate let characteristicUUID = CBUUID(string: "00000003-0000-3512-2118-0009AF100700")
    fileprivate let FLAG_RSP: UInt8 = 0x10
    fileprivate let FLAG_RSP_OK: UInt8 = 0x01
    fileprivate let CMD_REQ_SETTING: UInt8 = 0x06
    
    init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    public func setECF(with value: Int, for type: ECFType) throws {
        let characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        let queue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic) {
            print("data: \($1.value!.toHexString())")
            queue.push(($1.value!, $2))
        }
        
        let bytes: [UInt8] = [CMD_REQ_SETTING,
                              (UInt8(type.rawValue) & 0xFF),
                              ((UInt8(type.rawValue) >> 8) & 0xFF),
                              value.toU8]
        
        try peripheral.writeNoRsp(Data.init(bytes: bytes), to: characteristic)
        let (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.bytes[0] == FLAG_RSP,
              value.bytes.last == FLAG_RSP_OK,
              value.bytes[1] == CMD_REQ_SETTING,
              value.bytes[2] == (UInt8(type.rawValue) & 0xFF),
              value.bytes[3] == ((UInt8(type.rawValue) >> 8) & 0xFF) else {
            throw LEPeripheralError.invailedResponse(value)
        }
    }
}
