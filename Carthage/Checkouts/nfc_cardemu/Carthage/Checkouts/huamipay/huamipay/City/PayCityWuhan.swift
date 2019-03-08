//
//  PayCityWuhan.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/23.
//

import Foundation

public class PayCityWuhan: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "WHT" }
    public static var aid: Data { return Data.init(hex: "A0000053425748544B") }
    public static var miFetchModel: String { return "SYNC" }
    public static var cityName: String { return "武汉公交" }
    public static var cityCode: String { return "0027" }
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityWuhan.aid)
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityWuhan.aid)
    }
}

extension PayCityWuhan {
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
        try verfyPin()
        
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
        let balance = try readBalance()
        
        try verfyPin()
        // info
        let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00B0950000"))
        guard infoRes.validateRegex(successRegex),
              infoRes.count >= 28 else { throw PayError.errorApduResponse(response: infoRes) }
        
        var cardInformation = PayCardInfo()
        cardInformation.startDate = Date.bytesToPayDate(resData: infoRes.subdata(in: 20..<24));
        cardInformation.validity = Date.bytesToPayDate(resData: infoRes.subdata(in: 24..<28));
        cardInformation.validity.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        cardInformation.number = infoRes.subdata(in: 0..<8).toHexString()
        cardInformation.number = logicToReal(cardInformation.number)
        cardInformation.balance = balance
        return cardInformation
    }
}

extension PayCityWuhan {
    public func getRechargeRecords() throws -> [DealInfo] {
        return []
    }
}

extension PayCityWuhan {
    // 逻辑卡号转卡面号
    func logicToReal(_ logicCardNum: String) -> String {
        // 取后9位
        let cardLength = 9
        let startIndex = logicCardNum.index(logicCardNum.startIndex, offsetBy: (logicCardNum.count - cardLength))
        let cardNum = String(logicCardNum[startIndex...])
        var result: UInt8? = nil
        // 9 位数据依次异或后对 10 取余后产生校验位，计算后得出校验位
        for index in 0..<cardNum.count {
            let lowerIndex = cardNum.index(cardNum.startIndex, offsetBy: index)
            let upperIndex = cardNum.index(lowerIndex, offsetBy: 1)
            let current = UInt8(cardNum[lowerIndex..<upperIndex])!
            print(current)
            if result == nil {
                result = current
            } else {
                result = result! ^ current
            }
        }
        let validate = result! % 10
        // 9 位数据加上校验位生成 9 位卡面号，计算后得出卡面号
        let resultCardNum = Int(cardNum)! + Int(validate)
        // 不足9位的时候，在前面补充0
        let c = cardLength - "\(resultCardNum)".count
        if c != 0  {
            var m = String.init(repeating: "0", count: c)
            m.append("\(resultCardNum)")
            return m
        }
        
        return "\(resultCardNum)"
    }
}

extension PayCityWuhan {
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
        try selectAid()
        try selectADF()
    }
    
    func selectAid() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityWuhan.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
    }
    func selectADF() throws {
        // ADF
        let selADFRes = try PayTransmit.shared.transmit(Data.init(hex: "00A40000021001"))
        guard selADFRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selADFRes)
        }
    }
    
    func verfyPin() throws {
        // 发送 VerifyPIN 指令
        let verfyPinRes = try PayTransmit.shared.transmit(Data.init(hex: "0020000003123456"))
        guard verfyPinRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: verfyPinRes)
        }
    }
}
