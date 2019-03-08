//
//  Array+Bluetooth.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/20.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension Array where Array == [UInt8] {
    public func toInt() -> Int {
        let value1 = UInt32(self[0])
        let value2 = UInt32(self[1]) << 8
        let value3 = UInt32(self[2]) << 16
        let value4 = UInt32(self[3]) << 24
        
        let returnValue = value1 | value2 | value3 | value4
        return Int(returnValue)
    }
}

extension Int {
    public var toU8: UInt8 {get {return UInt8(truncatingIfNeeded:self)} }
}
