//
//  ByteArrayAndIndex.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/6.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation


/// Class which encapsulates a Swift byte array (an Array object with elements of type UInt8) and an
/// index into the array.
open class ByteArrayAndIndex {
    
    private var _byteArray : [UInt8]
    private var _arrayIndex = 0
    
    public init(_ byteArray : [UInt8]) {
        _byteArray = byteArray;
    }
    
    /// Method to get a UTF-8 encoded string preceded by a 1-byte length.
    public func getShortString() -> String {
        return getTextData(getUInt8AsInt())
    }
    
    /// Method to get a UTF-8 encoded string preceded by a 2-byte length.
    public func getMediumString() -> String {
        return getTextData(getUInt16AsInt())
    }
    
    /// Method to get a UTF-8 encoded string preceded by a 4-byte length. By convention a length of
    /// -1 is used to signal a String? value of nil.
    public func getLongString() -> String? {
        let encodedLength = getInt32()
        if encodedLength == -1 {
            return nil
        }
        return getTextData(Int(encodedLength))
    }
    
    /// Method to get a single byte from the byte array, returning it as an Int.
    public func getUInt8AsInt() -> Int {
        return Int(getUInt8())
    }
    
    /// Method to get a single byte from the byte array.
    public func getUInt8() -> UInt8 {
        let returnValue = _byteArray[_arrayIndex]
        _arrayIndex += 1
        return returnValue
    }
    
    /// Method to get a UInt16 from two bytes in the byte array (little-endian), returning it as Int.
    public func getUInt16AsInt() -> Int {
        return Int(getUInt16())
    }
    
    /// Method to get a UInt16 from two bytes in the byte array (little-endian).
    public func getUInt16() -> UInt16 {
        let returnValue = UInt16(_byteArray[_arrayIndex]) |
            UInt16(_byteArray[_arrayIndex + 1]) << 8
        _arrayIndex += 2
        return returnValue
    }
    
    /// Method to get an Int32 from four bytes in the byte array (little-endian).
    public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }
    
    /// Method to get a UInt32 from four bytes in the byte array (little-endian).
    public func getUInt32() -> UInt32 {
        let value1 = UInt32(_byteArray[_arrayIndex])
        let value2 = UInt32(_byteArray[_arrayIndex + 1]) << 8
        let value3 = UInt32(_byteArray[_arrayIndex + 2]) << 16
        let value4 = UInt32(_byteArray[_arrayIndex + 3]) << 24
        
        let returnValue = value1 | value2 | value3 | value4
        _arrayIndex += 4
        return returnValue
    }
    
    // Method to decode UTF-8 encoded text data in the byte array.
    private func getTextData(_ numberBytes : Int) -> String {
        if numberBytes == 0 {
            return ""  // Tiny optimization?
        }
        let startIndex = _arrayIndex
        _arrayIndex += numberBytes
        return String(bytes: _byteArray[startIndex ..< _arrayIndex], encoding: String.Encoding.utf8)!
    }
}
