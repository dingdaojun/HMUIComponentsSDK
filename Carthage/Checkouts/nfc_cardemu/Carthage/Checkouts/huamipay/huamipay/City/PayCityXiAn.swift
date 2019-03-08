//
//  PayCityXiAn.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/13.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

public class PayCityXiAn: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "XIAN" }
    public static var aid: Data { return Data.init(hex: "A0000000037100869807010000000000") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "西安" }
    public static var cityCode: String { return "0029" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityXiAn.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityXiAn.aid)
    }
}

extension PayCityXiAn {
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
        // select
        try select()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))C400"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            let dealMoney = infoRes.subdata(in: 5..<9).toUInt32()
            let dealType = Int(infoRes.subdata(in: 9..<10).bytes[0]).toIntRadix16()
            var date = Date.bytesToPayDate(resData: infoRes.subdata(in: 16..<20))
            let timeBytes = infoRes.subdata(in: 20..<23)
            let hour = Int(timeBytes[0]).toIntRadix16()
            let min = Int(timeBytes[1]).toIntRadix16()
            let sec = Int(timeBytes[2]).toIntRadix16()
            date =  date.addingTimeInterval(TimeInterval(hour * 60 * 60 + min * 60 + sec))
            if dealMoney != 0 {
                var dealInfo = DealInfo(dealTime: date, dealAmount: Int(dealMoney), dealType: DealType.localConsumption)
                if dealType.isChargeDealType {dealInfo.dealType = .recharge }
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
        
        // 设备信息
        let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B0950000"))
        guard infoRes.validateRegex(successRegex),
              infoRes.count >= 28 else { throw PayError.errorApduResponse(response: infoRes) }
        
        let start = Date.bytesToPayDate(resData: infoRes.subdata(in: 20..<24))
        var end = Date.bytesToPayDate(resData: infoRes.subdata(in: 24..<28))
        end.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        let cardData = infoRes.subdata(in: 12..<20)
        let lastCard = cardData.subdata(in: 4..<8)
        let lastHex = lastCard.toUInt32()
        let cardNum = "\(cardData.subdata(in: 0..<4).toHexString().uppercased())\(String(lastHex, radix: 10, uppercase: true)))"
        
        var info = PayCardInfo()
        info.number = cardNum
        info.validity = end
        info.startDate = start
        info.balance = try readBalance()
        return info
    }
}

extension PayCityXiAn {
    public func getRechargeRecords() throws -> [DealInfo] {
        // select
        try select()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))FC00"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            let dealMoney = infoRes.subdata(in: 5..<9).toUInt32()
            var date = Date.bytesToPayDate(resData: infoRes.subdata(in: 16..<20))
            let timeBytes = infoRes.subdata(in: 20..<23).bytes
            let hour = Int(timeBytes[0]).toIntRadix16()
            let min = Int(timeBytes[1]).toIntRadix16()
            let sec = Int(timeBytes[2]).toIntRadix16()
            date = date.addingTimeInterval(TimeInterval(hour * 60 * 60 + min * 60 + sec))
            let dealInfo = DealInfo(dealTime: date, dealAmount: Int(dealMoney), dealType: DealType.recharge)
            dealList.append(dealInfo)
        }
        
        return dealList
    }
}

extension PayCityXiAn {
    func readBalance() throws -> Int {
        // bance
        let banRes = try PayTransmit.shared.transmit(Data.init(hex: "805C000204"))
        guard banRes.validateRegex(successRegex),
              banRes.count >= 4 else {
            throw PayError.errorApduResponse(response: banRes)
        }
        
        let value = banRes.subdata(in: 0..<4).toUInt32()
        return Int(value)
    }
    
    func select() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityXiAn.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
        
        // 选择ADF1
        let selADFRes = try PayTransmit.shared.transmit(Data.init(hex: "00A40000023F01"))
        guard selADFRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selADFRes)
        }
    }
}
