//
//  HuamipaySNCloudProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

/// 订单协议
public protocol HuamipaySNCloudProtocol {
    typealias OrderFeeCallback = (_ payFee: PayOrderFee?, _ error: PayError?) -> Void
    /// 查询相关费用
    ///
    /// - Parameters:
    ///   - orderType: 订单类型
    ///   - city: 城市
    ///   - callback: PayOrderFee, Error
    /// - Returns: Void
    func queryRelativeCost(_ orderType: PayOrderType, inCity city: PayCity, callback: @escaping OrderFeeCallback)
    
    typealias OrderCallback = (_ orderResult: PayOrderResult?, _ error: PayError?) -> Void
    /// 生成订单
    ///
    /// - Parameters:
    ///   - orderType: 订单类型
    ///   - city: 城市
    ///   - channel: 支付渠道
    ///   - payAmount: 支付金额(分)
    ///   - callback: orderNum(订单号)、orderExpire(订单有效期)、orderSign(订单信息, 给第三方用的), error
    /// - Returns: Void
    func generateOrder(_ orderType: PayOrderType, inCity city: PayCity, payChannel channel: PayChannel, payAmount: Int, callback: @escaping OrderCallback)
    
    typealias OrderListCallback = (_ orderList: [PayOrderInfo], _ error: PayError?) -> Void
    /// 查询订单列表
    ///
    /// - Parameters:
    ///   - from: 开始时间
    ///   - to: 结束时间
    ///   - orderState: 订单状态
    ///   - city: city
    ///   - callback: [PayOrderInfo], Error
    /// - Returns: Void
    func ordersList(from: Date, to: Date, orderState: OrderState, city: PayCity?, callback: @escaping OrderListCallback) -> Void
    
    typealias OrderInfoCallback = (_ orderInfo: PayOrderInfo?, _ error: PayError?) -> Void
    /// 订单详情
    ///
    /// - Parameters:
    ///   - orderNum: 订单号
    ///   - callback: PayOrderInfo, Error
    /// - Returns: Void
    func orderInfo(orderNum: String, callback: @escaping OrderInfoCallback) -> Void
    
    typealias RefundCallback = (_ error: PayError?) -> Void
    /// 申请退款
    ///
    /// - Parameters:
    ///   - orderNum: 订单号
    ///   - callback: Error
    /// - Returns: Void
    func requestRefund(orderNum: String, callback: @escaping RefundCallback) -> Void
    
    typealias RecommandCityListCallback = (_ cities: (recommendedCities: [PayCityCardInfo], availabledCities: [PayCityCardInfo])?, _ error: PayError?) -> Void
    /// 查询推荐的城市列表(岭南通)
    ///
    /// - Parameters:
    ///   - location: 经纬度
    ///   - callback: [PayCityCardInfo], Error
    /// - Returns: Void
    func queryRecommondCardInfoList(with location: CLLocationCoordinate2D, callback: @escaping RecommandCityListCallback) -> Void
    
    typealias SupportCityListCallback = (_ cityList: [PayCityCardInfo]?, _ error: PayError?) -> Void
    /// 查询可开通卡片的城市列表
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - callback: Array<PayCityCardInfo>
    /// - Returns: Error
    func supportCityList(with deviceID: String, callback: @escaping SupportCityListCallback)
    
    typealias OpenedCityListCallback = (_ cardList: [PayCityCardInfo]?, _ error: PayError?) -> Void
    /// 查询已开通卡列表
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - callback: callback: [PayCardInfo], Error
    /// - Returns: Void
    func openedCityList(with deivceID: String, callback: @escaping OpenedCityListCallback)
    
    typealias ProtocolCallback = (_ pro: PayServiceProtocol?, _ error: PayError?) -> Void
    /// 获取协议接口
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - actionType: 接口类型
    ///   - callback: 回调
    /// - Returns: Void
    func fetchProtocol(for city: PayCity, with actionType: PayProtocolActionType, callback: @escaping ProtocolCallback)
    
    typealias ConfigProtocolCallback = (_ error: PayError?) -> Void
    /// 确认协议
    ///
    /// - Parameters:
    ///   - identifier: 协议ID
    ///   - callback: 回调
    /// - Returns: Void
    func configProtocol(for identifier: String, callback: @escaping ConfigProtocolCallback)
    
    typealias LockCardCallback = (_ error: PayError?) -> Void
    /// 锁卡/解锁卡(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam
    ///   - enable: 是否锁卡
    ///   - callback: LockCardCallback
    /// - Returns: Void
    func lockCard(_ param: SNOperationParam, enable: Bool, callback: @escaping LockCardCallback)
    
    typealias DeleteCardCallback = (_ error: PayError?) -> Void
    /// 删卡(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam
    ///   - callback: DeleteCardCallback
    /// - Returns: Void
    func deleteCard(_ param: SNOperationParam, callback: @escaping DeleteCardCallback)
    
    typealias RechargeCallback = (_ error: PayError?) -> Void
    /// 充值(圈存)(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: RechargeCallback
    /// - Returns: Void
    func recharge(_ param: SNOperationParam, callback: @escaping RechargeCallback)
    
    typealias LoadCallback = (_ error: PayError?) -> Void
    /// 下载Cap包(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: LoadCallback
    /// - Returns: Void
    func loadCap(_ param: SNOperationParam, callback: @escaping LoadCallback)
    
    typealias IssueCardCallback = (_ error: PayError?) -> Void
    /// 开卡(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: IssueCardCallback
    /// - Returns: Void
    func issuecard(_ param: SNOperationParam, callback: @escaping IssueCardCallback)
    
    typealias IssueRechargeCardCallback = (_ error: PayError?) -> Void
    /// 开卡+充值(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: IssueRechargeCardCallback
    func issueReCharge(_ param: SNOperationParam, callback: @escaping IssueRechargeCardCallback)
}
