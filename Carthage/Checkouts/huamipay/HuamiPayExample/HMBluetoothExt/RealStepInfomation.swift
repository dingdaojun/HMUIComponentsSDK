//
//  RealStep.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/5.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

public struct RealStepInfomation {
    var steps: Int = 0
    var distance: Int = 0
    var calories: Int = 0
    var runSteps: Int = 0
    var walkSteps: Int = 0
    
    mutating func realStepDataHandle(data: Data) {
        let resultDataLength = 5
        guard data.count >= resultDataLength else {
            return
        }
        
        let bytes: [UInt8] = [UInt8](data)
        steps = self.bytesArryToInt(bytes: [bytes[1], bytes[2], bytes[3], bytes[4]])
        var index = resultDataLength
        let flag = bytes[0] & 0xFF
        
        if (flag & 0x01) != 0 {
            runSteps = self.bytesArryToInt(bytes: [bytes[index], bytes[index + 1], bytes[index + 2], bytes[index + 3]])
            index += 4
        }
        
        if (flag & 0x02) != 0 {
            walkSteps = self.bytesArryToInt(bytes: [bytes[index], bytes[index + 1], bytes[index + 2], bytes[index + 3]])
            index += 4
        }
        
        if (flag & 0x04) != 0 {
            distance = self.bytesArryToInt(bytes: [bytes[index], bytes[index + 1], bytes[index + 2], bytes[index + 3]])
            index += 4
        }
        
        if (flag & 0x08) != 0 {
            calories = self.bytesArryToInt(bytes: [bytes[index], bytes[index + 1], bytes[index + 2], bytes[index + 3]])
            index += 4
        }
    }
    
    func bytesArryToInt(bytes: [UInt8]) -> Int {
        let value1 = UInt32(bytes[0])
        let value2 = UInt32(bytes[1]) << 8
        let value3 = UInt32(bytes[2]) << 16
        let value4 = UInt32(bytes[3]) << 24
        
        let returnValue = value1 | value2 | value3 | value4
        return Int(returnValue)
    }
}
