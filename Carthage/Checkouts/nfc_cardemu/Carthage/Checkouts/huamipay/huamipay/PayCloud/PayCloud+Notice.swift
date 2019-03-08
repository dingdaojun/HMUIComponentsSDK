//
//  PayCloud+Notice.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/3.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

extension PayCloud {
    /// 获取通告
    ///
    /// - Parameter callback: 回调
    public func fetchNotice(callback: @escaping PayCloudProtocol.NoticeCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.busCard_busCompanyNotice(completionBlock: { (success, msg, apiNotices) in
                guard success,
                      let notices = apiNotices else { callback([], PayError.networkError(msg: msg ?? "")); return; }
                callback(self.getPayNotices(notices), nil)
            })
        }
    }
    
    /// 获取公告(指定城市)
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - callback: 回调
    public func fetchNotice(for city: PayCity, callback: @escaping PayCloudProtocol.NoticeCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.busCard_busCompanyNotice(withCityID: city.info.code, completionBlock: { (success, msg, apiNotices) in
                guard success,
                    let notices = apiNotices else { callback([], PayError.networkError(msg: msg ?? "")); return; }
                callback(self.getPayNotices(notices), nil)
            })
        }
    }
}

extension PayCloud {
    func getPayNotices(_ apiNotices: [HMServiceAPIBUSCardCompanyNotice]) -> [PayNotice] {
        var payNotices: [PayNotice] = []
        for apiNotice in apiNotices {
            var notice = PayNotice()
            notice.identifier = apiNotice.api_busCardCompanyNoticeID ?? ""
            let cities = apiNotice.api_busCardCompanyNoticeCities ?? []
            var supoortCities: [PayCity] = []
            for appCode in cities {
                guard let city = PayCity.cityCode(appCode) else { continue }
                supoortCities.append(city)
            }
            notice.cities = supoortCities
            notice.context = apiNotice.api_busCardCompanyNoticeContext ?? ""
            notice.isCrossBarJump = apiNotice.api_busCardCompanyNoticeSupportCrossBarJump
            let urlString = apiNotice.api_busCardCompanyNoticeCrossBarUrl ?? ""
            notice.jumpURL = URL(string: urlString)
            notice.loop = PayNotice.NoticeLoop(rawValue: apiNotice.api_busCardCompanyNoticeLoopType ?? "") ?? .none
            notice.type = PayNotice.NoticeType.getNoticeTypes(apiNotice.api_busCardCompanyNoticeTypes as! [String])
            notice.startDate = apiNotice.api_busCardCompanyNoticeStartTime ?? Date()
            notice.endDate = apiNotice.api_busCardCompanyNoticeEndTime ?? Date()
            notice.updateDate = apiNotice.api_busCardCompanyNoticeUpdateTime ?? Date()
            payNotices.append(notice)
        }
        return payNotices
    }
}

