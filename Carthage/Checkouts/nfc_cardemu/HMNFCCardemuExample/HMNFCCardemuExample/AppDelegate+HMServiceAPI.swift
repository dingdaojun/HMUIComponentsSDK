//  AppDelegate+HMServiceAPI.swift
//  Created on 2018/1/5
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import Foundation
import HMService


extension AppDelegate: HMServiceDelegate {
    func service(_ service: HMServiceAPIProtocol!, didDetectError error: Error!, inAPI apiName: String!, localizedMessage message: AutoreleasingUnsafeMutablePointer<NSString?>!) {
        let apiError = HMServiceAPIError(rawValue: (error! as NSError).code)!
        message.pointee = apiErrorDescription(with: apiError)
    }
    
    func userID(forService service: HMServiceAPIProtocol!) -> String! {
        return ViewController.userid
    }
    
    func absoluteURL(forService service: HMServiceAPIProtocol!, referenceURL: String!) -> String! {
        let tmp = ViewController.serviceEvn.rawValue
        let absoluteURL = tmp + referenceURL
        let requesteUUID = URLRequestLogUUID()
        let timestamp = (Date() as NSDate).timeIntervalSince1970
        if absoluteURL.contains("?") {
            return String(format:"%@&r=%@&t=%.0f",absoluteURL, requesteUUID, timestamp * 1000)
        } else {
            return String(format:"%@?r=%@&t=%.0f",absoluteURL, requesteUUID, timestamp
                
                * 1000)
        }
    }
    
    func uniformHeaderFieldValues(forService service: HMServiceAPIProtocol!) throws -> [String : String] {
        let value = try! uniformHeaderFieldValues(forService: service as! HMServiceAPI, auth: true)
        return value
    }
    
    func uniformHeaderFieldValues(forService service: HMServiceAPIProtocol!, auth: Bool) throws -> [String : String] {
        return ["appname": "com.xiaomi.hm.health",
                "channel": "appstore",
                "cv": "8_1.5.8",
                "v": "1.0",
                "appplatform": "ios_phone",
                "lang": "zh_CN",
                "country": "CN",
                "timezone": "Asia/Shanghai",
                "apptoken": ViewController.token,
                "x-snbps-cplc": ViewController.cplc!,
                "x-snbps-module": ViewController.module,
                "x-snbps-imei": ViewController.sn!.uppercased(),
                "x-snbps-rom-version" : "test",
                "x-snbps-os-version" : "test",
                "x-snbps-userid": "40777496",
                "x-snbps-token": "V2_G4-yw-rZCIMh3f-sjDRkRAt9xkGzOu48ovq_jBMYcPHpd14_B9TLY0OMI5ecHlz0S5CqptC8tn2WzOvloZIHdrebUmJwdmPz8nGUa73axQ7dDz3Aa3oCUNGwCAGj2DLg4f_yHONZxAwbA78udsqqmA"]
    }
    
    func uniformParameters(forService service: HMServiceAPIProtocol!) throws -> [String : Any] {
        return ["":""]
    }
    
    func service(_ service: HMServiceAPI!, didDetectError error: Error!, inAPI apiName: String!, localizedMessage message: AutoreleasingUnsafeMutablePointer<NSString?>!) {
    }
    
    func uniformWalletHeaderFieldValues() -> [String : String]! {
        return ["x-snbps-cplc": ViewController.cplc!.uppercased(),
                "x-snbps-module": ViewController.module,
            "x-snbps-imei": ViewController.sn!.uppercased(),
            "x-snbps-rom-version" : "test",
            "x-snbps-os-version" : "test",
            "x-snbps-userid": "40777496",
            "x-snbps-token": "V2_G4-yw-rZCIMh3f-sjDRkRAt9xkGzOu48ovq_jBMYcPHpd14_B9TLY0OMI5ecHlz0S5CqptC8tn2WzOvloZIHdrebUmJwdmPz8nGUa73axQ7dDz3Aa3oCUNGwCAGj2DLg4f_yHONZxAwbA78udsqqmA",
            "clientId": "2882303761517154077"]
    }
    
    private func URLRequestLogUUID() -> String {
        var uuid = UserDefaults.standard.object(forKey: "MiFitAppLifeUUIDKey")
        if uuid != nil {
            return uuid as! String
        }
        
        uuid = NSUUID().uuidString
        if uuid != nil {
            UserDefaults.standard.set(uuid, forKey: "MiFitAppLifeUUIDKey")
            UserDefaults.standard.synchronize()
        }
        return uuid as! String
    }
    
    private func apiErrorDescription(with error: HMServiceAPIError) -> NSString {
        switch error {
        case .none:                 return ""
        case .network:              return "network connection failed"
        case .timeout:              return "service response timed out"
        case .responseDataFormat:   return "response format error"
        case .serverInternal:       return "server internal error"
        case .parameters:           return "parameter error"
        case .invalidToken:         return "invalidate token"
        case .mutexLogin:           return "mutex login error"
        default:                    return "unknown error"
        }
    }
}
