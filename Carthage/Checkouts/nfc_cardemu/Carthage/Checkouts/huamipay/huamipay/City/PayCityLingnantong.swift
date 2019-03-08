//
//  PayCityLingnantong.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/23.
//

import Foundation


public class PayCityLingnantong: PayCityBase, CityCardApduProtocol {
    public static var miCardName: String { return "LNT" }
    public static var aid: Data { return Data.init(hex: "5943542E55534552") }
    public static var miFetchModel: String { return "SYNC" }
    // 获取他之前一定先设置子城市
    public static var cityName: String {
        return CityLingnantong.getSubCityInformation(city).cityName
    }
    // 获取他之前一定先设置子城市
    public static var cityCode: String {
        return CityLingnantong.getSubCityInformation(city).cityCode
    }
    // 一定要设置
    public static var city = CityLingnantong.guangzhou
    
    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try setDefault(non, aid: PayCityLingnantong.aid)
    }
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefault() throws -> Bool {
        return try isDefault(PayCityLingnantong.aid)
    }
}

extension PayCityLingnantong {
    /// 查询区域码
    ///
    /// - Returns: 区域码
    /// - Throws: Error
    public static func queryRegionCode() throws -> String {
        try PayTransmit.shared.openNFCChannel()
        let selectAidRsp = try PayTransmit.shared.transmit(PayCityBase.select(PayCityLingnantong.aid))
        guard selectAidRsp.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selectAidRsp)
        }
        let selectDDFRsp = try PayTransmit.shared.transmit(PayCityBase.select(Data.init(hex: "5041592E41505059")))
        guard selectDDFRsp.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selectDDFRsp)
        }
        let dataRsp = try PayTransmit.shared.transmit(Data.init(hex: "00B0953101"))
        guard dataRsp.validateRegex(successRegex),
              dataRsp.count >= 3 else {
            throw PayError.errorApduResponse(response: dataRsp)
        }
        print("queryCode: \(dataRsp.toHexString())")
        return dataRsp.subdata(in: 0..<1).toHexString()
    }
}

extension PayCityLingnantong {
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
        try selectAid()
        try selectDDF()
        
        let infoRes = try PayTransmit.shared.transmit(Data.init(hex: "00b0950058"))
        guard infoRes.validateRegex(successRegex),
              (infoRes.count >= 31) else {
                throw PayError.errorApduResponse(response: infoRes)
        }
        
        var cardInformation = PayCardInfo()
        cardInformation.startDate = Date.bytesToPayDate(resData: infoRes.subdata(in: 23..<27));
        cardInformation.validity = Date.bytesToPayDate(resData: infoRes.subdata(in: 27..<31));
        cardInformation.validity.addTimeInterval(86399) // 包含当天，加上一天23时59分59秒时间
        cardInformation.number = infoRes.subdata(in: 8..<16).toHexString().paySubString(start: 6)
        
        try selectADF()
        cardInformation.balance = try readBalance()
        return cardInformation
    }
}

extension PayCityLingnantong {
    public func getRechargeRecords() throws -> [DealInfo] {
        return []
    }
}

extension PayCityLingnantong {
    func readBalance() throws -> Int {
        // 读取余额
        let balanceRes = try PayTransmit.shared.transmit(Data.init(hex: "805C000204"))
        guard balanceRes.validateRegex(successRegex),
              (balanceRes.count >= 4) else {
            throw PayError.errorApduResponse(response: balanceRes)
        }
        
        let value = balanceRes.subdata(in: 0..<4).toUInt32()
        return Int(value)
    }
    
    func select() throws {
        try selectAid()
        try selectDDF()
        try selectADF()
    }
    
    func selectAid() throws {
        // select
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(PayCityLingnantong.aid))
        guard selRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
    }
    func selectADF() throws {
        // 选择电子支付应用
        let appRes = try PayTransmit.shared.transmit(Data.init(hex: "00a4000002adf3"))
        guard appRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: appRes)
        }
    }
    
    func selectDDF() throws {
        // 选择钱包应用
        let appRes = try PayTransmit.shared.transmit(Data.init(hex: "00a4000002ddf1"))
        guard appRes.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: appRes)
        }
    }
}

extension CityLingnantong {
    public static func getSubCityInformation(_ subCity: CityLingnantong) -> (cityName: String, cityCode: String) {
        switch subCity {
        case .guangzhou:
            return ("广州", "0020")
        case .taizhou:
            return("台州", "0576")
        case .foushan:
            return ("佛山", "0757")
        case .zhuhai:
            return ("珠海", "0756")
        case .shanwei:
            return ("汕尾", "0660")
        case .jiangmen:
            return ("江门", "0750")
        case .zhaoqing:
            return ("肇庆", "0758")
        case .zhongshan:
            return ("中山", "0760")
        case .dongguan:
            return ("东莞", "0769")
        case .huizhou:
            return ("惠州", "0752")
        case .zhanjiang:
            return ("湛江", "0759")
        case .shantou:
            return ("汕头", "0754")
        case .shaoguan:
            return ("韶关", "0751")
        case .heyuan:
            return ("河源", "0762")
        case .yangjiang:
            return ("阳江", "0662")
        case .qingyuan:
            return ("清远", "0763")
        case .maoming:
            return ("茂名", "0668")
        case .meizhou:
            return ("梅州", "0753")
        case .chaozhou:
            return ("潮州", "0768")
        case .jieyang:
            return ("揭阳", "0663")
        case .yunfu:
            return ("云浮", "0766")
        }
    }
}
