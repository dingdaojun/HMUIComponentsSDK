//
//  PayCard+Deal.swift
//  Cache
//
//  Created by 余彪 on 2018/4/3.
//

import Foundation

extension PaySE {
    /// 获取交易记录
    ///
    /// - Parameter city: 城市
    /// - Returns: [DealInfo]
    /// - Throws: Error
    public func dealInfoListFromCard(_ city: PayCity) throws -> [DealInfo] {
        try PayTransmit.shared.openNFCChannel()
        return try city.cityProtocol.getDealRecords()
    }
}


