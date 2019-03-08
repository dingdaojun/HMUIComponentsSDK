//
//  PayCityZhengzhou.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/29.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

public class PayCityZhengzhou: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "ZHENGZHOU" }
    public static var aid: Data { return Data.init(hex: "A0000053425A5A4854") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "郑州通" }
    public static var cityCode: String { return "0371" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityZhengzhou.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityZhengzhou.aid)
    }
}

extension PayCityZhengzhou {
    /// 余额(分)
    ///
    /// - Returns: Int
    /// - Throws: Error
    public func getBance() throws -> Int {
        try select()
        return try readBalance()
    }
    
    /// 交易记录
    ///
    /// - Returns: [DealInfo]
    /// - Throws: Error
    public func getDealRecords() throws -> [DealInfo] {
        try select()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 本地消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))C400"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            var dealInfo = analysisDealInfo(infoRes)
            if dealInfo.dealAmount != 0 {
                dealInfo.dealType = .localConsumption
                dealList.append(dealInfo)
            }
        }
        
        for index in 1...defaultDealCount {
            // 异地消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))8400"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            var dealInfo = analysisDealInfo(infoRes)
            if dealInfo.dealAmount != 0 {
                dealInfo.dealType = .remoteConsumption
                dealList.append(dealInfo)
            }
        }
        return dealList
    }
    
    /// 获取卡信息
    ///
    /// - Returns: PayCardInfo
    /// - Throws: Error
    public func getCardInformation() throws -> PayCardInfo {
        try select()
        
        // 应用基本信息查询指令
        let res = try PayTransmit.shared.transmit(Data.init(hex: "00B0950000"))
        guard res.validateRegex(successRegex),
              res.count >= 28 else { throw PayError.errorApduResponse(response: res) }
        
        let start = Date.bytesToPayDate(resData: res.subdata(in: 20..<24))
        var end = Date.bytesToPayDate(resData: res.subdata(in: 24..<28))
        end.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        let cardNum = res.subdata(in: 12..<20).toHexString()
        
        var info = PayCardInfo()
        info.validity = end
        info.startDate = start
        info.number = cardNum
        info.balance = try readBalance()
        
        return info
    }
}

extension PayCityZhengzhou {
    public func getRechargeRecords() throws -> [DealInfo] {
        try select()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 圈存
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))D400"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            var dealInfo = analysisDealInfo(infoRes)
            dealInfo.dealType = DealType.recharge
            dealList.append(dealInfo)
        }
        return dealList
    }
}

extension PayCityZhengzhou {
    func readBalance() throws -> Int {
        // 查询余额
        let balanceRes = try PayTransmit.shared.transmit(Data.init(hex: "805C000204"))
        guard balanceRes.count >= 4 else { throw PayError.errorApduResponse(response: balanceRes) }
        let balance = balanceRes.subdata(in: 0..<4).toUInt32()
        return Int(balance)
    }
    
    func select() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityZhengzhou.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
        
        // 选ADF1
        let f = try PayTransmit.shared.transmit(Data.init(hex: "00A40000021001"))
        guard f.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: f)
        }
    }
    
    func analysisDealInfo(_ infoRes: Data) -> DealInfo {
        let dealMoney = infoRes.subdata(in: 5..<9).toUInt32()
        var date = Date.bytesToPayDate(resData: infoRes.subdata(in: 16..<20))
        let timeBytes = infoRes.subdata(in: 20..<23).bytes
        let hour = Int(timeBytes[0]).toIntRadix16()
        let min = Int(timeBytes[1]).toIntRadix16()
        let sec = Int(timeBytes[2]).toIntRadix16()
        date = date.addingTimeInterval(TimeInterval(hour * 60 * 60 + min * 60 + sec))
        let dealInfo = DealInfo(dealTime: date, dealAmount: Int(dealMoney), dealType: DealType.recharge)
        return dealInfo
    }
}
