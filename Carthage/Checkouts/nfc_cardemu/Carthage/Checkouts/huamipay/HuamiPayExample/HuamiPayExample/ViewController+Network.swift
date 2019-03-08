//
//  ViewController+Network.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/12.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay
import WalletService


extension ViewController {
    @objc func readOpenedCardListFromNetwork() {
        let openedCities = OpenedCitiesViewController()
        openedCities.completeCallback = {
            self.updateCity(payCity: ViewController.city)
        }
        self.navigationController?.pushViewController(openedCities, animated: true)
    }
    
    @objc func readMobile() {
        DispatchQueue.main.async { ViewController.waitAlert = ViewController.waitAlert("手机号", content: "查询手机号中...") }
        
        ViewController.pay.hmCloud.readUserPhone { (mobile, error) in
            DispatchQueue.main.async { ViewController.waitAlert?.close() }
            
            if let err = error {
                ViewController.failTips(title: "失败", subTitle: "原因: \(err)")
            } else if let phone = mobile {
                ViewController.successTips(title: "成功", subTitle: "\(phone)")
            } else {
                ViewController.failTips(title: "失败", subTitle: "无手机号")
            }
        }
    }
    
    @objc func supportCityList() {
        let supportCities = SupportCitiesViewController()
        supportCities.completeCallback = {
            self.updateCity(payCity: ViewController.city)
        }
        self.navigationController?.pushViewController(supportCities, animated: true)
    }
}
