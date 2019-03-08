//
//  PayCityChongqing.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/29.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


public class PayCityChongqing: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "" }
    public static var aid: Data { return Data.init(hex: "4351515041592E5359533331") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "重庆公交" }
    public static var cityCode: String { return "0023" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityChongqing.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityChongqing.aid)
    }
}

extension PayCityChongqing {
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
        
        // 选ADF1
        let f = try PayTransmit.shared.transmit(Data.init(hex: "00A4040009A00000000386980701"))
        guard f.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: f)
        }
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))C417"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            let dealMoney = infoRes.subdata(in: 5..<9).toUInt32()
            let dealType = Int(infoRes.subdata(in: 9..<10).bytes[0]).toIntRadix16()
            var date = Date.bytesToPayDate(resData: infoRes.subdata(in: 16..<20))
            let timeBytes = infoRes.subdata(in: 20..<23).bytes
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
        let validate = try getCardValidate()
        var info = PayCardInfo()
        info.validity = validate.endDate
        info.startDate = validate.startDate
        info.balance = try readBalance()
        info.number = try readCardNum()
        return info
    }
}

extension PayCityChongqing {
    public func getRechargeRecords() throws -> [DealInfo] {
        try select()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 圈存
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

extension PayCityChongqing {
    func readBalance() throws -> Int {
        // 查询余额
        let balanceRes = try PayTransmit.shared.transmit(Data.init(hex: "805C000204"))
        guard balanceRes.count >= 4 else { throw PayError.errorApduResponse(response: balanceRes) }
        let balance = balanceRes.subdata(in: 0..<4).toUInt32()
        return Int(balance)
    }
    
    func getCardValidate() throws -> (startDate: Date, endDate: Date) {
        try select()
        
        // 应用基本信息查询指令
        let res = try PayTransmit.shared.transmit(Data.init(hex: "00B0950020"))
        guard res.validateRegex(successRegex),
              res.count >= 8 else {
            throw PayError.errorApduResponse(response: res)
        }
        
        var start = Date()
        if res.subdata(in: 4..<8).toHexString() != "00000000" {
            start = Date.bytesToPayDate(resData: res.subdata(in: 4..<8))
        }
        
        var end = Date()
        if res.subdata(in: 4..<8).toHexString() != "00000000" {
            guard res.count >= 12 else { throw PayError.errorApduResponse(response: res) }
            end = Date.bytesToPayDate(resData: res.subdata(in: 8..<12))
            end.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        }
        return (start, end)
    }
    
    func readCardNum() throws -> String {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityChongqing.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
        
        // 读取逻辑卡号指令
        let res = try PayTransmit.shared.transmit(Data.init(hex: "00B0850030"))
        guard res.validateRegex(successRegex),
              res.count >= 20 else {
            throw PayError.errorApduResponse(response: res)
        }
        
        return res.subdata(in: 12..<20).toHexString()
    }
    
    func select() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityChongqing.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
        
        // 选ADF1
        let f = try PayTransmit.shared.transmit(Data.init(hex: "00A4040009A00000000386980701"))
        guard f.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: f)
        }
    }
}
