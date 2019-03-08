//
//  GattProfile.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/28.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

public let DEFAULT_TIMEOUT = 5

public enum LEPeripheralError: Error {
    case unlikely(Error)
    case invailedResponse(Data)
    case timeout
    case unConnected
    case unFindCharacteristic
    case unFindService
    case dataLost
    case illegalResponse
    case firmwareUpdateFailed
}

public enum LEPeripheralResponse {
    case discoverService(CBPeripheral, Error?)
    case discoverIncludedServices(CBPeripheral, CBService, Error?)
    case discoverCharacteristic(CBPeripheral, CBService, Error?)
    case discoverDescriptors(CBPeripheral, CBCharacteristic, Error?)
    case readCharacteristic(CBPeripheral, CBCharacteristic, Error?)
    case writeCharacteristic(CBPeripheral, CBCharacteristic, Error?)
    case readDescriptor(CBPeripheral, CBCharacteristic, Error?)
    case writeDescriptor(CBPeripheral, CBCharacteristic, Error?)
    case setNotifyValue(CBPeripheral, CBCharacteristic, Error?)
    case readRSSI(CBPeripheral, NSNumber, Error?)
}

public protocol LESynchronizedPeripheralProtocol: class {
    typealias NotifyCallback = (CBPeripheral, CBCharacteristic, Error?) -> Void
    typealias ModifyServiceCallback = ([CBService]) -> Void
    
    func subscribeModifyService(_ callback: @escaping ModifyServiceCallback)
    func discoverServices(_ serviceUUIDs: [CBUUID]?) throws
    func discoverCharacteristic(_ characteristicUUIDs: [CBUUID]?, for service: CBService) throws
    func discoverDescriptors(for characteristic: CBCharacteristic) throws
    func setNotify(_ enabled: Bool, for characteristic: CBCharacteristic, callback: NotifyCallback?) throws
    func read(_ characteristic: CBCharacteristic, timeout: Int) throws -> Data
    func write(_ data: Data, to characteristic: CBCharacteristic) throws
    func writeNoRsp(_ data: Data, to characteristic: CBCharacteristic, timeout: Int) throws
    func read(_ descriptor: CBDescriptor) throws -> Data
    func write(_ data: Data, to descriptor: CBDescriptor) throws
    func readRSSI() throws -> Int8
}

extension LESynchronizedPeripheralProtocol {
    public func characteristic(_ characteristicUUID: CBUUID, in serviceUUID: CBUUID) throws -> CBCharacteristic {
        fatalError("Not Implemented")
    }
    
    public func discoverIncludedServices(_ includedServiceUUIDs: [CBUUID]? = nil, for service: CBService) throws {
        fatalError("Not Implemented")
    }
    
    public func discoverAllServiceAndCharacteristics() throws {
        fatalError("Not Implemented")
    }
}
