//
//  RealtimeSensorDataService.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/12.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

public struct SensorType: OptionSet {
    public var rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public static let gSensor = SensorType(rawValue: 0x01)
    public static let gyro = SensorType(rawValue: 0x10)
    public static let ppg = SensorType(rawValue: 0x02)
    public static let ecg = SensorType(rawValue: 0x04)
}

public struct SensorItem {
    public var sensorType: SensorType = .gSensor
    public var hz: Int = 25 // 1 ~ 100 HZ
    
    public init() {}
}

public class RealtimeSensorDataService: NSObject, RealtimeSensorDataProtocol {
    var peripheral: LEPeripheral
    lazy fileprivate var queue = BlockingQueue()
    lazy var keepConnectQueue = DispatchQueue(label: "keepConnect")
    fileprivate let serviceUUID = CBUUID(string: "FEE0")
    fileprivate let characteristicUUID = CBUUID(string: "00000001-0000-3512-2118-0009AF100700")
    fileprivate let dataCharacteristicUUID = CBUUID(string: "00000002-0000-3512-2118-0009AF100700")
    fileprivate let heartRateServiceUUID = CBUUID(string: "180D")
    fileprivate let heartRateCharacteristicUUID = CBUUID(string: "2A39")
    fileprivate var sensorCharacterisitic: CBCharacteristic?
    fileprivate var sensorDataCharacterisitc: CBCharacteristic?
    fileprivate var heartRateCharacterisitic: CBCharacteristic?
    fileprivate let FLAG_RSP: UInt8 = 0x10
    fileprivate let FLAG_RSP_OK: UInt8 = 0x01
    fileprivate let CMD_REQ_HEARTRATE_OPEN = Data([0x15, 0x01, 0x01])
    fileprivate let CMD_REQ_HEARTRATE_CLOSE = Data([0x15, 0x01, 0x00])
    fileprivate let CMD_REQ_SETTING: UInt8 = 0x01
    fileprivate let CMD_REQ_OPEN: UInt8 = 0x02
    fileprivate let CMD_REQ_CLOSE: UInt8 = 0x03
    fileprivate var keepConnectTimer: Timer?
    fileprivate var sensorItem: SensorItem?
    var repeatingTimer: RepeatingTimer?
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    /// 注册开启实时传感器数据
    ///
    /// - Parameters:
    ///   - item: 入参
    ///   - calback: 传感器实时数据返回
    /// - Throws: Error
    public func registerRealtimeSensorDataNotification(item: SensorItem, calback: @escaping SensorDataCallback) throws {
        sensorItem = item
        if item.sensorType.contains(.ppg) {
            heartRateCharacterisitic = try peripheral.characteristic(heartRateCharacteristicUUID, in: heartRateServiceUUID)
            try peripheral.write(CMD_REQ_HEARTRATE_OPEN, to: heartRateCharacterisitic!)
        }

        sensorCharacterisitic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        sensorDataCharacterisitc = try peripheral.characteristic(dataCharacteristicUUID, in: serviceUUID)
        try peripheral.setNotify(true, for: sensorCharacterisitic!) { [weak self] in
            if let sf = self {
                let valueData = sf.sensorCharacterisitic!.value!
                let valueBytes = valueData.bytes
                if valueBytes[1] == sf.CMD_REQ_OPEN {
                    if !valueData.starts(with: [sf.FLAG_RSP, sf.CMD_REQ_OPEN, sf.FLAG_RSP_OK]) {
                        calback(valueData, LEPeripheralError.invailedResponse(valueData))
                    }
                } else {
                    sf.queue.push(($1.value!, $2))
                }
            }
        }
        
        try peripheral.writeNoRsp(Data([CMD_REQ_SETTING, item.sensorType.rawValue, UInt8(item.hz)]), to: sensorCharacterisitic!)
        let (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.starts(with: [FLAG_RSP, CMD_REQ_SETTING, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
        
        try peripheral.setNotify(true, for: sensorDataCharacterisitc!) { (_, ch, error) in
            calback(ch.value!, nil)
            if error != nil { fatalError("read sensor data notify has error: \(String(describing: error))") }
        }
        
        // 创建定时器
        repeatingTimer = RepeatingTimer()
        repeatingTimer?.eventHandler = { [weak self] in
            self?.keepConnect()
        }
        repeatingTimer?.resume()
        try peripheral.writeNoRsp(Data([CMD_REQ_OPEN]), to: sensorCharacterisitic!)
    }
    
    /// 取消注册实时传感器数据广播
    ///
    /// - Throws: Error
    public func unregisterRealtimeSensorDataNotification() throws {
        stopConnectTimer()
        if let heartRateCh = heartRateCharacterisitic { try peripheral.write(CMD_REQ_HEARTRATE_CLOSE, to: heartRateCh) }
        guard let sensorCh = sensorCharacterisitic, let sensorDataCh = sensorDataCharacterisitc  else { return }
        try peripheral.writeNoRsp(Data([CMD_REQ_CLOSE]), to: sensorCh)
        let (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.elementsEqual([FLAG_RSP, CMD_REQ_CLOSE, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
        
        try peripheral.setNotify(false, for: sensorCh)
        try peripheral.setNotify(false, for: sensorDataCh)
    }
    
    func stopConnectTimer() {
        keepConnectTimer?.invalidate()
        keepConnectTimer = nil
    }
    
    func keepConnect() {
        guard let sensorCh = sensorCharacterisitic  else {
            stopConnectTimer()
            return
        }
        do {
            try peripheral.writeNoRsp(Data([0x00]), to: sensorCh)
            if let heartRateCh = heartRateCharacterisitic { try peripheral.write(Data([0x16]), to: heartRateCh) }
        } catch  {
            print("keepConnect failed: \(error)")
        }
    }
    
    deinit {
        stopConnectTimer()
    }
}
