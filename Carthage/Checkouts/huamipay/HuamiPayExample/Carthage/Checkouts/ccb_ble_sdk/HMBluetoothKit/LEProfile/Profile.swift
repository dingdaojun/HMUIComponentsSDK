//
//  Profile.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/2/27.
//

import Foundation

public class Profile: ProfileProtocol {
    public var peripheral: LEPeripheral
    public private(set) var deviceInfomationService: DeviceInfomationService
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
        self.deviceInfomationService = DeviceInfomationService(peripheral: peripheral)
    }
}

extension Profile: DeviceInfomationProtocol {
    public func getSoftwareRevision() throws -> String {
        return try deviceInfomationService.getSoftwareRevision()
    }
    
    public func getFirmwareRevision() throws -> String {
        return try deviceInfomationService.getFirmwareRevision()
    }
    
    public func getHardwareRevision() throws -> String {
        return try deviceInfomationService.getHardwareRevision()
    }
    
    public func getManufacturerName() throws -> String {
        return try deviceInfomationService.getManufacturerName()
    }
    
    public func getModelNumber() throws -> String {
        return try deviceInfomationService.getModelNumber()
    }
    
    public func getSerialNumber() throws -> String {
        return try deviceInfomationService.getSerialNumber()
    }
    
    public func getSystemID() throws -> Data {
        return try deviceInfomationService.getSystemID()
    }
    
    public func getRegulatoryCertificationDataList() throws -> Data {
        return try deviceInfomationService.getRegulatoryCertificationDataList()
    }
    
    public func getPnPID() throws -> Data {
        return try deviceInfomationService.getPnPID()
    }
}
