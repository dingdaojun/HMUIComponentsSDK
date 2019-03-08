//
//  PayProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/4.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


/// 获取协议Action
///
/// - issue: 开卡
/// - charge: 充值(获取是否有最新协议)
public enum PayProtocolActionType: String {
    case issue = "ISSUE"
    case charge = "RECHARGE"
}

public protocol PayServiceProtocol {
    /// 内容
    var url: String { set get }
    /// 协议ID
    var identifier: String { set get }
    /// 协议名称
    var title: String { set get }
}

public struct PayProtocol: PayServiceProtocol {
    /// 内容
    public var url = ""
    /// 协议ID
    public var identifier = ""
    /// 协议名称
    public var title = ""
}
