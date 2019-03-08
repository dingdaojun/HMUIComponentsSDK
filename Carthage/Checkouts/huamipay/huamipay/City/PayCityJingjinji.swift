//
//  PayCityjingjinji.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/28.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

public class PayCityJingjinji: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "BMAC_MOT" }
    public static var aid: Data { return Data.init(hex: "A00000063201010510009156000014A1") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "北京MOT" } //EP
    public static var cityCode: String { return "9005" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityJingjinji.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityJingjinji.aid)
    }
}

extension PayCityJingjinji {
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
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))C417"))
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
        let enableFlag = Int(infoRes.subdata(in: 9..<10).toHexString())
        var info = PayCardInfo()
        info.validity = end
        info.startDate = start
        info.balance = try readBalance()
        info.isAvailable = (enableFlag == 1) ? true : false
        typealias JJJCardNumBlockingQueue = PaySyncValue<String>
        let cardNumQueue = JJJCardNumBlockingQueue()
        var cardNumber = infoRes.subdata(in: 10..<20).toHexString()
        cardNumber.removeFirst()
        let result = PayTransmit.shared.nfcService.wallet_cardID(withCityID: PayCityJingjinji.cityCode, aid: PayCityJingjinji.aid.toHexString(), cardNumber: cardNumber) { (state, msg, cardNum) in
            if state == PayNetworkState.success.rawValue,
               let num = cardNum  {
                cardNumQueue.push(num)
            } else {
                cardNumQueue.push("")
            }
        }
        
        result?.printCURL()
        
        info.number = try cardNumQueue.pop(timeout: 30.0)
        return info
    }
}

extension PayCityJingjinji {
    public func getRechargeRecords() throws -> [DealInfo] {
        // select
        try select()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))FC17"))
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

extension PayCityJingjinji {
    func readBalance() throws -> Int {
        // 读取已透⽀⾦额指令
        let overdraftRes = try PayTransmit.shared.transmit(Data.init(hex: "805C020204"))
        guard overdraftRes.validateRegex(successRegex),
              overdraftRes.count >= 4 else { throw PayError.errorApduResponse(response: overdraftRes) }
        let overdraftBalance = overdraftRes.subdata(in: 0..<4).toUInt32()
        guard overdraftBalance >= 0 else { throw PayError.overdraftLessThanZero(response: overdraftRes) }
        
        // 读取电⼦钱包实际余额指令
        let realRes = try PayTransmit.shared.transmit(Data.init(hex: "805C030204"))
        guard realRes.validateRegex(successRegex),
              realRes.count >= 4 else { throw PayError.errorApduResponse(response: realRes) }
        let realBalance = realRes.subdata(in: 0..<4).toUInt32()
        if overdraftBalance > 0, realBalance > 0 { throw PayError.overdraftBalanceBothValue(response: realRes) }
        return Int(realBalance - overdraftBalance)
    }
    
    func select() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityJingjinji.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
        
        // 选择ADF1
        let selADFRes = try PayTransmit.shared.transmit(Data.init(hex: "00A4000002ADFA"))
        guard selADFRes.validateRegex(successRegex) else {
            if selADFRes.validateRegex(".*6283$") { throw PayError.blackCard }
            throw PayError.errorApduResponse(response: selADFRes)
        }
    }
}
