//
//  HuamipaySEProtocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


/// Apdu指令协议，应用层需实现
@objc public protocol NFCBLEProtocol: NSObjectProtocol {
    typealias APDU = Data
    
    func openNFCChannel() throws
    func closeNFCChannel() throws
    func transmit(_ apdu: APDU) throws -> Data
    func readCardTag() throws -> Data
}

/// 卡相关操作协议
public protocol PaySEProtocol {
    /// 获取CPLC(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Returns: CPLC
    /// - Throws: Error
    func getCplc() throws -> String
    
    /// 默认卡(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameters:
    ///   - non: (非)默认卡
    ///   - city: 城市
    /// - Returns: Void
    /// - Throws: Error
    func setDefault(_ non: Bool, for city: PayCity) throws
    
    /// 是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: BOOL
    /// - Throws: Error
    func isDefaultCard(for city: PayCity) throws -> Bool
    
    /// 卡余额(分)(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameter city: 城市
    /// - Returns: Int
    /// - Throws: Error
    func cardBalance(_ city: PayCity) throws -> Int
    
    /// 交易信息列表查询(从设备里获取)(注: 会涉及蓝牙操作，调用PayApduProtocol实现)
    ///
    /// - Parameter city: 城市
    /// - Returns: DealInfo array
    /// - Throws: Error
    func dealInfoListFromCard(_ city: PayCity) throws -> [DealInfo]
    
    /// 卡信息
    ///
    /// - Parameter city: 尘世
    /// - Returns: PayCardInfo
    /// - Throws: Error
    func queryCardInfo(_ city: PayCity) throws -> PayCardInfo
    
    /// 查询已开通卡列表(从设备中获取)
    ///
    /// - Returns: PayCardInfo array
    /// - Throws: Error
    func queryCardListFromDevice() throws -> [PayCityCardInstallInfo]
}
