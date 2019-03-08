//
//  TWTlvUtils.swift
//  TWTagLengthValue
//
//  Created by Thomas Wilson on 21/11/2015.
//  Copyright © 2015 Thomas Wilson. All rights reserved.
//

import Foundation

struct TWTlvUtils {
    static func isConstructedTag(_ tag: UInt8) -> Bool {
        return ((tag & 0x20) == 0x20)
    }
    
    static func bytesUsed(_ value:UInt64) -> UInt8 {
        let array = value.toByteArray()
        var count: UInt8 = 0
        for byte in array { if byte > 0 { count += 1 } }
        return count
    }
    
    static func getLengthData(_ length: Int) -> [UInt8] {
        guard length > 127 else { return [length.toByteArray().last!] }
        
        var result = [UInt8]()
        let byteCount = bytesUsed(UInt64(length))
        let lengthsLength:UInt8 = 0x80 | byteCount;
        result.append(lengthsLength);
        let lengthArray = length.toByteArray();
        for byte in lengthArray { if(byte > 0){ result.append(byte) } }
        return result;
    }
    
    static func arrayToUInt64(_ data:[UInt8]) -> UInt64? {
        guard data.count <= 8 else { return nil }
        
        let nsdata = NSData(bytes: data.reversed(), length: data.count);
        var temp: UInt64 = 0;
        nsdata.getBytes(&temp, length: MemoryLayout<UInt64>.size);
        return temp;
    }
    
    static func cleanHex(_ hexStr:String) -> String {
        return hexStr.trimmingCharacters(in: CharacterSet(charactersIn: "<> ")).replacingOccurrences(of: " ", with: "")
    }
    
    static func isValidHex(_ asciiHex:String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .caseInsensitive)
        let found = regex.firstMatch(in: asciiHex, options: [], range: NSMakeRange(0, asciiHex.count))
        if found == nil || found?.range.location == NSNotFound || asciiHex.count % 2 != 0 { return false }
        return true;
    }
}
