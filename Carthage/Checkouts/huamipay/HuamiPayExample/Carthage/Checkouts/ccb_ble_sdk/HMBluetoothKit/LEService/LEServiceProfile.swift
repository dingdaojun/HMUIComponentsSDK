//
//  LEServiceProfile.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/2.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

public typealias DataCallback = (Data) -> Void
public typealias SensorDataCallback = (Data, LEPeripheralError?) -> Void

public protocol AuthProtocol {
    func authorize(appid: Int, key: [UInt8]) throws
    func authenticate(appid: Int, key: [UInt8]) throws
}

public protocol ActivityDataProtocol {
    func getTotalActivityData(from date: Date) throws -> [(date: Date, data: Data, minute: Int)]
}

public protocol RealtimeSensorDataProtocol {
    func registerRealtimeSensorDataNotification(item: SensorItem, calback: @escaping SensorDataCallback) throws
    func unregisterRealtimeSensorDataNotification() throws
}

public protocol RealtimeStepsProtocol {
    func getStep() throws -> Data
    func registerRealtimeStepsNotification(callback: @escaping DataCallback) throws
    func unregisterRealtimeStepsNotification() throws
}

public protocol GenericProtocol {
    func getBatteryInfomation() throws -> Data
    func updatePeripheralTime(_ date: Date) throws
    func deviceShock() throws
}

public protocol UserInfoProtocol {
    func wearLocation(_ type: WearLocType, isLeft: Bool) throws
}

public protocol NFCProtocol {
    func openApdu() throws
    func closeApdu() throws
    func sendApdu(_ apdu: Data, cmdLength: Int, isEncryp: Bool) throws -> (rawData: Data, length: Int)
    func getMiFareTag() throws -> Data
    func swapAid(_ aid: Data?, for type: SwapAidType) throws
}

public protocol FirmwareUpdateProtocol {
    typealias FirmwareUpdateCallback = (_ progress: Int) -> Void
    func firmwareUpdate(_ fileData: Data, type: UpgradeFirmwareType, callback: FirmwareUpdateCallback?) throws
    func firmwareUpdateCancel()
}

public protocol DeviceInfomationProtocol {
    func getSoftwareRevision() throws -> String
    func getFirmwareRevision() throws -> String
    func getHardwareRevision() throws -> String
    func getManufacturerName() throws -> String
    func getModelNumber() throws -> String
    func getSerialNumber() throws -> String
    func getSystemID() throws -> Data
    func getRegulatoryCertificationDataList() throws -> Data
    func getPnPID() throws -> Data
}

public protocol ECFProtocol {
    func setECF(with value: Int, for type: ECFType) throws
}
