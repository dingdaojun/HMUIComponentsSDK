//
//  LEMIBandProfile.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/6/26.
//

import Foundation


public class LEMIBandProfile: Profile {
    public private(set) var authService: AuthService
    public private(set) var sensorService: RealtimeSensorDataService
    public private(set) var activitySyncService: ActivityDataService
    public private(set) var genericService: GenericService
    public private(set) var userInfoService: UserInfoService
    public private(set) var ecfService: ECFService
    
    override public init(peripheral: LEPeripheral) {
        authService = AuthService(peripheral: peripheral)
        sensorService = RealtimeSensorDataService(peripheral: peripheral)
        activitySyncService = ActivityDataService(peripheral: peripheral)
        genericService = GenericService(peripheral: peripheral)
        userInfoService = UserInfoService(peripheral: peripheral)
        ecfService = ECFService(peripheral: peripheral)
        super.init(peripheral: peripheral)
    }
}

extension LEMIBandProfile: AuthProtocol {
    public func authorize(appid: Int, key: [UInt8]) throws {
        try authService.authorize(appid: appid, key: key)
    }
    
    public func authenticate(appid: Int, key: [UInt8]) throws {
        try authService.authenticate(appid: appid, key: key)
    }
}

extension LEMIBandProfile: RealtimeSensorDataProtocol {
    public func registerRealtimeSensorDataNotification(item: SensorItem, calback: @escaping SensorDataCallback) throws {
        try sensorService.registerRealtimeSensorDataNotification(item: item, calback: calback)
    }
    
    public func unregisterRealtimeSensorDataNotification() throws {
        try sensorService.unregisterRealtimeSensorDataNotification()
    }
}

extension LEMIBandProfile: ActivityDataProtocol {
    public func getTotalActivityData(from date: Date) throws -> [(date: Date, data: Data, minute: Int)] {
        return try activitySyncService.getTotalActivityData(from: date)
    }
}

extension LEMIBandProfile: GenericProtocol {
    public func getBatteryInfomation() throws -> Data {
        return try genericService.getBatteryInfomation()
    }
    
    public func updatePeripheralTime(_ date: Date) throws {
        try genericService.updatePeripheralTime(date)
    }
    
    public func deviceShock() throws {
        try genericService.deviceShock()
    }
}

extension LEMIBandProfile: UserInfoProtocol {
    public func wearLocation(_ type: WearLocType, isLeft: Bool) throws {
        try userInfoService.wearLocation(type, isLeft: isLeft)
    }
}

extension LEMIBandProfile: ECFProtocol {
    public func setECF(with value: Int, for type: ECFType) throws {
        try ecfService.setECF(with: value, for: type)
    }
}
