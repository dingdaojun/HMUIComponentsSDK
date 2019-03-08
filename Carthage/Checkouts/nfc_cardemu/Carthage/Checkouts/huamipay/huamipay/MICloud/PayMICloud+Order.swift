//
//  PayMICloud+Order.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

extension PayMICloud {
    /// 查询费用
    ///
    /// - Parameters:
    ///   - orderType: 订单类型
    ///   - city: 城市
    ///   - callback: OrderFeeCallback
    public func queryRelativeCost(_ orderType: PayOrderType, inCity city: PayCity, callback: @escaping HuamipayMICloudProtocol.OrderFeeCallback) {
        let type = HMServiceWalletOrderType(rawValue: UInt(orderType.rawValue))!
        let result = PayTransmit.shared.nfcService.wallet_orderFee(withCityID: city.info.code, orderType: type, xiaomiCardName: city.info.miName) { (state, msg, feeProtocols) in
            PayTransmit.shared.payQueue.async {
                guard state != PayNetworkState.networkFail.rawValue else {
                    callback(nil, PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                guard state == PayNetworkState.success.rawValue,
                      let feePros = feeProtocols else {
                    callback(nil, PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
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
        }
        result?.printCURL()
    }
    
    /// 生成订单
    ///
    /// - Parameters:
    ///   - feeID: 小米Feeid
    ///   - city: 城市
    ///   - location: 位置，岭南通城市需传
    ///   - callback: 回调
    public func generateOrder(_ feeID: String, in city: PayCity, with location: CLLocation?, callback: @escaping HuamipayMICloudProtocol.OrderCallback) {
        PayTransmit.shared.nfcService.wallet_order(withCityID: city.info.code, feeID: feeID, orderType: .openCardAndRecharge, paymentChannel: .alipay, paymentAmount: 0, loction: location) { (state, msg, orderPro) in
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
        }.printCURL()
    }
    
    /// 订单列表
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - callback: OrderListCallback
    public func ordersList(with city: PayCity, callback: @escaping HuamipayMICloudProtocol.OrderListCallback) {
        PayTransmit.shared.payQueue.async {
            let result = PayTransmit.shared.nfcService.wallet_orderList(withCityID: "", xiaomiCardName: city.info.miName, start: Date(), end: Date(), count: Int(INT_MAX), orderCategory: HMServiceWalletOrderCategory.all, completionBlock: { (state, msg, pro) in
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
    
    /// 订单详情
    ///
    /// - Parameters:
    ///   - orderNum: 订单号
    ///   - callback: OrderInfoCallback
    public func orderInfo(orderNum: String, callback: @escaping HuamipayMICloudProtocol.OrderInfoCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.wallet_orderDetail(withOrderID: orderNum) { (state, msg, pro) in
                PayTransmit.shared.payQueue.async {
                    guard state != PayNetworkState.networkFail.rawValue else {
                        callback(nil, PayError.networkError(msg: msg ?? ""))
                        return
                    }
                    
                    guard state == PayNetworkState.success.rawValue,
                          let orderInfo = pro else {
                          callback(nil,  PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                        PayError.errorMsg: msg ?? ""])))
                        return
                    }
                    
                    var order = PayMICloud.generateOrderInfo(orderInfo)
                    order.orderNum = orderNum
                    callback(order, nil)
                }
            }
        }
    }
    
    /// 申请退款
    ///
    /// - Parameters:
    ///   - orderNum: 订单号
    ///   - callback: RefundCallback
    public func requestRefund(orderNum: String, callback: @escaping HuamipayMICloudProtocol.RefundCallback) {
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

extension PayMICloud {
    static func generateOrderFee(_ pros: [HMServiceAPIWalletOrderFeeProtocol]) -> [PayOrderFee.Fee] {
        let fees = pros.map { (feePro) -> PayOrderFee.Fee in
            var fee = PayOrderFee.Fee()
            fee.feeID = feePro.api_walletOrderFeeID ?? ""
            fee.normalOpenCard = feePro.api_walletOrderFeeOpenCard
            fee.discountOpenCard = feePro.api_walletOrderFeeDiscountedOpenCard
            fee.normalCharge = feePro.api_walletOrderFeeRecharges
            fee.discountCharge = feePro.api_walletOrderFeeDiscountedRecharges
            fee.normalShiftIn = feePro.api_walletOrderFeeShiftin
            fee.discountShiftIn = feePro.api_walletOrderFeeDiscountedShiftin
            fee.normalShiftOut = feePro.api_walletOrderFeeShiftout
            fee.discountShiftOut = feePro.api_walletOrderFeeDiscountedShiftout
            return fee
        }
        
        return fees
    }
    
    static func generateOrder(_ pro: HMServiceAPIWalletOrderProtocol) -> PayOrderResult {
        let orderNum = pro.api_walletOrderID ?? ""
        let orderExpire = pro.api_walletOrderExpire ?? Date()
        let orderSign = pro.api_walletOrderSignedData ?? ""
        let returnUrl: String? = pro.api_walletOrderUrl
        let payURLString = pro.api_walletOrderPayUrl ?? ""
        var payURL: URL? = nil
        if payURLString.count > 0 {
            payURL = URL(string: payURLString.urlEncoded())
        }
        
        return PayOrderResult(expire: orderExpire, signed: orderSign, orderNum: orderNum, payURL: payURL, returnURL: returnUrl)
    }
    
    static func generateOrderInfo(_ pro: HMServiceAPIWalletOrderDetailProtocol) -> PayOrderInfo {
        var orderInfo = PayOrderInfo()
        orderInfo.orderNum = pro.api_walletOrderDetailID ?? ""
        orderInfo.orderAmount = pro.api_walletOrderDetailAmount
        orderInfo.orderTime = pro.api_walletOrderDetailTime ?? Date()
        orderInfo.orderType = PayOrderType(rawValue: Int(pro.api_walletOrderDetailType.rawValue))!
        orderInfo.orderState = Int(pro.api_walletOrderDetailStatus.rawValue)
        orderInfo.payNum = pro.api_walletOrderDetailSerialNumber ?? ""
        orderInfo.orderStateDec = pro.api_walletOrderDetailStatusDescription ?? ""
        orderInfo.source = pro.api_walletOrderDetailOrderSource
        
        if let name = pro.api_walletOrderDetailXiamiCardName {
            // 得用小米的对应方法
            orderInfo.city = PayCity.miCarName(name)
        } else if let cityID = pro.api_walletOrderDetailCityID {
            // FIX 雪球在详情页面没有返回app_code
            orderInfo.city = PayCity.cityCode(cityID)
        }
        
        if let tokens = pro.api_walletOrderDetailActionToken {
            orderInfo.tokens = tokens.map { (token) -> PayOrderInfo.ActionToken in
                let t = token as! Dictionary<String, Any>
                let amount = t["rechargeAmount"] as! Int
                let token = (t["token"] as? String) ?? ""
                let type = PayOrderInfo.ActionType(rawValue: t["type"] as! Int)!
                var orderInfo = PayOrderInfo.ActionToken()
                orderInfo.amount = amount
                orderInfo.token = token
                orderInfo.type = type
                return orderInfo
            }
        }
        
        orderInfo.payChannel = PayChannel.payChannel(pro.api_walletOrderDetailPaymentChannel)
        return orderInfo
    }
    
    static func generateOrderList(_ pros: Array<HMServiceAPIWalletOrderDetailProtocol>) -> [PayOrderInfo] {
        var orderList: [PayOrderInfo] = []
        for pro in pros {
            let info = generateOrderInfo(pro)
            orderList.append(info)
        }
        return orderList
    }
}
