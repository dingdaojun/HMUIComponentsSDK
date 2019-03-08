//
//  SettingService.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/3/13.
//

import Foundation
import CoreBluetooth

public enum LEUserInfoType: UInt16 {
    case birth = 1
    case gender = 2
    case height = 4
    case weight = 8
    case actgoal = 16
    case sensorLoc = 32
    case uid = 64
    case readFuc = 32768
}

public enum WearLocType: Int {
    case other = 0
    case chest = 1
    case wrist = 2
    case finger = 3
    case hand = 4
    case earLobe = 5
    case foot = 7
}

public class UserInfoService: UserInfoProtocol {
    var peripheral: LEPeripheral
    fileprivate let userIndex: UInt8 = 0x00
    fileprivate let service = CBUUID(string: "FEE0")
    fileprivate let characteristicUUID = CBUUID(string: "00000008-0000-3512-2118-0009AF100700")
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    /// 穿戴位置
    ///
    /// - Parameters:
    ///   - type: 穿戴位置，如手腕、手指等
    ///   - isLeft: 左右
    /// - Throws: Error
    public func wearLocation(_ type: WearLocType, isLeft: Bool) throws {
        let characteristic = try peripheral.characteristic(characteristicUUID, in: service)
        let readF = LEUserInfoType.sensorLoc.rawValue
        var bytes: [UInt8] = [UInt8(readF),
                              UInt8(readF >> 8),
                              userIndex]
        if isLeft {
            bytes.append(UInt8(type.rawValue & (~(1 << 7))))
        } else {
            bytes.append(UInt8(type.rawValue | (1 << 7)))
        }
        try peripheral.write(Data(bytes), to: characteristic)
    }
}
