//
//  PayMICloud+CityList.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import CoreLocation

extension PayMICloud {
    /// 推荐城市列表
    ///
    /// - Parameters:
    ///   - location: 定位
    ///   - callback: RecommandCityListCallback
    public func queryRecommondCardInfoList(with location: CLLocationCoordinate2D, callback: @escaping HuamipayMICloudProtocol.RecommandCityListCallback) {
        fatalError()
    }

    /// 支持城市列表
    ///
    /// - Parameters:
    ///   - deviceID: deviceID
    ///   - callback: SupportCityListCallback
    public func supportCityList(with deviceID: String, callback: @escaping HuamipayMICloudProtocol.SupportCityListCallback) {
        PayTransmit.shared.payQueue.async {
            let network = PayTransmit.shared.nfcService.busCard_city(withDeviceID: deviceID, completionBlock: { (success, msg, cities) in
                PayTransmit.shared.payQueue.async {
                    guard success else { callback([], PayError.networkError(msg: msg ?? "")); return; }
                    guard let p = cities else { callback([], nil); return; }
                    callback(PaySNCloud.generateCityInformation(p), nil)
                }
            })
            if self.printCurl { network?.printCURL() }
        }
    }
    
    /// 已开通城市列表
    ///
    /// - Parameters:
    ///   - deivceID: deviceID
    ///   - callback: InstallCardListCallback
    public func openedCityList(with deivceID: String, callback: @escaping HuamipayMICloudProtocol.OpenedCityListCallback) {
        PayTransmit.shared.payQueue.async {
            let network = PayTransmit.shared.nfcService.busCardsBinding_openedCities(withDeviceID: deivceID, completionBlock: { (success, msg, cities) in
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
            if self.printCurl { network?.printCURL() }
        }
    }
}
