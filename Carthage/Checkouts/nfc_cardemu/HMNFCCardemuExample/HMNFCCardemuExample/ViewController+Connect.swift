//
//  ViewController+Connect.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/31.
//  Copyright © 2018年 华米科技. All rights reserved.
//


import Foundation
import HMBluetoothKit
import WalletService
import huamipay


extension ViewController {
    func connect() {
        let infomations = DeviceManager.sharedInstance.savePeripheralArray
        
        if infomations.count > 0 {
            ViewController.infomation = infomations.first
            self.title = ViewController.infomation?.name ?? "无设备名称"
//            stateLabel.text = "连接中...(\(ViewController.infomation!.deviceInfomation!.macAddress!))"
            for info in infomations {
                connect(peripheralInformation: info)
            }
        }
    }
    
    func connect(peripheralInformation: HMPeripheralInfomation) {
        let observer = BLEStateObserver.init(info: peripheralInformation)
        observer.name = String(describing: self)
        observer.observer = { (state, info) in
            switch state {
            case .connected:
                if let macaddress = ViewController.infomation?.deviceInfomation?.macAddress {
                    if info.deviceInfomation?.macAddress == macaddress {
                        self.getCplc()
                          
//                        DispatchQueue.main.async { self.stateLabel.text = "连接成功!(\(macaddress))" }
                    }
                }
                break
            default:
//                if let macaddress = ViewController.infomation?.deviceInfomation?.macAddress {
//                    DispatchQueue.main.async { self.stateLabel.text = "未连接!(\(macaddress))" }
//                }
                break
            }
        }
        
        BLEConnectManager.sharedInstance.addBLEConnectStateObserver(observer)
        BLEConnectManager.sharedInstance.connect(peripheralInfomation: peripheralInformation)
    }
    
    func readBatteryInfomationResult(batteryInfo: BatteryInfomation?, error: Error?) {
        if let battery = batteryInfo {
            DispatchQueue.main.async {
                self.title = "当前电量: \(battery.level)%"
            }
        }
    }
    
    func getCplc() {
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async { ViewController.waitAlert = ViewController.waitAlert("cplc", content: "获取cplc中...") }
                guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { return }
                ViewController.sn = try profile.getSerialNumber()
                let startDate = Date()
                ViewController.cplc = try ViewController.pay.se.getCplc()
                
                let endDate = Date()
                let timeConsuming = endDate.timeIntervalSince(startDate)
                self.cplcAlert(ViewController.cplc!, timeConsuming: timeConsuming)
                ViewController.tsm = .snowball
                if ViewController.infomation?.name == ProfileName.chongqing.rawValue ||
                   ViewController.infomation?.name == ProfileName.miBand3.rawValue  {
                    ViewController.module = HuamipayTSM.projectCode(with: .chongqing)
                    ViewController.tsm = .mi
                } else if ViewController.infomation?.name == ProfileName.beatsL.rawValue {
                    ViewController.module = HuamipayTSM.projectCode(with: .beats)
                } else if ViewController.infomation?.name == ProfileName.beatsH.rawValue {
                    ViewController.module = HuamipayTSM.projectCode(with: .beatsP)
                } else if ViewController.infomation?.name == ProfileName.dth.rawValue {
                    ViewController.module = HuamipayTSM.projectCode(with: .dongtinghu)
                }
                
                // 跳转 NFC 门禁
            } catch {
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
            }
        }
    }
    
    func cplcAlert(_ cplc: String, timeConsuming: TimeInterval) {
        DispatchQueue.main.async {
            ViewController.waitAlert?.close()
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("复制") {
                UIPasteboard.general.string = "cplc:   \(cplc)"
                ViewController.successTips(title: "成功", subTitle: "复制成功")
            }
            
            print("cplc: \(cplc)")
            _ = alert.showEdit("CPLC(\((String.init(format: "%2.3f", timeConsuming)))s)", subTitle:"\(cplc)")
//            self.speedTextView.text.append("总时间: \((String.init(format: "%2.3f", self.totalTime)))s")
            self.totalTime = 0.0
        }
    }
}
