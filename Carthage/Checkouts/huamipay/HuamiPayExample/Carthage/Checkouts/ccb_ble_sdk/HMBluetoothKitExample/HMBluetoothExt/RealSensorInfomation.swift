//
//  RealSensorInfomation.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/8.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

struct RealSensorInfomation {
    fileprivate var lastGSensorDataIndex: Int?
    fileprivate var lastPPGDataIndex: Int?
    fileprivate var lastGyroDataIndex: Int?

    public mutating func analysisBleData(_ data: Data) throws {
        guard data.count >= 2 else { throw NSError(domain: "data lost", code: 100, userInfo: nil) }
        let bytes: [UInt8] = [UInt8](data)
        let flag = bytes[0] & 0xFF
        let isSensor = (flag & SensorType.gSensor.rawValue) == 0 ? false : true
        let isPPG = (flag & SensorType.ppg.rawValue) == 0 ? false : true
        let isECG = (flag & SensorType.ecg.rawValue) == 0 ? false : true
        let isGyro = (flag & SensorType.gyro.rawValue) == 0 ? false : true
        let isTime = (bytes[0] == 0x80) ? true : false
        
        let currentIndex = Int(bytes[1] & 0xFF)
        var expectIndex = 0
        if isSensor {
            if lastGSensorDataIndex == nil { lastGSensorDataIndex = currentIndex - 1 }
            expectIndex = lastGSensorDataIndex! + 1
            if lastGSensorDataIndex == 255 { expectIndex = 0 }
        } else if isPPG {
            if lastPPGDataIndex == nil { lastPPGDataIndex = currentIndex - 1 }
            expectIndex = lastPPGDataIndex! + 1
            if lastPPGDataIndex == 255 { expectIndex = 0 }
        } else if isGyro {
            if lastGyroDataIndex == nil { lastGyroDataIndex = currentIndex - 1 }
            expectIndex = lastGyroDataIndex! + 1
            if lastGyroDataIndex == 255 { expectIndex = 0 }
        }
        
        if expectIndex != currentIndex {
            if isSensor {
                var emptyDataLen = currentIndex - lastGSensorDataIndex! - 1
                if currentIndex < lastGSensorDataIndex! {
                    emptyDataLen = 0
                }
                logW(tag: .sensorLose, format: "lost--gSensor: \(emptyDataLen); start: \(expectIndex)")
                for _ in 0..<emptyDataLen {
                    // 补数据
                    // let acc = "\(Int(0xFFFF)), \(Int(0xFFFF)), \(Int(0xFFFF))"
                }
            } else if isPPG {
                var emptyDataLen = currentIndex - lastPPGDataIndex! - 1
                if currentIndex < lastPPGDataIndex! {
                    emptyDataLen = 0
                }
                logW(tag: .sensorLose, format: "lost--PPG: \(emptyDataLen); start: \(expectIndex)")
                for _ in 0..<emptyDataLen {
                    // 补数据
                    // let ppg = "\(Int(0xFFFF))"
                }
            } else if isGyro {
                var emptyDataLen = currentIndex - lastGyroDataIndex! - 1
                if currentIndex < lastGyroDataIndex! {
                    emptyDataLen = 0
                }
                logW(tag: .sensorLose, format: "lost--Gyro: \(emptyDataLen); start: \(expectIndex)")
                for _ in 0..<emptyDataLen {
                    // 补数据
                    // let gyro = "\(Int(0xFFFF)), \(Int(0xFFFF)), \(Int(0xFFFF))"
                }
            }
        }
        
        if isSensor {
            lastGSensorDataIndex = currentIndex
            sensorRealDataHandleForGensorType(data: data)
        }
        if isPPG {
            lastPPGDataIndex = currentIndex
            sensorRealDataHandleForPPGType(data: data)
        }
        if isGyro {
            lastGyroDataIndex = currentIndex
            sensorRealDataHandleForGyroType(data: data)
        }
        if isECG { self.sensorRealDataHandleForECGType(data: data) }
        if isTime { self.sensorRealDataHandleForTimeType(data: data) }
    }
    
