//
//  HMBluetoothPeripheralManager+PublicApi.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/16.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

extension LEPeripheral {
    
    /// subscribe modify service: when service modify, will callback
    ///
    /// - Parameter callback: callback
    public func subscribeModifyService(_ callback: @escaping ModifyServiceCallback) {
        modifyServiceCallback = callback
    }
    
    /// discover services
    ///
    /// - Parameter serviceUUIDs: service UUIDs, recommend: at least a base service
    /// - Throws: Error
    public func discoverServices(_ serviceUUIDs: [CBUUID]? = nil) throws {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        let rsp = try self.wait {
            self.peripheral.discoverServices(serviceUUIDs)
        }
        
        guard case let .discoverService(_, error) = rsp else {
            print("illegalResponse: rsp=\(rsp); real=discoverService")
            throw LEPeripheralError.illegalResponse
        }
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
    }
    
    /// discover characterisitc
    ///
    /// - Parameters:
    ///   - characteristicUUIDs: characteristic uuid
    ///   - service: service
    /// - Throws: Error
    public func discoverCharacteristic(_ characteristicUUIDs: [CBUUID]?, for service: CBService) throws {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        let rsp = try self.wait {
            self.peripheral.discoverCharacteristics(nil, for: service)
        }
        guard case let .discoverCharacteristic(_, _ , error) = rsp else {
            print("illegalResponse: rsp=\(rsp); real=discoverCharacteristic")
            throw LEPeripheralError.illegalResponse
        }
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
    }
    
    /// set notify: true/false
    ///
    /// - Parameters:
    ///   - enabled: true/false
    ///   - characteristic: characteristic
    ///   - callback: when enabled is true, you can receive data from characterisc data by updateValue
    /// - Throws: callback
    public func setNotify(_ enabled: Bool, for characteristic: CBCharacteristic, callback: LESynchronizedPeripheralProtocol.NotifyCallback? = nil) throws {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        if enabled {
            if let notifyCallBack = callback {
                notifyCallBackDictionary[characteristic.identifier] = [notifyCallBack]
            }
        } else {
            notifyCallBackDictionary.removeValue(forKey: characteristic.identifier)
        }
        
        let rsp = try self.wait { self.peripheral.setNotifyValue(enabled, for: characteristic) }
        guard case let .setNotifyValue(_, _, error) = rsp else {
            throw LEPeripheralError.illegalResponse
        }
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
    }
    
    /// read characterisitic value
    ///
    /// - Parameter characteristic: characteristic
    /// - Returns: value
    /// - Throws: Error
    public func read(_ characteristic: CBCharacteristic, timeout: Int = DEFAULT_TIMEOUT) throws -> Data {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        let rsp = try self.wait(timeout, for: {
            self.pendingReadRequestQueue.async { self.hasPendingReadRequest.insert(characteristic.uuid) }
            self.peripheral.readValue(for: characteristic)
        })
        
        pendingReadRequestQueue.sync { let _ = hasPendingReadRequest.remove(characteristic.uuid) }
        guard case let .readCharacteristic(_, ch , error) = rsp else {
            throw LEPeripheralError.illegalResponse
        }
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard let dataValue = ch.value else { throw LEPeripheralError.dataLost }
        return dataValue
    }
    
