//
//  PayCard+InstallCity.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/29.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import TWTagLengthValue

enum CityState {
    case none
    case normal
    case defaultCity
}

extension PaySE {
    /// 查询SE卡列表(此接口Wallet不使用，仅demo使用)
    ///
    /// - Returns: [PayCityCardInstallInfo]
    /// - Throws: Error
    public func queryCardListFromDevice() throws -> [PayCityCardInstallInfo] {
        try PayTransmit.shared.openNFCChannel()
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(CRS_AID))
        guard selRes.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: selRes) }
        var resultData = Data()
        let queryData = Data.init(hex: "80F24002024F00")
        var queryRes = try PayTransmit.shared.transmit(queryData)
        let validate = ".*6310$"
        var isContinue = queryRes.validateRegex(validate)
        queryRes.remove6310()
        resultData.append(queryRes)
        // 如果是6310，说明后面还有数据
        while isContinue {
            let queryNextData = Data.init(hex: "80F24003024F00")
            let queryNextRes = try PayTransmit.shared.transmit(queryNextData)
            isContinue = queryNextRes.validateRegex(validate)
            if isContinue {
                queryRes.remove6310()
            } else {
                queryRes.remove9000()
            }
            resultData.append(queryNextRes)
        }
        
        let result = resultData.toHexString()
        var installCityList: [PayCityCardInstallInfo] = []
        for city in PayCity.all {
            var state: CityState = .none
            if result.contains("\(city.aid.toHexString())9f70020701") ||
               result.contains("\(city.aid.toHexString())9f70021701") {
                state = .defaultCity
            } else if result.contains("\(city.aid.toHexString())9f70020700") ||
                      result.contains("\(city.aid.toHexString())9f70021700") {
                state = .normal
            }
            
            guard state != .none else { continue }
            var cityInfo = PayCityCardInstallInfo()
            cityInfo.city = city.city
            cityInfo.aid = city.city.info.aid
            cityInfo.cityId = city.city.info.code
            cityInfo.cityName = city.city.info.name
            cityInfo.isActivity = state == .defaultCity
            
            installCityList.append(cityInfo)
        }
        
        return installCityList
    }
}
