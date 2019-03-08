//
//  DeviceInfomationService.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/10.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth


public class DeviceInfomationService: DeviceInfomationProtocol {
    var peripheral: LEPeripheral
    fileprivate let serviceUUID: CBUUID = CBUUID(string: "180A")
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    /// read software revision
    ///
    /// - Returns: software revision
    /// - Throws: Error
    public func getSoftwareRevision() throws -> String {
        let characteristic = try peripheral.characteristic(CBUUID(string: "2A28"), in: serviceUUID)
        let readData = try peripheral.read(characteristic)
        return String.init(data: readData, encoding: .utf8)!
    }
    
    public func getFirmwareRevision() throws -> String {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    /// read hardware revision
    ///
    /// - Returns: hardware revision
    /// - Throws: Error
    public func getHardwareRevision() throws -> String {
        let characteristic = try peripheral.characteristic(CBUUID(string: "2A27"), in: serviceUUID)
        let readData = try peripheral.read(characteristic)
        return String.init(data: readData, encoding: .utf8)!
    }
    
    public func getManufacturerName() throws -> String {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    public func getModelNumber() throws -> String {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    /// read serial number
    ///
    /// - Returns: serial number
    /// - Throws: Error
    public func getSerialNumber() throws -> String {
        let characteristic = try peripheral.characteristic(CBUUID(string: "2A25"), in: serviceUUID)
        let readData = try peripheral.read(characteristic)
        return String.init(data: readData, encoding: .utf8)!
    }
    
    /// read system id(device id), macaddress will come from here
    ///
    /// - Returns: data
    /// - Throws: Error
    public func getSystemID() throws -> Data {
        let characteristic = try peripheral.characteristic(CBUUID(string: "2A23"), in: serviceUUID)
        return try peripheral.read(characteristic)
    }
    
    public func getRegulatoryCertificationDataList() throws -> Data {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    /// read pnp id
    ///
    /// - Returns: data
    /// - Throws: Error
    public func getPnPID() throws -> Data {
        let characteristic = try peripheral.characteristic(CBUUID(string: "2A50"), in: serviceUUID)
        return try peripheral.read(characteristic)
    }
}
