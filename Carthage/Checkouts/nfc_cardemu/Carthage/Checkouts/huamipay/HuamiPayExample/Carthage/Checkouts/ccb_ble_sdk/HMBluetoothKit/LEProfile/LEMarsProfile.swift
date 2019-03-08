//
//  LEMarsProfile.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/3/2.
//

import Foundation

public class LEMarsProfile: Profile {
    public private(set) var authService: MarsAuthService
    public private(set) var sensorService: RealtimeSensorDataService
    
    override public init(peripheral: LEPeripheral) {
        authService = MarsAuthService(peripheral: peripheral)
        sensorService = RealtimeSensorDataService(peripheral: peripheral)
        super.init(peripheral: peripheral)
    }
}

extension LEMarsProfile: AuthProtocol {
    public func authorize(appid: Int, key: [UInt8]) throws {
        try authService.authorize(appid: appid, key: key)
    }
    
    public func authenticate(appid: Int, key: [UInt8]) throws {
        try authService.authenticate(appid: appid, key: key)
    }
}

extension LEMarsProfile: RealtimeSensorDataProtocol {
    public func registerRealtimeSensorDataNotification(item: SensorItem, calback: @escaping SensorDataCallback) throws {
        try sensorService.registerRealtimeSensorDataNotification(item: item, calback: calback)
    }
    
    public func unregisterRealtimeSensorDataNotification() throws {
        try sensorService.unregisterRealtimeSensorDataNotification()
    }
}
