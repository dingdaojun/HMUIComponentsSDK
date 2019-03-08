//
//  PayCityBeijin.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation
import WalletService

let select_beijin = Data.init(hex: "00A40000023F00")

public class PayCityBeijin: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "BMAC" }
    public static var aid: Data { return Data.init(hex: "9156000014010001") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "北京公交" }
    public static var cityCode: String { return "0010" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityBeijin.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityBeijin.aid)
    }
}

extension PayCityBeijin {
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
        try selectADF()
        
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
        info.validity.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        typealias BjCardNumBlockingQueue = PaySyncValue<String>
        let cardNumQueue = BjCardNumBlockingQueue()
        PayTransmit.shared.nfcService.wallet_cardID(withCityID: PayCityJingjinji.cityCode, aid: PayCityBeijin.aid.toHexString().uppercased(), cardNumber: validate.cardNum) { (state, msg, cardNum) in
            if state == PayNetworkState.success.rawValue,
                let num = cardNum  {
                cardNumQueue.push(num)
            } else {
                cardNumQueue.push("")
            }
        }

        info.number = try cardNumQueue.pop(timeout: 30.0)
        info.balance = try readBalance()
        return info
    }
}

extension PayCityBeijin {
    public func getRechargeRecords() throws -> [DealInfo] {
        try select()
        try selectADF()
        
        var dealList: [DealInfo] = []
        for index in 1...defaultDealCount {
            // 消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))9C17"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 11 else { break }
            let preMoney = dataToBytes(infoRes.subdata(in: 0..<3))
            let aftMoney = dataToBytes(infoRes.subdata(in: 3..<6))
            
            if infoRes.subdata(in: 8..<11).toHexString() != "000000" {
                let date = Date.threeBytesToPayDate(resData: infoRes.subdata(in: 8..<11))
                let dealInfo = DealInfo(dealTime: date, dealAmount: (aftMoney - preMoney), dealType: DealType.localConsumption)
                dealList.append(dealInfo)
            }
        }
        
        return dealList
    }
}

extension PayCityBeijin {
    func readBalance() throws -> Int {
        // 查询透支金额
        let overdraftRes = try PayTransmit.shared.transmit(Data.init(hex: "00B0850504"))
        guard overdraftRes.validateRegex(successRegex),
              overdraftRes.count >= 4 else {
            throw PayError.errorApduResponse(response: overdraftRes)
        }
        let overdraftBalance = overdraftRes.subdata(in: 0..<4).toUInt32()
        guard overdraftBalance >= 0 else { throw PayError.overdraftLessThanZero(response: overdraftRes) }
        
        try selectADF()
        
        // 查询余额
        let balanceRes = try PayTransmit.shared.transmit(Data.init(hex: "805C000204"))
        guard balanceRes.count >= 4 else { throw PayError.errorApduResponse(response: balanceRes) }
        let balance = balanceRes.subdata(in: 0..<4).toUInt32()
        if overdraftBalance > 0, balance > 0 { throw PayError.overdraftBalanceBothValue(response: balanceRes) }
        return Int(balance - overdraftBalance)
    }
    
    func getCardValidate() throws -> (startDate: Date, endDate: Date, cardNum: String) {
        try select()
        
        // 查询有效期
        let res = try PayTransmit.shared.transmit(Data.init(hex: "00B0841808"))
        guard res.validateRegex(successRegex),
              res.count >= 8 else {
            throw PayError.errorApduResponse(response: res)
        }
        
        let start = Date.bytesToPayDate(resData: res.subdata(in: 0..<4))
        let end = Date.bytesToPayDate(resData: res.subdata(in: 4..<8))

        // num
        let numRes = try PayTransmit.shared.transmit(Data.init(hex: "00B0840008"))
        guard numRes.validateRegex(successRegex),
              numRes.count >= 8 else {
            throw PayError.errorApduResponse(response: numRes)
        }
        
        return (start, end, numRes.subdata(in: 0..<8).toHexString())
    }
    
    func select() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityBeijin.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
        
        // 选3f00
        let f = try PayTransmit.shared.transmit(select_beijin)
        guard f.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: f)
        }
    }
    
    func selectADF() throws {
        // 选择ADF1
        let selADFRes = try PayTransmit.shared.transmit(Data.init(hex: "00A40000021001"))
        guard selADFRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selADFRes)
        }
    }
    
    // 需补位
    func dataToBytes(_ data: Data) -> Int {
        var value: Int32 = Int32(bigEndian: data.withUnsafeBytes { $0.pointee })
        value = value >> 8
        return Int(value)
    }
}