    private mutating func sensorRealDataHandleForGensorType(data: Data) {
        let bytes: [UInt8] = [UInt8](data)
        let sensorData = Data.init(bytes: bytes[2..<(bytes.count)])
        let group = sensorData.group(by: 6)
        for groupBytes in group {
            if groupBytes.count != 6 { continue }
//            print("Gensor: \(groupBytes)")
            let x = (Int16(groupBytes[0]) & 0xFF) | (Int16(groupBytes[1]) & 0xFF) << 8
            let y = (Int16(groupBytes[2]) & 0xFF) | (Int16(groupBytes[3]) & 0xFF) << 8
            let z = (Int16(groupBytes[4]) & 0xFF) | (Int16(groupBytes[5]) & 0xFF) << 8
            // 得到RX、RY、RZ
            let rx = Double(x) / 2000.0
            let ry = Double(y) / 2000.0
            let rz = Double(z) / 2000.0
            let r = sqrt(Double(rx * rx + ry * ry + rz * rz))
            let axr = acos(rx / r) * 180 / Double.pi
            let ayr = acos(ry / r) * 180 / Double.pi
            let azr = acos(rz / r) * 180 / Double.pi
            let acc = "\(x), \(y), \(z)"
            // acc数据
            print("acc: \(acc); 角度: \(axr, ayr, azr)")
        }
    }
    
    private mutating func sensorRealDataHandleForPPGType(data: Data) {
        guard data.count >= 4 else { return }
        let bytes: [UInt8] = [UInt8](data)
        let sample: UInt16 = UInt16((bytes[2] & 0xFF) | ((bytes[3] & 0xFF) << 8))
        let _ = "\(sample)"
        // ppg数据
//        print("ppg: \(ppg)")
    }
    
    private mutating func sensorRealDataHandleForGyroType(data: Data) {
        let bytes: [UInt8] = [UInt8](data)
        let sensorData = Data.init(bytes: bytes[2..<(bytes.count)])
        let group = sensorData.group(by: 6)
        for groupBytes in group {
            if groupBytes.count != 6 { continue }
//            print("gyro: \(groupBytes)")
            let x = (Int16(groupBytes[0]) & 0xFF) | (Int16(groupBytes[1]) & 0xFF) << 8
            let y = (Int16(groupBytes[2]) & 0xFF) | (Int16(groupBytes[3]) & 0xFF) << 8
            let z = (Int16(groupBytes[4]) & 0xFF) | (Int16(groupBytes[5]) & 0xFF) << 8
            let gyro = "\(x), \(y), \(z)"
            let gyr_x = Double(Double(x) / 32768 * 2000)
            let gyr_y = Double(Double(y) / 32768 * 2000)
            let gyr_z = Double(Double(z) / 32768 * 2000)
            // gyro数据
            print("gyro: \(gyro); gyr_x: \(gyr_x, gyr_y, gyr_z)")
        }
    }
    
    private mutating func sensorRealDataHandleForECGType(data: Data) {
//        guard data.count >= 4 else { return }
//        let bytes: [UInt8] = [UInt8](data)
//        let sample: UInt16 = UInt16((bytes[2] & 0xFF) | ((bytes[3] & 0xFF) << 8))
//        ecgSample = Int(sample)
//        print("ecgSample: \(String(describing: ecgSample))")
    }
    
    private mutating func sensorRealDataHandleForTimeType(data: Data) {
        guard data.count >= 7 else { return }
        let bytes: [UInt8] = [UInt8](data)
        let sensorType: UInt8 = bytes[2]
        let timeBytes = [UInt8](bytes[3..<bytes.endIndex])
        let millSeconds = bytesToLong(timeBytes)
        let timeString = "\(millSeconds)"
        print("sensorType: \(sensorType); time: \(timeString)")
    }
    
    private func bytesToLong(_ bytes: [UInt8]) -> CLongLong {
        var ret: CLongLong = 0
        for (index, value) in bytes.enumerated() {
            let and = CLongLong(value & 0xFF)
            let temp = ((and << (8 * index)))
            ret |= temp
        }
        return ret
    }
}
