//
//  PayCloud+Deal.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/5/28.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

class Record: NSObject, HMServiceAPIBUSCardTransactionRecord {
    var api_busCardTransactionRecordTime: Date?
    var api_busCardTransactionRecordState: String?
    var api_busCardTransactionRecordAmount: Int
    var api_busCardTransactionRecordLocation: String?
    var api_busCardTransactionRecordServiceProvider: String?
    var api_busCardTransactionRecordType: String?
    
    init(_ info: DealInfo) {
        api_busCardTransactionRecordTime = info.dealTime
        api_busCardTransactionRecordState = "SUCCESS"
        api_busCardTransactionRecordAmount = info.dealAmount
        api_busCardTransactionRecordLocation = ""
        api_busCardTransactionRecordServiceProvider = ""
        
        switch info.dealType {
        case .recharge:
            api_busCardTransactionRecordType = "TOPUP"
        case .localConsumption, .remoteConsumption:
            api_busCardTransactionRecordType = "CONSUME"
        case .openCard:
            api_busCardTransactionRecordType = "OPEN_CARD"
        }
    }
}

extension PayCloud {
    /// 获取交易记录
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - cardNumber: 卡号
    ///   - nextDate: 下个时间点
    ///   - limit: 限制: 默认10个
    ///   - callback: 回调
    public func dealInfoListFromNetwork(city: PayCity, cardNumber: String, nextDate: Date?, limit: Int = 10, callback: @escaping DealListNetworkCallback) {
        PayTransmit.shared.payQueue.async {
            let network = PayTransmit.shared.nfcService.busCard_transactionRecord(withCityID: city.info.code, cardID: cardNumber, type: .consumption, nextTime: nextDate, limit: limit, completionBlock: { (success, msg, dealLists, nextDate) in
                PayTransmit.shared.payQueue.async {
                    guard success else {
                        callback(nil, nil, PayError.networkError(msg: msg ?? ""))
                        return
                    }
                    
                    guard let list = dealLists else {
                        callback([], nil, nil)
                        return
                    }
                    
                    var dealInfoLists: [DealInfo] = []
                    for dealInfo in list {
                        let dealType = DealType.recharge
                        let dealInfo = DealInfo(dealTime: dealInfo.api_busCardTransactionRecordTime!, dealAmount: dealInfo.api_busCardTransactionRecordAmount, dealType: dealType)
                        dealInfoLists.append(dealInfo)
                    }
                    callback(dealInfoLists, nextDate, nil)
                }
            })
            if self.printCurl { network?.printCURL() }
        }
    }
    
    /// 上传交易记录
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - cardNumber: 卡号
    ///   - dealList: 交易记录数据
    ///   - callback: 回调
    public func uploadDealList(city: PayCity, cardNumber: String, dealList: [DealInfo], callback: @escaping UploadDealListCallback) {
        PayTransmit.shared.payQueue.async {
            var records: [Record] = []
            for info in dealList {
                let record = Record(info)
                records.append(record)
            }
            
            let network = PayTransmit.shared.nfcService.busCard_uploadTransactionRecord(withCityID: city.info.code, cardID: cardNumber, records: records, completionBlock: { (success, msg) in
                PayTransmit.shared.payQueue.async {
                    if success {
                        callback(nil)
                    } else {
                        callback(PayError.networkError(msg: msg ?? ""))
                    }
                }
            })
            if self.printCurl { network?.printCURL() }
        }
    }
}
