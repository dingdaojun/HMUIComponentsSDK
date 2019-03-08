//
//  String+encode.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/25.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


public extension String {
    //将原始的url编码为合法的url
    public func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    public func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
