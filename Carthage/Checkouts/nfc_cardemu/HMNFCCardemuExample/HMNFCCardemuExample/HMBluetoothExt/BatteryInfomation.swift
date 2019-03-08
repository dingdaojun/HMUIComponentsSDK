//
//  BatteryInfomation.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/9.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

public enum BatteryStatus: UInt8 {
    case unknown = 0x10
    case normal = 0x00
    case lowPower = 0x01
    case charging = 0x02
    case full = 0x03
    case chargeOff = 0x04
}

public struct BatteryInfomation {
    var lastChargeDate: Date?
    var lastFullChargeDate: Date?
    var batteryStatus: BatteryStatus = .normal
    var level: Int = 0
    
    init(_ data: Data) throws {
        try self.batteryInfoDataHandle(data: data)
    }
    
    fileprivate mutating func batteryInfoDataHandle(data: Data) throws {
        let bytes = [UInt8](data)
        level = Int(bytes[1])
        let flag = bytes[0] & 0xFF
        
        if (flag & UInt8(0x01)) != 0 {
            guard data.count >= 3 else { throw NSError(domain: "model error", code: 0, userInfo: ["data": data]) }
            let hasDC = bytes[2] & 0xFF
            if hasDC != 0 {
                if level >= 100 {
                    batteryStatus = .full
                } else {
                    batteryStatus = .charging
                }
            } else {
                batteryStatus = .normal
            }
        }
        
        var index = 3
        let dateLength = 7
        if (flag & UInt8(0x02)) != 0 {
            let dateLastIndex = index + dateLength
            let dateBytes = [UInt8](bytes[index...dateLastIndex])
            lastFullChargeDate = Date.bytesToDate(bytes: dateBytes);
            index = dateLastIndex + 1
        }
        
        if (flag & UInt8(0x04)) != 0 {
            let dateBytes = [UInt8](bytes[index...(dateLength + index)])
            lastChargeDate = Date.bytesToDate(bytes: dateBytes);
        }
    }
}
