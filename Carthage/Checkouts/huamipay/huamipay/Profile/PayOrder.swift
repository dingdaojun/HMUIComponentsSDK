//
//  PayOrderInfo.swift
//  huamipay
//
//  Created by 余彪 on 2018/4/3.
//

import Foundation

/// 订单类型
///
/// - activateCard: 开卡
/// - recharge: 充值(圈存)
/// - all: 开卡+充值
public enum PayOrderType: Int {
    case activateCard = 1
    case recharge
    case all
}

/// 订单状态
///
/// - normal: 正常订单
/// - abnormal: 异常订单
/// - all: 全部订单
public enum OrderState: String {
    case normal
    case abnormal
    case all
}

/// 生成订单结果参数
public struct PayOrderResult {
    public var expire: Date
    public var signed: String
    public var orderNum: String
    public var payURL: URL?
    public var returnURL: String?
}

/// 订单信息
public struct PayOrderInfo {
    public enum ActionType: Int {
        case openCard = 1
        case charge = 2
    }
    
    public struct ActionToken {
        public var amount: Int
        public var token: String
        public var type: ActionType
        
        public init() {
            self.amount = 0
            self.token = ""
            self.type = .charge
        }
    }
    
    /// 城市
    public var city: PayCity?
    /// 订单号
    public var orderNum = ""
    /// 支付渠道
    public var payChannel: PayChannel = .alipay
    /// 订单类型
    public var orderType: PayOrderType = .all
    /// 订单状态(订单状态值)
    public var orderState: Int = 0
    /// 订单状态说明
    public var orderStateDec = ""
    /// 订单金额(注: 貌似需要分开知道开卡费用和充值金额)
    public var orderAmount: Int = 0
    /// 订单时间
    public var orderTime = Date()
    /// 流水号(付完款后才会有)
    public var payNum: String? = nil
    /// token
    public var tokens: [ActionToken]?
    /// 来源
    var source: String?
    
    public init() {}
}

extension PayOrderInfo {
    /// 是否支持退款
    ///
    /// - Returns: true/false
    public func isSupportRefund() -> Bool {
        guard orderState != 0  else { return false }
        // 小米所有异常订单都可以申请退款
        guard source != "XIAOMI" else { return true }
        let supportRefundStates = [1001, 1002, 1011, 1013, 1015]
        guard supportRefundStates.contains(orderState) else { return false }
        return true
    }
    
    /// 是否支持重试
    ///
    /// - Returns: true/false
    public func isSupportRetry() -> Bool {
        guard orderState != 0  else { return false }
        // 小米所有异常订单都可以申请退款
        guard source != "XIAOMI" else { return true }
        let supportRetryStates = [1001, 1002, 1006, 1007, 1011, 1013, 1015]
        guard supportRetryStates.contains(orderState) else { return false }
        return true
    }
}
