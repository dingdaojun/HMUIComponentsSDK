//
//  ViewController+cardOperation.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/12.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay
import HMBluetoothKit

extension ViewController {
    @objc func queryCardListFromDevice() {
        let list = LocalOpenedCitiesViewController()
        self.navigationController?.pushViewController(list, animated: true)
        list.completeCallback = {
            self.updateCity(payCity: ViewController.city)
        }
    }
    
    @objc func cardInfo() {
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async { ViewController.waitAlert = ViewController.waitAlert("卡信息", content: "获取卡信息中...") }
                let startDate = Date()
                let info = try ViewController.pay.se.queryCardInfo(ViewController.city)
                let endDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "yyy-MM-dd hh:mm:ss"
                let startTime = dateFormatter.string(from: info.startDate)
                let endTime = dateFormatter.string(from: info.validity)
                let timeConsuming = endDate.timeIntervalSince(startDate)
                let isActivate = try ViewController.pay.se.isDefaultCard(for: ViewController.city)
                let defaultDes = isActivate  ? "已激活" : "未激活"
                if isActivate {
                    ViewController.defaultCity = ViewController.city
                }
                let infoString = "卡号: \(info.number)\n余额: \(info.balance)\n启动日期: \(startTime)\n有效期日期: \(endTime)\n激活: \(defaultDes)\n是否可用: \(info.isAvailable)"
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                    let alert = SCLAlertView(appearance: appearance)
                    _ = alert.showSuccess("成功(\((String.init(format: "%2.3f", timeConsuming)))s)", subTitle: "\(infoString)")
                }
            } catch {
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
                ViewController.failTips(title: "失败", subTitle: "失败原因: \(error)")
            }
        }
    }
    
    @objc func setDefault() {
        let startDate = Date()
        DispatchQueue.global().async {
            do {
                try ViewController.pay.se.setDefault(true, for: ViewController.city)
                ViewController.defaultCity = ViewController.city
                let endDate = Date()
                let timeConsuming = endDate.timeIntervalSince(startDate)
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    ViewController.successTips(title: "成功(\(String.init(format: "%2.3f", timeConsuming))s)", subTitle: "激活成功")
                }
                
                if let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) {
                    try? (profile as! NFCProtocol).swapAid(ViewController.city.info.aid, for: .bus)
                }
            } catch {
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    ViewController.failTips(title: "激活失败", subTitle: "失败原因: \(error)");
                }
            }
        }
    }
    
    @objc func cancelDefaultCard() {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("去默认卡", content: "去默认卡中...")
        }
        
        do {
            try ViewController.pay.se.setDefault(false, for: ViewController.city)
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
                ViewController.successTips(title: "成功", subTitle: "去默认卡成功")
            }
        } catch {
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
                ViewController.failTips(title: "去默认卡失败", subTitle: "失败原因: \(error)");
            }
        }
    }
    
    @objc func deleteCard() {
        switch ViewController.tsm {
        case .snowball:
            DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("删卡", action: {
                    let alert = ViewController.waitAlert("删卡", content: "删卡中....")
                    let param = SNOperationParam(city: ViewController.city)
                    ViewController.pay.snCloud.deleteCard(param) { (error) in
                        DispatchQueue.main.async { alert.close() }
                        guard error == nil else { ViewController.failTips(title: "删卡失败", subTitle: "失败原因: \(error!)"); return }
                        ViewController.successTips(title: "成功", subTitle: "删卡成功")
                    }
                })
                _ = alert.showNotice("确认", subTitle: "是否确认删卡")
            }
            
            break;
        case .mi:
            DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("删卡", action: {
                    let alert = ViewController.waitAlert("删卡", content: "删卡中....")
                    let param = MIOperationParam(token: "", in: ViewController.city)
                    ViewController.pay.miCloud.deleteCard(param) { (error) in
                        DispatchQueue.main.async { alert.close() }
                        guard error == nil else { ViewController.failTips(title: "删卡失败", subTitle: "失败原因: \(error!)"); return }
                        ViewController.successTips(title: "成功", subTitle: "删卡成功")
                    }
                })
                _ = alert.showNotice("确认", subTitle: "小米删卡前需要告知小米添加删卡任务，才能再调用此功能，确认删卡?")
            }
        }
    }
}
