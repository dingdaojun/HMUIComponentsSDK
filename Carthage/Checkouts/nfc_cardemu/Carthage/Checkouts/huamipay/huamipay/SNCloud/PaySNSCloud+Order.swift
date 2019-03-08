//
//  PaySNSCloud+Order.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


extension PaySNCloud {
    /// 查询费用
    ///
    /// - Parameters:
    ///   - orderType: 订单类型
    ///   - city: 城市
    ///   - callback: OrderFeeCallback
    public func queryRelativeCost(_ orderType: PayOrderType, inCity city: PayCity, callback: @escaping HuamipaySNCloudProtocol.OrderFeeCallback) {
        let type = HMServiceWalletOrderType(rawValue: UInt(orderType.rawValue))!
        PayTransmit.shared.nfcService.wallet_orderFee(withCityID: city.info.code, orderType: type, xiaomiCardName: "") { (state, msg, feeProtocols) in
            PayTransmit.shared.payQueue.async {
                guard state != PayNetworkState.networkFail.rawValue else {
                    callback(nil, PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                guard state == PayNetworkState.success.rawValue,
                    let feePros = feeProtocols else {
                        callback(nil, PayError.unlikey(error: NSError(domain: PayError.domain, code: -1, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                       PayError.errorMsg: msg ?? ""])))
                        return
                }
                
                let fees = PayMICloud.generateOrderFee(feePros)
                var orderFee = PayOrderFee()
                orderFee.city = city
                orderFee.fees = fees
                orderFee.type = orderType
                callback(orderFee, nil)
            }
        }.printCURL()
    }
    
    
    /// 生成订单
    ///
    /// - Parameters:
    ///   - orderType: 订单类型
    ///   - city: 城市
    ///   - channel: 支付渠道
    ///   - payAmount: 支付金额
    ///   - callback: OrderCallback
    public func generateOrder(_ orderType: PayOrderType, inCity city: PayCity, payChannel channel: PayChannel, payAmount: Int, callback: @escaping HuamipaySNCloudProtocol.OrderCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.wallet_order(withCityID: city.info.code, feeID: "", orderType: HMServiceWalletOrderType(rawValue: UInt(orderType.rawValue))!, paymentChannel: channel.walletChannel, paymentAmount: payAmount, loction: nil, completionBlock: { (state, msg, orderPro) in
                PayTransmit.shared.payQueue.async {
                    guard state != PayNetworkState.networkFail.rawValue else {
                        callback(nil, PayError.networkError(msg: msg ?? ""))
                        return
                    }
                    
                    guard state == PayNetworkState.success.rawValue,
                        let pro = orderPro else {
                            callback(nil, PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                                             PayError.errorMsg: msg ?? ""])))
                            return
                    }
                    
                    callback(PayMICloud.generateOrder(pro), nil)
                }
            }).printCURL()
        }
    }
    
    /// 订单详情
    ///
    /// - Parameters:
    ///   - orderNum: 订单号
    ///   - callback: OrderInfoCallback
    public func orderInfo(orderNum: String, callback: @escaping HuamipaySNCloudProtocol.OrderInfoCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.wallet_orderDetail(withOrderID: orderNum) { (state, msg, orderPro) in
                PayTransmit.shared.payQueue.async {
                    guard state != PayNetworkState.networkFail.rawValue else {
                        callback(nil, PayError.networkError(msg: msg ?? ""))
                        return
                    }
                    
                    guard state == PayNetworkState.success.rawValue,
                          let pro = orderPro else {
                        callback(nil,  PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                        PayError.errorMsg: msg ?? ""])))
                        return
                    }
                    
                    var order = PayMICloud.generateOrderInfo(pro)
                    order.orderNum = orderNum
                    callback(order, nil)
                }
            }
        }
    }
    
    /// 订单列表
    ///
    /// - Parameters:
    ///   - from: 开始时间
    ///   - to: 结束时间
    ///   - orderState: 订单状态
    ///   - city: 城市
    ///   - callback: OrderListCallback
    public func ordersList(from: Date, to: Date, orderState: OrderState, city: PayCity? = nil, callback: @escaping HuamipaySNCloudProtocol.OrderListCallback) {
        PayTransmit.shared.payQueue.async {
            var orderType = HMServiceWalletOrderCategory.all
            switch orderState {
            case .normal: orderType = HMServiceWalletOrderCategory.normal; break;
            case .abnormal: orderType = HMServiceWalletOrderCategory.abnormal; break;
            case .all: orderType = HMServiceWalletOrderCategory.all; break;
            }
            
            var cityCode = ""
            if let c = city { cityCode = c.info.code }
            
            let result = PayTransmit.shared.nfcService.wallet_orderList(withCityID: cityCode, xiaomiCardName: "", start: from, end: to, count: Int(INT_MAX), orderCategory: orderType, completionBlock: { (state, msg, pro) in
                PayTransmit.shared.payQueue.async {
                    guard state != PayNetworkState.networkFail.rawValue else {
                        callback([], PayError.networkError(msg: msg ?? ""))
                        return
                    }
                    
                    guard state == PayNetworkState.success.rawValue else {
                        callback([],  PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                       PayError.errorMsg: msg ?? ""])))
                        return
                    }
                    
                    var order: [PayOrderInfo] = []
                    if let p = pro { order = PayMICloud.generateOrderList(p) }
                    callback(order, nil)
                }
            })
            result?.printCURL()
        }
    }
    
    /// 申请退款
    ///
    /// - Parameters:
    ///   - orderNum: 订单号
    ///   - callback: RefundCallback
    public func requestRefund(orderNum: String, callback: @escaping HuamipaySNCloudProtocol.RefundCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.wallet_refund(withOrderID: orderNum) { (state, msg) in
                PayTransmit.shared.payQueue.async {
                    guard state != PayNetworkState.networkFail.rawValue else {
                        callback(PayError.networkError(msg: msg ?? ""))
                        return
                    }
                    
                    guard state == PayNetworkState.success.rawValue else {
                        callback(PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                  PayError.errorMsg: msg ?? ""])))
                        return
                    }
                    callback(nil)
                }
            }
        }
    }
}
