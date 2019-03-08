//
//  PaySNCloud+CityList.swift
//  城市列表
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


extension PaySNCloud {
    /// 查询岭南通子城市列表
    ///
    /// - Parameters:
    ///   - location: 位置
    ///   - callback: RecommandCityListCallback
    public func queryRecommondCardInfoList(with location: CLLocationCoordinate2D, callback: @escaping RecommandCityListCallback) {
        fatalError("暂时不调用此接口")
    }
    
    /// 查询支持城市列表
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - callback: SupportCityListCallback
    public func supportCityList(with deviceID: String, callback: @escaping HuamipaySNCloudProtocol.SupportCityListCallback) {
        PayTransmit.shared.payQueue.async {
            let result = PayTransmit.shared.nfcService.busCard_city(withDeviceID: deviceID, completionBlock: { (success, msg, cities) in
                PayTransmit.shared.payQueue.async {
                    guard success else { callback([], PayError.networkError(msg: msg ?? "")); return; }
                    guard let p = cities else { callback([], nil); return; }
                    callback(PaySNCloud.generateCityInformation(p), nil)
                }
            })
            result?.printCURL()
        }
    }
    
    /// 查询已开通城市列表
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - callback: InstallCardListCallback
    public func openedCityList(with deivceID: String, callback: @escaping HuamipaySNCloudProtocol.OpenedCityListCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.busCardsBinding_openedCities(withDeviceID: deivceID, completionBlock: { (success, msg, cities) in
                PayTransmit.shared.payQueue.async {
                    guard success else { callback(nil, PayError.networkError(msg: msg ?? "")); return; }
                    var cityInfos: [PayCityCardInfo] = []
                    if let p = cities {
                        cityInfos = PaySNCloud.generateCityInformation(p)
                        let infos = cityInfos
                        cityInfos = infos.map({ (info) -> PayCityCardInfo in
                            var i = info
                            i.state = .install(stock: .normal)
                            return i
                        })
                    }
                    callback(cityInfos, nil)
                }
            })
        }
    }
}

extension PaySNCloud {
    /// 生成城市信息
    ///
    /// - Parameter list: [HMServiceAPIBUSCardsCity]
    /// - Returns: [PayCityCardInfo]
    static func generateCityInformation(_ list: [HMServiceAPIBUSCardCity]) -> [PayCityCardInfo] {
        var cardInfos: [PayCityCardInfo] = []
        for city in list {
            guard let cityID = city.api_busCardCityID else { continue }
            guard let payCity = PayCity.cityCode(cityID) else { continue }
            
            var info = PayCityCardInfo(payCity)
            info.cityName = city.api_busCardCityName!
            info.name = city.api_busCardCityCardName!
            info.isParentCity = city.api_busCardCityHasSubCity
            info.serviceScope = city.api_busCardCityServiceScope ?? ""
            info.openTime = city.api_busCardCityOpenTime
            var stock = CardStockState.normal
            if let s = CardStockState(rawValue: city.api_busCardCityXiaomiCardStatus) { stock = s }
            
            if let cardID = city.api_busCardCityCardID { info.number = cardID }
            if let unOpenURL = city.api_busCardCityUnopenedImgUrl { info.image = URL(string: unOpenURL) }
            if let openURL = city.api_busCardCityOpenedImgUrl { info.activeImage = URL(string: openURL) }
            if let orderNum = city.api_busCardCityOrderID { info.orderNum = orderNum }
            
            switch city.api_busCardCityCardStatus {
            case .binding: info.state = .install(stock: stock); break;
            case .exception: info.state = .abnormal(stock: stock); break;
            default: info.state = .normal(stock: stock); break;
            }
            cardInfos.append(info)
        }
        return cardInfos
    }
}

