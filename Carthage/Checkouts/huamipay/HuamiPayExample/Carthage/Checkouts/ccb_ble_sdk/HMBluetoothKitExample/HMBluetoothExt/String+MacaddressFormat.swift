//
//  String+MacaddressFormat.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/22.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    func macAddresFormat() -> String? {
        guard self.count == 12 else { return nil }
        var macString = self.uppercased()
        macString = "\(macString.subString(start: 0, length: 2)):\(macString.subString(start: 2, length: 2)):\(macString.subString(start: 4, length: 2)):\(macString.subString(start: 6, length: 2)):\(macString.subString(start: 8, length: 2)):\(macString.subString(start: 10, length: 2))"
        return macString
    }
}
