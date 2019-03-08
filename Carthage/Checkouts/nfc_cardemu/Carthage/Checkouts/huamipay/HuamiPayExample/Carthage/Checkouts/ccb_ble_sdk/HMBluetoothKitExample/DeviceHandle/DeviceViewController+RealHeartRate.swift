//
//  DeviceViewController+RealHeartRate.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/6.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController: HMBluetoothRealHeartRateServiceResponseProtocol {
    func openRealHeartRateResult(error: RealHeartRateServiceError?) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("关闭") {
                self.proBaseDevice?.closeRealHeartRate()
            }
            
            let msg: String = "心率: 0 \n"
            
            self.heartRateAlert = alertView.showWait("实时心率", subTitle: msg, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        }
    }
    
    func closeRealHeartRateResult(error: RealHeartRateServiceError?) {
        if let err = error {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "关闭心率失败", subTitle: "失败原因: \(err)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "关闭心率成功")
            }
        }
    }
    
    func realHeartRateProgress(heartRate: Int) {
        let msg: String = "心率: \(heartRate) \n"
        
        DispatchQueue.main.async {
            self.heartRateAlert?.setSubTitle(msg)
        }
    }
    
    @objc func realHeartRate() {
        proBaseDevice?.realHeartRateDelegate = self
        proBaseDevice?.openRealHeartRate()
    }
}
