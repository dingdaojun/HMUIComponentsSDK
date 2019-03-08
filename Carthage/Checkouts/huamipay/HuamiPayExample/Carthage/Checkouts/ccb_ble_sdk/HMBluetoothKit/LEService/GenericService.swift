//
//  GenericService.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/10.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth


public class GenericService: GenericProtocol, RealtimeStepsProtocol {
    var peripheral: LEPeripheral
    fileprivate let realStepServiceUUID = CBUUID(string: "FEE0")
    fileprivate let realStepCharacterisitcUUID = CBUUID(string: "00000007-0000-3512-2118-0009AF100700")
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    /// read battery infomation
    ///
    /// - Returns: Data, you need analysis
    /// - Throws: Error
    public func getBatteryInfomation() throws -> Data {
        let serviceUUID: CBUUID = CBUUID(string: "FEE0")
        let characteristicUUID: CBUUID = CBUUID(string: "00000006-0000-3512-2118-0009AF100700")
        let characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        return try peripheral.read(characteristic)
    }
    
    
    /// read current steps infomation
    ///
    /// - Returns: Data: you need analysis
    /// - Throws: Error
    public func getStep() throws -> Data {
        let characteristic = try peripheral.characteristic(realStepCharacterisitcUUID, in: realStepServiceUUID)
        return try peripheral.read(characteristic)
    }
    
    /// update peripehral time: default is currenT date
    ///
    /// - Parameter date: Date
    /// - Throws: Error
    public func updatePeripheralTime(_ date: Date) throws {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
        // 时间写入，总共是11位，第9，10位为空
        let timeBytes: [UInt8] = [dateComponents.year!.toU8,
                                  (dateComponents.year! >> 8).toU8,
                                  dateComponents.month!.toU8,
                                  dateComponents.day!.toU8,
                                  dateComponents.hour!.toU8,
                                  dateComponents.minute!.toU8,
                                  dateComponents.second!.toU8,
                                  dateComponents.weekday!.toU8,
                                  0x00,
                                  0x00,
                                  TimeZone.current.bleOffset().toU8]
        
        let serviceUUID = CBUUID(string: "FEE0")
        let characteristicUUID = CBUUID(string: "2A2B")
        let characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        try peripheral.write(Data(timeBytes), to: characteristic)
    }
    
    /// register real time steps notification
    ///
    /// - Parameter callback: when steps infomation come, will callback
    /// - Throws: Error
    public func registerRealtimeStepsNotification(callback: @escaping DataCallback) throws {
        let characteristic = try peripheral.characteristic(realStepCharacterisitcUUID, in: realStepServiceUUID)
        try peripheral.setNotify(true, for: characteristic, callback: { (_, ch, error) in
            callback(ch.value!)
            if error != nil { fatalError("read step data notify has error: \(String(describing: error))") }
        })
    }
    
    /// un register real time steps notification
    ///
    /// - Throws: Error
    public func unregisterRealtimeStepsNotification() throws {
        let characteristic = try peripheral.characteristic(realStepCharacterisitcUUID, in: realStepServiceUUID)
        try peripheral.setNotify(false, for: characteristic)
    }
    
    /// try to make device shock, like find device
    ///
    /// - Throws: Error
    public func deviceShock() throws {
        let serviceUUID: CBUUID = CBUUID(string: "1802")
        let characteristicUUID: CBUUID = CBUUID(string: "2A06")
        let characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        try peripheral.writeNoRsp(Data(bytes: [0x03]), to: characteristic)
    }
}
