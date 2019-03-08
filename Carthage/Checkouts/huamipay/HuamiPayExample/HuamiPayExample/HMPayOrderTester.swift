//  HMPayOrderTester.swift
//  Created on 2018/3/19
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit
import HMPayKit

class HMPayOrderTester: NSObject, HMPayOrder {
    var wx_PayAppId: String! = "wxd930ea5d5a258f4f"

    var wx_partnerId: String! = "10000100"

    var wx_prepayId: String! = "1101000000140415649af9fc314aa427"

    var wx_nonceStr: String! = "a462b76e7436e98e0ed6e13c64b4fd1c"

    var wx_timeStamp: String! = "1397527777"

    var wx_package: String! = "Sign=WXPay"

    var wx_sign: String! = "582282D72DD2B03AD892830965F428CB16E7A256"

    var ali_urlScheme: String! = "HuamiPayExample"

    var ali_signChargeStr: String! = ""
}

extension HMPayOrderTester {
    static func wxTester(_ sign: String) -> HMPayOrderTester? {
        var dictonary:NSDictionary?
        if let data = sign.data(using: String.Encoding.utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                if let myDictionary = dictonary {
                    let order = HMPayOrderTester()
                    // 这个appid应该是每次返回都是固定的，需要将此appdid在工程中配置url schemes，
                    order.wx_PayAppId = myDictionary["appid"] as! String
                    order.wx_nonceStr = myDictionary["noncestr"] as! String//
                    order.wx_package = myDictionary["package"] as! String//
                    order.wx_partnerId = myDictionary["partnerid"] as! String
                    order.wx_prepayId = myDictionary["prepayid"] as! String//
                    order.wx_sign = myDictionary["sign"] as! String//
                    order.wx_timeStamp = myDictionary["timestamp"] as! String
                    return order
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        return nil
    }
}
