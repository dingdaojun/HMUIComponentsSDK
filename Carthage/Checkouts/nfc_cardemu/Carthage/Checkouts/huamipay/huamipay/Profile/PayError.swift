//
//  PayError.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


public enum PayNetworkState: String {
    /// 临时设置，无用，只是返回的Error构建中需要code，而无服务端返回的state为string，无法转int，故这里写死
    /// 后期考虑使用别的方式代替Error返回给上层
    static let tsmCode = 2
    case success = "0000" // 云端定义的0000字符串才是成功，其他比如0，都不是.
    case networkFail = "-1"
}

public enum PayError: Error {
    public static let domain = "huamipay"
    public static let errorCode = "code"
    public static let errorMsg = "msg"
    case unlikey(error: Error)
    case timeout
    case errorApduResponse(response: Data)
    case weakRelease
    case overdraftLessThanZero(response: Data)
    case overdraftBalanceBothValue(response: Data)
    case bleError(error: Error)
    case networkError(msg: String)
    case paramError(String)
    case blackCard
    case notMiFare
}
