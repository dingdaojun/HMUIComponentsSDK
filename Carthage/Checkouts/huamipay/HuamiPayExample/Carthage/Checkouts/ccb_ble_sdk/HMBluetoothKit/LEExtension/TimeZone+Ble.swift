//
//  TimeZone+Ble.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/8.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation


extension TimeZone {
    public func bleOffset() -> Int {
        var offset = self.secondsFromGMT()
        let flag = offset < 0 ? -1 : 1
        offset = labs(offset)
        let hour = offset / 60 / 60
        let minute = offset / 60 % 60
        return (hour * 4 + minute / 15) * flag
    }
    
    public static func bleGetTimeZoneOffset(key: UInt8) -> Int {
        guard Int(key) != -128 else {
            return 28800
        }
        
        let flag = key < 0 ? -1 : 1
        let absKey: Int = Int(abs(Int32(key)))
        let h = absKey / 4
        let m = (absKey % 4) * 15
        return (h * 60 + m) * 60 * flag
    }
}
