//
//  ViewController+BandInfo.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/12.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay
import HMBluetoothKit

extension ViewController {
    @objc func readBattery() {
        DispatchQueue.global().async {
            guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { return }
            
            do {
                let battery = try (profile as! GenericProtocol).getBatteryInfomation()
                let batteryInfomation = try BatteryInfomation(battery)
                self.readBatteryInfomationResult(batteryInfo: batteryInfomation, error: nil)
            } catch {}
        }
    }
    
    @objc func getCPLC() {
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async {
                    ViewController.waitAlert = ViewController.waitAlert("cplc", content: "获取cplc中...")
                }
                let startDate = Date()
                ViewController.cplc = try ViewController.pay.se.getCplc()
                let endDate = Date()
                let timeConsuming = endDate.timeIntervalSince(startDate)
                self.cplcAlert(ViewController.cplc!, timeConsuming: timeConsuming)
            } catch {
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    ViewController.failTips(title: "Cplc失败", subTitle: "失败原因: \(error)");
                }
            }
        }
    }
    
    @objc func getDeviceID() {
        guard let deviceID = ViewController.infomation?.deviceInfomation?.deviceID else {
            ViewController.failTips(title: "失败", subTitle: "无DeviceID")
            return
        }
        
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("复制") {
                UIPasteboard.general.string = "cplc:   \(deviceID)"
                ViewController.successTips(title: "成功", subTitle: "复制成功")
            }
            
            _ = alert.showEdit("DeviceID", subTitle:"\(deviceID)")
        }
    }
}