    /// write
    ///
    /// - Parameters:
    ///   - data: data
    ///   - characteristic: characteristic
    /// - Throws: Error
    public func write(_ data: Data, to characteristic: CBCharacteristic) throws {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        let rsp = try self.wait {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
        
        guard case let .writeCharacteristic(_, _, error) = rsp else {
            print("illegalResponse: rsp=\(rsp); real=writeCharacteristic")
            throw LEPeripheralError.illegalResponse
        }
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
    }
    
    /// write without no response
    ///
    /// - Parameters:
    ///   - data: data
    ///   - characteristic: characteristic
    ///   - timeout: timeout
    /// - Throws: Error
    public func writeNoRsp(_ data: Data, to characteristic: CBCharacteristic, timeout: Int = DEFAULT_TIMEOUT) throws {
        guard peripheral.state == .connected,
              LECentralManager.sharedInstance.bleutoothStatus == .ready else {
            throw LEPeripheralError.unConnected
        }
//
//        guard requestSemaphore.wait(timeout: .now() + .seconds(timeout)) == .success else {
//            throw LEPeripheralError.timeout
//        }
//
//        defer {
//            requestSemaphore.signal()
//        }
//
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
    
    /// read RSSI
    ///
    /// - Returns: RSSI value
    /// - Throws: Error
    public func readRSSI() throws -> Int8 {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }

        let rsp = try self.waitReadRSSI {
            self.peripheral.readRSSI()
        }
        
        guard case let .readRSSI(_, rssi , error) = rsp else {
            print("illegalResponse: rsp=\(rsp); real=readRSSI")
            throw LEPeripheralError.illegalResponse
        }
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        return rssi.int8Value
    }
    
    /// help method: discover all service and characterisitc
    ///
    /// - Throws: Error
    public func discoverAllServiceAndCharacteristics() throws {
        try discoverServices()
        if let s = peripheral.services {
            for service in s {
                try discoverCharacteristic(nil, for: service)
            }
        }
    }
    
    /// get CBCharacteristic with characteristic UUID and service UUID
    ///
    /// - Parameters:
    ///   - characteristicUUID: characteristic UUID
    ///   - serviceUUID: service UUID
    /// - Returns: CBCharacteristic
    /// - Throws: Error
    public func characteristic(_ characteristicUUID: CBUUID, in serviceUUID: CBUUID) throws -> CBCharacteristic {
        var ch: CBCharacteristic?
        
        if let servicesArray = peripheral.services {
            for services in servicesArray {
                if services.uuid == serviceUUID {
                    if let characteristicsArray = services.characteristics {
                        for characteristic in characteristicsArray {
                            if characteristicUUID == characteristic.uuid {
                                ch = characteristic
                                break
                            }
                        }
                    }
                }
            }
        }
        
        guard let characteristic = ch else { throw LEPeripheralError.unFindCharacteristic }
        return characteristic
    }
    
    public func read(_ descriptor: CBDescriptor) throws -> Data {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    public func write(_ data: Data, to descriptor: CBDescriptor) throws {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    public func discoverDescriptors(for characteristic: CBCharacteristic) throws {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
    
    public func discoverIncludedServices(_ includedServiceUUIDs: [CBUUID]? = nil, for service: CBService) throws {
        // TODO
        fatalError("NOT IMPLEMENTED")
    }
}

extension LEPeripheral {
    fileprivate func wait(_ timeout: Int = DEFAULT_TIMEOUT, for execution: () -> Void) throws -> LEPeripheralResponse {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        guard requestSemaphore.wait(timeout: .now() + .seconds(timeout)) == .success else {
            throw LEPeripheralError.timeout
        }
        
        defer {
            requestSemaphore.signal()
        }
        
        execution()
        
        guard responseSemaphore.wait(timeout: .now() + .seconds(timeout)) == .success else {
            throw LEPeripheralError.timeout
        }
        
        return response!
    }
    
    fileprivate func waitReadRSSI(for execution: () -> Void) throws -> LEPeripheralResponse {
        guard peripheral.state == .connected else {
            throw LEPeripheralError.unConnected
        }
        
        guard readRSSIRequestSemaphore.wait(timeout: .now() + .seconds(DEFAULT_TIMEOUT)) == .success else {
            throw LEPeripheralError.timeout
        }
        
        defer {
            readRSSIRequestSemaphore.signal()
        }
        
        execution()
        
        guard readRSSIResponseSemaphore.wait(timeout: .now() + .seconds(DEFAULT_TIMEOUT)) == .success else {
            throw LEPeripheralError.timeout
        }
        
        return response!
    }
}
