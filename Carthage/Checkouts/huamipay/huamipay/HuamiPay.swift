//
//  HuamiPay.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/2/5.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import HMService


public class HuamiPay: HuamipayProtocol {
    /// huami云服务: 上传交易记录、获取交易记录
    public var hmCloud: PayCloudProtocol = PayCloud()
    /// 小米TSM云服务
    public var miCloud: HuamipayMICloudProtocol = PayMICloud()
    /// 雪球TSM云服务
    public var snCloud: HuamipaySNCloudProtocol = PaySNCloud()
    /// 小米门禁系统
    public var miACCloud: HuamipayMIAccessControlProtocol = MIAccessControlCloud()
    /// SE
    public var se: PaySEProtocol = PaySE()
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - delegate: 蓝牙代理
    ///   - service: 网络服务，默认是defaultService
    ///   - queue: 线程，默认为global；目前只是网络库切换线程，SE的现在放到外面
    public init(with delegate: NFCBLEProtocol, service: HMServiceAPI = HMServiceAPI.defaultService(), queue: DispatchQueue = DispatchQueue.global()) {
        PayTransmit.shared.bleDelegate = delegate
        PayTransmit.shared.payQueue = queue
        PayTransmit.shared.nfcService = service
    }
}

