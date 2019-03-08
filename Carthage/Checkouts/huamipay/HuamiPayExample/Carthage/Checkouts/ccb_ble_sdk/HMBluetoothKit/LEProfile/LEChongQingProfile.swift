//
//  LEChongQingProfile.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/3/16.
//

import Foundation


public class LEChongQingProfile: Profile {
    public private(set) var authService: AuthService
    public private(set) var sensorService: RealtimeSensorDataService
    public private(set) var activitySyncService: ActivityDataService
    public private(set) var genericService: GenericService
    public private(set) var userInfoService: UserInfoService
    public private(set) var nfcService: NFCService
    public private(set) var firmwareUpdateService: FirmwareUpdateService
    public private(set) var ecfService: ECFService
    
    override public init(peripheral: LEPeripheral) {
        authService = AuthService(peripheral: peripheral)
        sensorService = RealtimeSensorDataService(peripheral: peripheral)
        activitySyncService = ActivityDataService(peripheral: peripheral)
        genericService = GenericService(peripheral: peripheral)
        userInfoService = UserInfoService(peripheral: peripheral)
        nfcService = NFCService(peripheral: peripheral)
        firmwareUpdateService = FirmwareUpdateService(peripheral: peripheral)
        ecfService = ECFService(peripheral: peripheral)
        super.init(peripheral: peripheral)
    }
}

extension LEChongQingProfile: AuthProtocol {
    public func authorize(appid: Int, key: [UInt8]) throws {
        try authService.authorize(appid: appid, key: key)
    }
    
    public func authenticate(appid: Int, key: [UInt8]) throws {
        try authService.authenticate(appid: appid, key: key)
    }
}

extension LEChongQingProfile: RealtimeSensorDataProtocol {
    public func registerRealtimeSensorDataNotification(item: SensorItem, calback: @escaping SensorDataCallback) throws {
        try sensorService.registerRealtimeSensorDataNotification(item: item, calback: calback)
    }
    
    public func unregisterRealtimeSensorDataNotification() throws {
        try sensorService.unregisterRealtimeSensorDataNotification()
    }
}

extension LEChongQingProfile: ActivityDataProtocol {
    public func getTotalActivityData(from date: Date) throws -> [(date: Date, data: Data, minute: Int)] {
        return try activitySyncService.getTotalActivityData(from: date)
    }
}

extension LEChongQingProfile: GenericProtocol {
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

extension LEChongQingProfile: UserInfoProtocol {
    public func wearLocation(_ type: WearLocType, isLeft: Bool) throws {
        try userInfoService.wearLocation(type, isLeft: isLeft)
    }
}

extension LEChongQingProfile: NFCProtocol {
    public func swapAid(_ aid: Data?, for type: SwapAidType) throws {
        try nfcService.swapAid(aid, for: type)
    }
    
    public func getMiFareTag() throws -> Data {
        return try nfcService.getMiFareTag()
    }
    
    public func openApdu() throws {
        try nfcService.openApdu()
    }
    
    public func closeApdu() throws {
        try nfcService.closeApdu()
    }
    
    public func sendApdu(_ apdu: Data, cmdLength: Int, isEncryp: Bool) throws -> (rawData: Data, length: Int) {
        return try nfcService.sendApdu(apdu, cmdLength: cmdLength, isEncryp: isEncryp)
    }
}

extension LEChongQingProfile: FirmwareUpdateProtocol {
    public func firmwareUpdate(_ fileData: Data, type: UpgradeFirmwareType, callback: FirmwareUpdateProtocol.FirmwareUpdateCallback?) throws {
        try firmwareUpdateService.firmwareUpdate(fileData, type: type, callback: callback)
    }
    
    public func firmwareUpdateCancel() {
        firmwareUpdateService.firmwareUpdateCancel()
    }
}

extension LEChongQingProfile: ECFProtocol {
    public func setECF(with value: Int, for type: ECFType) throws {
        try ecfService.setECF(with: value, for: type)
    }
}
