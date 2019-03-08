//
//  String+SubString.swift
//  huamipay
//
//  Created by 余彪 on 2018/4/2.
//

import Foundation

extension String {
    //根据开始位置和长度截取字符串
    func paySubString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
