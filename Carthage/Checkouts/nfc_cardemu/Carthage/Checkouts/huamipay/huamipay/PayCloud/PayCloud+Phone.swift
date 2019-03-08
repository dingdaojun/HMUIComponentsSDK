//
//  PayCloud+Phone.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/3.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


extension PayCloud {
    /// 读取手机号
    ///
    /// - Parameter callback: 回调
    public func readUserPhone(callback: @escaping PayCloudProtocol.ReadUserPhoneCallback) {
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.busCardsBinding_retrieve { (success, msg, config) in
                guard success else {
                    callback(nil, PayError.networkError(msg: msg))
                    return
                }
                
                var telphone = config?.api_busCardsCityConfigurationPone ?? nil
                if telphone == "" { telphone = nil }
                callback(telphone, nil)
            }?.printCURL()
        }
    }
    
    /// 获取验证码
    ///
    /// - Parameters:
    ///   - phoneNum: 手机号
    ///   - callback: 回调
    public func fetchVerficationCode(for phoneNum: String, callback: @escaping PayCloudProtocol.VerficationCodeCallback) {
        guard !phoneNum.isEmpty else { callback(PayError.paramError("获取验证码: 手机号不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.busCardsBinding_verifyCaptcha(withPhone: phoneNum, completionBlock: { (success, code, msg) in
                guard success else {
                    callback(PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                callback(nil)
            })
        }
    }
    
    /// 绑定手机号
    ///
    /// - Parameters:
    ///   - phoneNum: 手机号
    ///   - verfucatuibCode: 验证码
    ///   - callback: 回调
    public func bindPhone(_ phoneNum: String, verfucatuibCode: String, callback: @escaping PayCloudProtocol.BindPhoneCallback) {
        guard !phoneNum.isEmpty else { callback(PayError.paramError("获取验证码: 手机号不能为空")); return; }
        guard !verfucatuibCode.isEmpty else { callback(PayError.paramError("获取验证码: 验证码不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            PayTransmit.shared.nfcService.busCardsBinding_boundPhone(phoneNum, verifyCaptcha: verfucatuibCode, completionBlock: { (success, msg) in
                guard success else {
                    callback(PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                callback(nil)
            })
        }
    }
}
