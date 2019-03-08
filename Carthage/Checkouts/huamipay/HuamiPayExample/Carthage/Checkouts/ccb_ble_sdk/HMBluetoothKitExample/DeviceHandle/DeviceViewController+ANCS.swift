//
//  DeviceViewController+ANCS.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/1.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func ancsSetNotify() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let delayTextField = alert.addTextField("延迟时长")
            delayTextField.keyboardType = .phonePad 
            
            _ = alert.addButton("手机") {
                self.setNotifyForANCS(delay: delayTextField.text, type: .phoneCall)
            }
            
            _ = alert.addButton("短信", action: {
                self.setNotifyForANCS(delay: delayTextField.text, type: .sms)
            })
            
            _ = alert.addButton("微信", action: {
                self.setNotifyForANCS(delay: delayTextField.text, type: .wechat)
            })
            
            _ = alert.showEdit("ANCS服务", subTitle:"延迟长度范围为3-10s, 写0则为关闭提醒")
        }
    }
    
    func setNotifyForANCS(delay: String?, type: ANCSType) {
        self.nfcDevice?.ancsDelegate = self
        
        if let delaySec = delay {
            self.baseDevice?.ancsSettingNotify(delaySec: Int(delaySec)!, forType: type)
        } else {
            self.baseDevice?.ancsSettingNotify(delaySec: 0, forType: type)
        }
    }
}

extension DeviceViewController: HMBluetoothANCSServiceResponseProtocol {
    func ancsSettingNotifyResult(error: ANCSServiceError?) {
        DispatchQueue.main.async {
            if let err = error {
                DeviceViewController.failTips(title: "设置提醒失败", subTitle: "失败原因: \(err)")
            } else {
                DeviceViewController.successTips(title: "成功", subTitle: "设置提醒成功")
            }
        }
    }
    
    func ancsNotifyTestResult(error: ANCSServiceError?) {
        DispatchQueue.main.async {
            if let err = error {
                DeviceViewController.failTips(title: "提醒失败", subTitle: "失败原因: \(err)")
            } else {
                DeviceViewController.successTips(title: "成功", subTitle: "提醒成功")
            }
        }
    }
}
