//
//  Date+Ble.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/8.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation


extension Date {
    public func toBleBytes() -> [UInt8] {
        let calendar = Calendar.current
        let yearUInt16: UInt16 = UInt16(calendar.component(.year, from: self))
        
        return [UInt8(yearUInt16 & 0xFF),
                UInt8((yearUInt16 & 0xFF00) >> 8),
                UInt8(calendar.component(.month, from: self)),
                UInt8(calendar.component(.day, from: self)),
                UInt8(calendar.component(.hour, from: self)),
                UInt8(calendar.component(.minute, from: self)),
                UInt8(calendar.component(.second, from: self)),]
    }
    
    public static func bytesToDate(bytes: [UInt8]) -> Date? {
        let yearsBytes = [bytes[0], bytes[1]]
        let yearU16 = UnsafePointer(yearsBytes).withMemoryRebound(to: UInt16.self, capacity: 1) { $0.pointee }
        let year = yearU16
        let month = bytes[2] & 0xFF
        let day = bytes[3] & 0xFF
        let hour = bytes[4] & 0xFF
        let min = bytes[5] & 0xFF
        let sec = bytes[6] & 0xFF
        let dateString = "\(year)-\(month)-\(day) \(hour):\(min):\(sec)"
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormate.date(from: dateString)
    }
}
