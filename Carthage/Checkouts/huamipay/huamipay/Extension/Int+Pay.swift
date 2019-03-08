//
//  Int+Pay.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation

extension Int {
    func toRadix16() -> String {
        return Data.init(hex: String.init(self, radix: 16, uppercase: false)).toHexString()
    }
    
    func toIntRadix16() -> Int {
        let hexStr = self.toRadix16()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for c in hexStr.utf8CString {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
        }
        return sum
    }
}
