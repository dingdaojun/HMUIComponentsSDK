//
//  PayAccessControlProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/19.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

public enum PayACCardState: Int {
    case normal = 0
}

public protocol PayACCardProtocol {
    /// aid
    var aid: String { get }
    /// 卡面
    var art: String { get }
    /// 卡名称
    var name: String { get set }
    /// 用户协议
    var userTerms: String { get }
    /// 是否需要指纹
    var isFinger: Bool { get }
}

public struct PayACCCard: PayACCardProtocol {
    public let aid: String
    public let art: String
    public var name: String
    public let userTerms: String
    public let isFinger: Bool
}
