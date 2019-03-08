//
//  PayCityShenzhen.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/22.
//

import Foundation


public class PayCityShenzhen: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "SZT" }
    public static var aid: Data { return Data.init(hex: "535A542E57414C4C45542E454E56") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "深圳通" }
    public static var cityCode: String { return "0755" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityShenzhen.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityShenzhen.aid)
    }
}

extension PayCityShenzhen {
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
            // 消费
            let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B2\(String(format:"%02X",index))C400"))
            guard infoRes.validateRegex(dealSuccessRegex),
                  infoRes.count >= 23 else { break }
            let dealMoney = infoRes.subdata(in: 5..<9).toUInt32()
            let dealType = Int(infoRes.subdata(in: 9..<10).bytes[0]).toIntRadix16()
            var date = Date.bytesToPayDate(resData: infoRes.subdata(in: 16..<20))
            let timeBytes = infoRes.subdata(in: 20..<23).bytes
            let hour = Int(timeBytes[0]).toIntRadix16()
            let min = Int(timeBytes[1]).toIntRadix16()
            let sec = Int(timeBytes[2]).toIntRadix16()
            date = date.addingTimeInterval(TimeInterval(hour * 60 * 60 + min * 60 + sec))
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
        
        // info
        let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B0950000"))
        guard infoRes.validateRegex(successRegex),
              infoRes.count >= 28 else { throw PayError.errorApduResponse(response: infoRes) }
        
        var cardInformation = PayCardInfo()
        cardInformation.startDate = Date.bytesToPayDate(resData: infoRes.subdata(in: 20..<24));
        cardInformation.validity = Date.bytesToPayDate(resData: infoRes.subdata(in: 24..<28));
        cardInformation.validity.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        let cardID = infoRes.subdata(in: 10..<20)
        let cardNum = cardID.subdata(in: (cardID.count - 4)..<cardID.count)
        let litter = Int32(littleEndian: cardNum.withUnsafeBytes { $0.pointee })
        cardInformation.number = "\(litter)"
        cardInformation.balance = try readBalance()
        // 不足9位的时候，在前面补充0
        let c = 9 - cardInformation.number.count
        if c != 0  {
            var s = String.init(repeating: "0", count: c)
            s.append(cardInformation.number)
            cardInformation.number = s
        }
        
        return cardInformation
    }
}

extension PayCityShenzhen {
    public func getRechargeRecords() throws -> [DealInfo] {
        return []
    }
}

extension PayCityShenzhen {
    func readBalance() throws -> Int {
        // bance
        let banRes = try PayTransmit.shared.transmit(Data.init(hex: "805C000204"))
        guard banRes.validateRegex(successRegex),
              banRes.count >= 4 else {
            throw PayError.errorApduResponse(response: banRes)
        }
        
        let readBalance = banRes.subdata(in: 0..<4).toUInt32()
        let staticBalance = Data.init(hex: "80000000").toUInt32()
        return Int(readBalance - staticBalance)
    }
    
    func select() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityShenzhen.aid))
        guard selRes.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: selRes) }
        
        // ADF
        let ADF_APDU = Data.init(hex: "00A40000021001")
        let selADFRes = try PayTransmit.shared.transmit(ADF_APDU)
        guard selADFRes.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: selADFRes) }
    }
}
