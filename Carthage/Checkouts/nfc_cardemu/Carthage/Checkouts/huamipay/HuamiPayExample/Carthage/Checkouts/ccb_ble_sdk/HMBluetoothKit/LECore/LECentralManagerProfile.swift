//
//  CentralManagerProfile.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/28.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth


/// 蓝牙状态
public enum HMBluetoothStatus {
    case unknow
    case notSupport
    case unauthorized
    case powerOff
    case reseting
    case ready
}

public enum LECentralManagerError: Error {
    case unlikely(Error)
    case poweroff(HMBluetoothStatus)
    case timeout
}

public protocol LECentralManagerProtocol {
    func didConnected(for peripheral: CBPeripheral)
    func didDisconnect(for peripheral: CBPeripheral, error: LECentralManagerError?)
    func didFailedConnect(for peripheral: CBPeripheral, error: LECentralManagerError?)
}

public struct LEScanResponse {
    public var rssi: Int
    public var advertisement: [String : Any]
    public var peripheral: CBPeripheral
}
