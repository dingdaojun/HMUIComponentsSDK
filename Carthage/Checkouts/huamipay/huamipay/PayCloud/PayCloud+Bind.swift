//
//  PayCloud+Bind.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/5/28.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


class BindCard: NSObject, HMServiceAPIBUSCardsBindingCard {
    var api_busCardsBindingCardID: String
    var api_busCardsBindingCardCityCode: String
    var api_busCardsBindingCardApplicationID: String
    var api_busCardsBindingCardLastUpdateTime: Date
    var api_busCardsBindingCardStatus: String
    
    init(_ city: PayCity) {
        api_busCardsBindingCardID = ""
        api_busCardsBindingCardCityCode = city.info.code
        api_busCardsBindingCardApplicationID = city.info.aid.toHexString()
        api_busCardsBindingCardLastUpdateTime = Date() // 开卡就是当前时间
        api_busCardsBindingCardStatus = ""
    }
}


// MARK: - 此处两个接口，废弃
extension PayCloud {
    /// 绑定公交卡(废弃)
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - cardNumber: 卡号
    ///   - deviceType: 设备id
    ///   - city: 城市
    ///   - callback: 回调
    @available(*, deprecated, message: "云端调整为实时与雪球同步，废弃")
    public func bindCard(deviceID: String, cardNumber: String, deviceType: Int, city: PayCity, callback: @escaping BindCardCallback) {
        PayTransmit.shared.payQueue.async {
            let bindCard = BindCard(city)
            bindCard.api_busCardsBindingCardID = cardNumber
            let network = PayTransmit.shared.nfcService.busCardsBinding_bind(withDeviceID: deviceID, deviceType: deviceType, card: bindCard, completionBlock: { (success, msg) in
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
    
    /// 解除绑定公交卡(废弃)
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - cardNumber: 卡号
    ///   - callback: 回调
    @available(*, deprecated, message: "云端调整为实时与雪球同步，废弃")
    public func unBindCard(deviceID: String, cardNumber: String, callback: @escaping UnBindCardCallback) {
        PayTransmit.shared.payQueue.async {
            let network = PayTransmit.shared.nfcService.busCardsBinding_unbind(withDeviceID: deviceID, cardID: cardNumber) { (success, msg) in
                PayTransmit.shared.payQueue.async {
                    if success {
                        callback(nil)
                    } else {
                       callback(PayError.networkError(msg: msg ?? ""))
                    }
                }
            }
            if self.printCurl { network?.printCURL() }
        }
    }
}
