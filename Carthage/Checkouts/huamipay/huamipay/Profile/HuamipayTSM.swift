//
//  HuamipayTSM.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/13.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


@objc public enum SupportProject: Int {
    case chongqing
    case beats
    case beatsP
    case huashan
    case dongtinghu
    case qogir
}

@objc public enum SupportTSM: Int {
    case mi
    case snowball
}

@objc public class HuamipayTSM: NSObject {
    /// 根据项目获取TSM平台
    ///
    /// - Parameter project: 项目
    /// - Returns: tsm
    public static func tsm(with project: SupportProject) -> SupportTSM {
        switch project {
        case .chongqing:
            return .mi
        default:
            return .snowball
        }
    }
    
    /// 项目代号
    ///
    /// - Parameter project: 项目
    /// - Returns: String
    public static func projectCode(with project: SupportProject) -> String {
        switch project {
        case .beats:
            return "A1712"
        case .beatsP:
            return "A1715"
        case .chongqing:
            return "XMSH06HM"
        case .huashan:
            return "A1713"
        case .dongtinghu:
            return "A1802"
        case .qogir:
            return "A1801"
        }
    }
}
