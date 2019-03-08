    //
//  HMPeripheralProtocol.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/6.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

public struct DeviceInfomation: Codable {
    var serial: String?
    var hardwareVersion: String?
    var softwareVersion: String?
    var deviceID: String?
    var companyID: String?
    var venderID: String?
    var productID: String?
    var productVersion: String?
    var macAddress: String?
}

public class HMPeripheralInfomation: NSObject, Codable  {
    public var name: String? = nil
    public var authKey: String?// 授权编码
    public var authDate: Date?// 授权时间
    public var syncDate: Date?// 同步时间
    public var deviceInfomation: DeviceInfomation?
    public var identifier: UUID?
    init(identifier id: UUID) { self.identifier = id }

    public static func ==(lhs: HMPeripheralInfomation, rhs: HMPeripheralInfomation) -> Bool {
        return lhs.deviceInfomation?.macAddress == rhs.deviceInfomation?.macAddress
    }
}
