//
//  HuamipayMICloudProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

/// 订单协议
public protocol HuamipayMICloudProtocol: PayProfileProtocol {
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
    ///   - feeID: 小米Feeid
    ///   - city: 城市
    ///   - location: 位置，岭南通城市需传
    ///   - callback: 回调
    func generateOrder(_ feeID: String, in city: PayCity, with location: CLLocation?, callback: @escaping OrderCallback)
    
    typealias OrderListCallback = (_ orderList: [PayOrderInfo], _ error: PayError?) -> Void
    /// 订单列表
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - callback: OrderListCallback
    /// - Returns: Void
    func ordersList(with city: PayCity, callback: @escaping OrderListCallback) -> Void
    
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
    func lockCard(_ param: MIOperationParam, enable: Bool, callback: @escaping LockCardCallback)
    
    typealias RechargeCallback = (_ error: PayError?) -> Void
    /// 充值(圈存)(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: RechargeCallback
    /// - Returns: Void
    func recharge(_ param: MIOperationParam, callback: @escaping RechargeCallback)
    
    typealias DeleteCardCallback = (_ error: PayError?) -> Void
    /// 删卡(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: MIOperationParam
    ///   - callback: DeleteCardCallback
    /// - Returns: Void
    func deleteCard(_ param: MIOperationParam, callback: @escaping DeleteCardCallback)
    
    typealias LoadCallback = (_ error: PayError?) -> Void
    /// 下载Cap包(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: LoadCallback
    /// - Returns: Void
    func loadCap(_ param: MIOperationParam, callback: @escaping LoadCallback)
    
    typealias IssueCardCallback = (_ error: PayError?) -> Void
    /// 开卡(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: IssueCardCallback
    /// - Returns: Void
    func issuecard(_ param: MIOperationParam, callback: @escaping IssueCardCallback)
}
