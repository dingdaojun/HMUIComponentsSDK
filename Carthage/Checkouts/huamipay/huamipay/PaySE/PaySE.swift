//
//  PayCard.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/16.
//

import Foundation
import CryptoSwift
import WalletService


public class PaySE: PaySEProtocol {
    /// 读取CPLC
    ///
    /// - Returns: CPLC
    /// - Throws: Error
    public func getCplc() throws -> String {
        try PayTransmit.shared.openNFCChannel()
        let _ = try PayTransmit.shared.transmit(PayCityBase.select(ISD_AID))
        let data = try PayTransmit.shared.transmit(Data.init(hex: "80CA9F7F00"))
        guard data.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: data) }
        // 从第三个开始，去除后面的9000
        guard data.count > 5 else { throw PayError.errorApduResponse(response: data) }
        let cplc = data.subdata(in: 3..<(data.count - 2))
        return cplc.toHexString()
    }
    
    /// 查询是否默认卡
    ///
    /// - Parameter city: 城市
    /// - Returns: true/false
    /// - Throws: Error
    public func isDefaultCard(for city: PayCity) throws -> Bool {
        return try city.cityProtocol.isDefault()
    }

    /// 设置默认卡(去除默认卡)
    ///
    /// - Parameters:
    ///   - non: true: 设置默认卡；false: 去除默认卡
    ///   - city: 城市
    /// - Throws: Error
    public func setDefault(_ non: Bool, for city: PayCity) throws {
        try city.cityProtocol.setDefault(non, for: city)
    }
    
    /// 余额
    ///
    /// - Parameter city: 城市
    /// - Returns: 余额
    /// - Throws: Error
    public func cardBalance(_ city: PayCity) throws -> Int {
        try PayTransmit.shared.openNFCChannel()
        return try city.cityProtocol.getBance()
    }

    /// 卡详情
    ///
    /// - Parameter city: 城市
    /// - Returns: PayCardInfo
    /// - Throws: Error
    public func queryCardInfo(_ city: PayCity) throws -> PayCardInfo {
        try PayTransmit.shared.openNFCChannel()
        return try city.cityProtocol.getCardInformation()
    }
}
