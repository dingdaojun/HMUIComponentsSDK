//
//  PayNotice.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/3.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


public struct PayNotice {
    /// 公告类型
    ///
    /// - crossBar: 横栏
    /// - popup: 弹窗
    public enum NoticeType: String {
        case crossBar = "CROSS_BAR"
        case popup = "POP_UP"
    }
    
    /// 循环类型
    ///
    /// - none: 不循环
    /// - day: 按天(每隔24h)
    public enum NoticeLoop: String {
        case none = "NONE"
        case day = "DAY"
    }
    
    /// 支持城市
    public var cities: [PayCity] = []
    /// 公告内容
    public var context = ""
    /// 横栏跳转路径
    public var jumpURL: URL?
    /// 公告ID
    public var identifier: String = ""
    /// 公告主题
    public var title: String = "服务维护"
    /// 开始日期
    public var startDate: Date = Date()
    /// 结束日期
    public var endDate: Date = Date()
    /// 更新日期
    public var updateDate: Date = Date()
    /// 公告类型
    public var type: [NoticeType] = []
    /// 循环类型
    public var loop: NoticeLoop = .none
    /// 是否跳转
    public var isCrossBarJump = false
    
    public init() {}
}

extension PayNotice.NoticeType {
    /// 根据名称数组来获取type
    ///
    /// - Parameter types: 字符串数组
    /// - Returns: [PayNotice.NoticeType]
    public static func getNoticeTypes(_ types: [String]) -> [PayNotice.NoticeType] {
        var noticeTypes: [PayNotice.NoticeType] = []
        for apiType in types {
            if let type = PayNotice.NoticeType.init(rawValue: apiType) {
                noticeTypes.append(type)
            }
        }
        return noticeTypes
    }
}
