//
//  HuamipayProtocol.swift
//  Created by 余彪 on 2018/3/14.
//

import Foundation
import CoreLocation
import UIKit
import WalletService


/// huamipay协议
public protocol HuamipayProtocol {
    /// huami云服务: 上传交易记录、获取交易记录
    var hmCloud: PayCloudProtocol {set get}
    /// 小米TSM云服务
    var miCloud: HuamipayMICloudProtocol {set get}
    /// 小米门禁
    var miACCloud: HuamipayMIAccessControlProtocol {set get}
    /// 雪球TSM云服务
    var snCloud: HuamipaySNCloudProtocol {set get}
    /// SE
    var se: PaySEProtocol {set get}
}

/// 订单协议
public protocol PayCloudProtocol: PayProfileProtocol {
    typealias BindCardCallback = (_ error: PayError?) -> Void
    /// 绑定公交卡
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - cardNumber: 卡面号
    ///   - deviceType: 设备类型
    ///   - city: 城市
    ///   - callback: Error
    /// - Returns: Void
    @available(*, deprecated, message: "云端调整为实时与雪球同步，废弃")
    func bindCard(deviceID: String, cardNumber: String, deviceType: Int, city: PayCity, callback: @escaping BindCardCallback) -> Void
    
    typealias UnBindCardCallback = (_ error: PayError?) -> Void
    /// 解除绑定公交卡
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - cardNumber: 卡面号
    ///   - callback: Error
    /// - Returns: Void
    @available(*, deprecated, message: "云端调整为实时与雪球同步，废弃")
    func unBindCard(deviceID: String, cardNumber: String, callback: @escaping UnBindCardCallback) -> Void
    
    typealias DealListNetworkCallback = (_ dealList: [DealInfo]?, _ nextDate: Date?, _ error: PayError?) -> Void
    /// 交易信息列表查询(从服务端取)
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - cardNumber: 卡面号
    ///   - nextDate: 从什么时间取数据(第一次取可传nil)
    ///   - limit: 分页
    ///   - callback: [DealInfo], 下次获取时间, Error
    /// - Returns: Void
    func dealInfoListFromNetwork(city: PayCity, cardNumber: String, nextDate: Date?, limit: Int, callback: @escaping DealListNetworkCallback) -> Void
    
    typealias UploadDealListCallback = (_ error: PayError?) -> Void
    /// 上传交易记录
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - cardNumber: 卡面号
    ///   - dealList: 交易记录数据
    ///   - callback: Error
    /// - Returns: Void
    func uploadDealList(city: PayCity, cardNumber: String, dealList: [DealInfo], callback: @escaping UploadDealListCallback)
    
    typealias ReadUserPhoneCallback = (_ phone: String?, _ error: PayError?) -> Void
    /// 获取用户手机号
    ///
    /// - Parameter callback: ReadUserPhoneCallback
    func readUserPhone(callback: @escaping ReadUserPhoneCallback)
    
    typealias VerficationCodeCallback = (_ error: PayError?) -> Void
    /// 获取短信验证码
    ///
    /// - Parameters:
    ///   - phoneNum: 手机号
    ///   - callback: 回调
    func fetchVerficationCode(for phoneNum: String, callback: @escaping VerficationCodeCallback)
    
    typealias BindPhoneCallback = (_ error: PayError?) -> Void
    /// 绑定手机号
    ///
    /// - Parameters:
    ///   - phoneNum: 手机号
    ///   - verfucatuibCode: 验证码
    ///   - callback: 回调
    func bindPhone(_ phoneNum: String, verfucatuibCode: String, callback: @escaping BindPhoneCallback)
    
    typealias NoticeCallback = (_ notices: [PayNotice], _ error: PayError?) -> Void
    /// 获取公告
    ///
    /// - Parameter callback: 回调
    func fetchNotice(callback: @escaping NoticeCallback)
    
    /// 获取公告
    ///
    /// - Parameter callback: 回调
    func fetchNotice(for city: PayCity, callback: @escaping NoticeCallback)
}


