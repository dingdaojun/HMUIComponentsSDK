//
//  PayCity.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

/// 卡状态
///
/// - normal: 未开通
/// - install: 已安装
/// - abnormal: 异常
public enum CardState: Equatable {
    case normal(stock: CardStockState)
    case install(stock: CardStockState)
    case abnormal(stock: CardStockState)
}

/// 卡库存状态
///
/// - normal: 正常
/// - offline: 下线
/// - low: 库存不足
public enum CardStockState: Int, Equatable {
    case normal = 0
    case offline = 1
    case low = 2
}

/// 卡片类型
///
/// - bandCard: 银行卡
/// - busCard: 公交卡
public enum CardType: Int {
    case bandCard = 0
    case busCard
}

/// 已安装卡片信息
public struct PayCardInfo {
    /// 卡号
    public var number = ""
    /// 有效期
    public var validity = Date()
    /// 启动日期
    public var startDate = Date()
    /// 余额
    public var balance: Int = 0
    /// 卡片是否可用
    public var isAvailable = true
    
    public init() {}
}

/// 推荐城市卡信息
public struct PayCityCardInfo {
    public var city: PayCity
    /// 城市名称
    public var cityName: String = ""
    /// 卡名称
    public var name: String = ""
    /// 卡面图片地址
    public var image: URL?
    /// 已安装卡面图片地址
    public var activeImage: URL?
    /// 卡类型
    public var type: CardType = .busCard
    /// 是否为父城市
    public var isParentCity = false
    /// 开卡时间
    public var openTime: Date?
    /// 应用范围
    public var serviceScope: String = ""
    /// 卡号
    public var number: String?
    /// 卡状态
    public var state: CardState = .normal(stock: .normal)
    /// 异常卡订单
    public var orderNum: String?
    
    public init(_ payCity: PayCity) { city = payCity }
}

/// 已安装城市列表信息
public struct PayCityCardInstallInfo {
    /// aid
    public var aid: Data
    /// 城市code(app_code)
    public var cityId: String
    /// 城市名称
    public var cityName: String
    /// 是否激活
    public var isActivity: Bool
    /// 城市类型枚举
    public var city: PayCity = .beijin
    
    public init() {
        self.isActivity = false
        self.cityName = city.info.name
        self.cityId = city.info.code
        self.aid = city.info.aid
    }
}
