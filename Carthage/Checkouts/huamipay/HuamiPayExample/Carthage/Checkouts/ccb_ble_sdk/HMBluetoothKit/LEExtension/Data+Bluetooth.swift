//
//  Data+Bluetooth.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/14.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension Data {
    public func group(by size: Int) -> [[Element]] {
        guard size > 0 else {
            fatalError()
        }
        
        var arr: [[Element]] = []
        var index = 0
        while index < count {
            arr.append(Array(self[index..<Swift.min(index + size, count)]))
            index += size
        }
        
        return arr
    }
    
//    public init(hex:String) {
//        let scalars = hex.unicodeScalars
//        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
//        for (index, scalar) in scalars.enumerated() {
//            var nibble = scalar.hexNibble
//            if index & 1 == 0 {
//                nibble <<= 4
//            }
//            bytes[index >> 1] |= nibble
//        }
//        self = Data(bytes: bytes)
//    }
}

//extension UnicodeScalar {
//    public var hexNibble:UInt8 {
//        let value = self.value
//        if 48 <= value && value <= 57 {
//            return UInt8(value - 48)
//        }
//        else if 65 <= value && value <= 70 {
//            return UInt8(value - 55)
//        }
//        else if 97 <= value && value <= 102 {
//            return UInt8(value - 87)
//        }
//        fatalError("\(self) not a legal hex nibble")
//    }
//}

