//
//  Dictionary+JSON.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/4.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


extension Dictionary {
    var json: String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
        } catch {
            result = ""
        }
        return result
    }
}
