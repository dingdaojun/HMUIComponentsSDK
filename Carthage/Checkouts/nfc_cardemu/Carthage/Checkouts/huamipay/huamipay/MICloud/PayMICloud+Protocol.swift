//
//  PayMICloud+Protocol.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/4.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


extension PayMICloud {
    /// 获取协议接口
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - actionType: 接口类型
    ///   - callback: 回调
    /// - Returns: Void
    public func fetchProtocol(for city: PayCity, with actionType: PayProtocolActionType, callback: @escaping ProtocolCallback) {
        let cardName = city.info.miName
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.wallet_protocol(withXiaomiCardName: cardName, acctionType: actionType.rawValue, completionBlock: { (state, msg, apiProtocol) in
                guard state != PayNetworkState.networkFail.rawValue else {
                    callback(nil, PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                guard state == PayNetworkState.success.rawValue else {
                    callback(nil,  PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                                      PayError.errorMsg: msg ?? ""])))
                    return
                }
                
                guard let pro = apiProtocol else {
                    callback(nil, nil)
                    return
                }
                
                var serviceProtocol = PayProtocol()
                serviceProtocol.identifier = pro.api_walletProtocolID
                serviceProtocol.title = pro.api_walletProtocolTitle
                serviceProtocol.url = pro.api_walletProtocolContent
                callback(serviceProtocol, nil)
            }).printCURL()
        }
    }
    
    /// 确认协议
    ///
    /// - Parameters:
    ///   - identifier: 协议ID
    ///   - callback: 回调
    /// - Returns: Void
    public func configProtocol(for identifier: String, callback: @escaping HuamipayMICloudProtocol.ConfigProtocolCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.wallet_confirmProtocol(withID: identifier, completionBlock: { (state, msg) in
                guard state != PayNetworkState.networkFail.rawValue else {
                    callback(PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                guard state == PayNetworkState.success.rawValue else {
                    callback(PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                                PayError.errorMsg: msg ?? ""])))
                    return
                }
                callback(nil)
            })
        }
    }
}
