//
//  HuamipayMIAccessControlProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/18.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


public protocol HuamipayMIAccessControlProtocol {
    func readCardTag() throws -> CardTag
    
    typealias DeleteCardCallback = (_ error: PayError?) -> Void
    /// 删卡
    ///
    /// - Parameters:
    ///   - param: MIAccessControlOperationParam
    ///   - callback: DeleteCardCallback
    /// - Returns: Void
    func deleteCard(_ param: MIAccessControlOperationParam, callback: @escaping DeleteCardCallback)
    
    typealias InstallCallback = (_ sessionID: String?, _ error: PayError?) -> Void
    /// 安装卡片
    ///
    /// - Parameters:
    ///   - param: MIAccessControlOperationParam
    ///   - callback: InstallCallback
    func installCard(_ param: MIAccessControlOperationParam, callback: @escaping InstallCallback)
    
    typealias CardInfoCallback = (_ card: PayACCardProtocol?, _ error: PayError?) -> Void
    /// 卡信息
    ///
    /// - Parameters:
    ///   - sessionId: sessionID
    ///   - callback: CardInfoCallback
    func cardInfomation(with sessionId: String, callback: @escaping CardInfoCallback)
    
    typealias CardListCallback = (_ card: [PayACCardProtocol]?, _ error: PayError?) -> Void
    /// 门禁卡列表页
    ///
    /// - Parameter callback: 回调
    func accessCardList(callback: @escaping CardListCallback)
    
    typealias UpdateCardCallback = (_ error: PayError?) -> Void
    /// 更新门禁卡数据
    ///
    /// - Parameters:
    ///   - info: 门禁卡数据
    ///   - callback: 回调
    func updateAccessCardInfomation(with info: PayACCardProtocol, callback: @escaping UpdateCardCallback)
}
