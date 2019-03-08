//
//  PayChannelType+Wallet.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/25.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


/// 支付渠道
///
/// - alipay: 支付宝
/// - wechat: 微信
/// - testAlipay: 测试环境的支付宝支付
public enum PayChannel {
    case alipay
    case wechat
    case testAlipay
}

extension PayChannel {
    var walletChannel: HMServiceWalletOrderPaymentChannel {
        switch self {
        case .alipay: return .alipay
        case .wechat: return .wechat
        case .testAlipay: return .testAlipay
        }
    }
    
    static func payChannel(_ channel: HMServiceWalletOrderPaymentChannel) -> PayChannel {
        switch channel {
        case .alipay: return .alipay
        case .testAlipay: return .testAlipay
        case .wechat: return .wechat
        default: return .testAlipay
        }
    }
}
