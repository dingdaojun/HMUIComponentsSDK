//
//  TWTLV+String.swift
//  TWTagLengthValue
//
//  Created by 余彪 on 2018/6/8.
//  Copyright © 2018年 Thomas Wilson. All rights reserved.
//

import Foundation

extension TWTLV {
    open func printableTlv(_ level:Int = 1) -> String {
        var tlvStr = ""
        
        let tagData = tagId.toByteArray()
        for byte in tagData { tlvStr += byte.toAsciiHex() }
        tlvStr += ":"
        let lengthData = length.toByteArray()
        for byte in lengthData { tlvStr += byte.toAsciiHex() }
        if(length > 0x00) {
            tlvStr += ":"
            if(constructed){
                tlvStr += "\n"
                for child in children {
                    tlvStr = tlvStr.padding(toLength: tlvStr.count + level, withPad: "\t", startingAt: 0)
                    tlvStr += child.printableTlv(level+1)
                }
            } else {
                for byte in value { tlvStr += byte.toAsciiHex() }
            }
            
            if (!tlvStr.hasSuffix(":\n")) { tlvStr += ":\n" }
        }
        
        return tlvStr
    }
    
    open func tlvString() -> String {
        var tlvStr = ""
        
        let tagData = tagId.toByteArray()
        for byte in tagData { tlvStr += byte.toAsciiHex() }
        let lengthData = length.toByteArray()
        for byte in lengthData { tlvStr += byte.toAsciiHex() }
        if(length > 0x00) {
            if(constructed){
                for child in children {
                    tlvStr += child.tlvString()
                }
            } else {
                for byte in value { tlvStr += byte.toAsciiHex() }
            }
        }
        
        return tlvStr
    }
}
