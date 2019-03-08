//
//  ActivityDataService.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/10.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

public enum SyncType: UInt8 {
    case bandData = 1
    case heartRate = 2
    case ecg = 3
    case temperature = 4
    case sportSummary = 5
    case sportNodes = 6
    case gpsLog = 7
    case sport = 100
}

public class ActivityDataService: ActivityDataProtocol {
    var peripheral: LEPeripheral
    lazy fileprivate var queue = BlockingQueue()
    fileprivate let serviceUUID = CBUUID(string: "FEE0")
    fileprivate let characteristicsUUID = CBUUID(string: "00000004-0000-3512-2118-0009AF100700")
    fileprivate let dataCharacteristicsUUID = CBUUID(string: "00000005-0000-3512-2118-0009AF100700")
    fileprivate let FLAG_RSP: UInt8 = 0x10
    fileprivate let FLAG_RSP_OK: UInt8 = 0x01
    fileprivate let CMD_REQ_GETSIZE: UInt8 = 0x01
    fileprivate let CMD_REQ_TRANSFOR_START: UInt8 = 0x02
    fileprivate let CMD_REQ_TRANSFOR_STOP: UInt8 = 0x03
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    public func getTotalActivityData(from date: Date) throws -> [(date: Date, data: Data, minute: Int)] {
        let characteristic = try peripheral.characteristic(characteristicsUUID, in: serviceUUID)
        let dataCharacteristic = try peripheral.characteristic(dataCharacteristicsUUID, in: serviceUUID)
        try peripheral.setNotify(true, for: characteristic, callback: { [weak self] in self?.queue.push(($1.value!, $2)) })
        var syncDate = date
        var syncData: [(Date, Data, Int)] = []
        typealias BufferQueue = ValueSemaphore<Data>
        let bufferQueue = BufferQueue()
        try peripheral.setNotify(true, for: dataCharacteristic) { (_, ch, _) in bufferQueue.push(ch.value!) }
        while true {
            let (startDate, minute) = try self.getSize(from: syncDate)
            guard minute != 0 else { break }
            var currentIndex: Int = -1
            syncDate = startDate.addingTimeInterval(TimeInterval(minute * 60))
            try peripheral.writeNoRsp(Data([CMD_REQ_TRANSFOR_START]), to: characteristic)
            var chunkData = Data()
            while true {
                var bufferData = try bufferQueue.pop()
                let dataIndex = Int(bufferData.bytes[0])
                if dataIndex != (currentIndex + 1) { throw LEPeripheralError.dataLost }
                let realData = bufferData.subdata(in: 1..<bufferData.count)
                chunkData.append(realData)
                if chunkData.count == (minute * 4) { break }
                currentIndex = dataIndex
                if currentIndex == 255 { currentIndex = -1 }
            }
            let (value, error) = try queue.pop()
            guard error == nil else { throw LEPeripheralError.unlikely(error!) }
            guard value.starts(with: [FLAG_RSP, CMD_REQ_TRANSFOR_START, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
            syncData.append((startDate, chunkData, minute))
        }
        return syncData
    }
    
    public func getSize(from date: Date) throws -> (Date, Int) {
        let characteristic = try peripheral.characteristic(characteristicsUUID, in: serviceUUID)
        var bytes: [UInt8] = [CMD_REQ_GETSIZE, SyncType.bandData.rawValue & 0xFF]
        bytes += date.toBleBytes()
        bytes += [UInt8(TimeZone.current.bleOffset() & 0xFF)]
        try peripheral.writeNoRsp(Data(bytes), to: characteristic)
        let (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.starts(with: [FLAG_RSP, CMD_REQ_GETSIZE, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
        let sizeBytes = value.bytes
        let totalMinute = Array(sizeBytes[3...6]).toInt()
        let currentDate = Date.bytesToDate(bytes: Array(sizeBytes[7...13]));
        return (currentDate!, totalMinute)
    }

    public func stopSync() throws {
        let characteristic = try peripheral.characteristic(characteristicsUUID, in: serviceUUID)
        let dataCharacteristic = try peripheral.characteristic(dataCharacteristicsUUID, in: serviceUUID)
        try peripheral.setNotify(false, for: characteristic)
        try peripheral.setNotify(false, for: dataCharacteristic)
    }
}
