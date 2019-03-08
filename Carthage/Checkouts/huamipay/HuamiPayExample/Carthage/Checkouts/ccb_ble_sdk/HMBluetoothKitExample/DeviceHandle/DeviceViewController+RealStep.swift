//
//  DeviceViewController+RealStep.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/5.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController: HMBluetoothRealStepServiceResponseProtocol {
    @objc func realStep() {
        baseDevice?.realStepDelegate = self
        baseDevice?.openRealStep()
    }
    
    func realStepProgress(stepInfomation: RealStepInfomation) {
        var msg: String = ""
        msg.append("步数: \(String(describing: stepInfomation.steps)) \n")
        msg.append("运动步数: \(String(describing: stepInfomation.runSteps)) \n")
        msg.append("走路步数: \(String(describing: stepInfomation.walkSteps)) \n")
        msg.append("卡路里: \(String(describing: stepInfomation.calories)) \n")
        msg.append("距离: \(String(describing: stepInfomation.distance))米 \n")
        
        DispatchQueue.main.async {
            self.realStepAlert?.setSubTitle(msg)
        }
    }
    
    func openRealStepResult(error: RealStepServiceError?) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("关闭") {
                self.nfcDevice?.closeRealStep()
            }
            
            var msg: String = ""
            msg.append("步数: 0 \n")
            msg.append("运动步数: 0 \n")
            msg.append("走路步数: 0 \n")
            msg.append("卡路里: 0 \n")
            msg.append("距离: 0米 \n")
            
            self.realStepAlert = alertView.showWait("实时步数信息", subTitle: msg, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        }
    }
}
