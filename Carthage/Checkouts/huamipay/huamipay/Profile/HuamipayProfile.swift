//
//  HuamipayProfile.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation


public struct CardTag {
    public let uid: String
    public let sak: String
    public let atqa: String
}


/// 交易类型
///
/// - recharge: 充值交易
/// - localConsumption: 本地消费
/// - remoteConsumption: 异地消费
/// - openCard: 开卡
public enum DealType: Int {
    case recharge
    case localConsumption
    case remoteConsumption
    case openCard
}

/// 交易信息
public struct DealInfo {
    /// 交易事件
    public var dealTime: Date
    /// 交易金额
    public var dealAmount: Int
    /// 交易类型
    public var dealType: DealType
    
    public init(dealTime: Date, dealAmount: Int, dealType: DealType) {
        self.dealTime = dealTime
        self.dealAmount = dealAmount
        self.dealType = dealType
    }
}

extension Int {
    /// 是否为充值交易类型: https://internal.smartdevices.com.cn/redmine/attachments/5315/%E4%BA%A4%E6%98%93%E7%B1%BB%E5%9E%8B.png
    var isChargeDealType: Bool {
        switch self {
        case 1, 2, 11, 12:
            return true
        default: return false
        }
    }
}

