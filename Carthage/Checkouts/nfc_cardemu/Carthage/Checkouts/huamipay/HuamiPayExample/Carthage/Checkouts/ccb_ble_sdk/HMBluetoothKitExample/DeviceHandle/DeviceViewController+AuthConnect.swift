//
//  DeviceViewController+AuthConnect.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/4.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func authConnect() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            self.authConnectAlert = alertView.showWait("授权", subTitle: "授权中...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        }
        
        DeviceManager.sharedInstance.authorizeInfomation = peripheralInfomation
        BLEConnectManager.sharedInstance.connect(peripheralInfomation: peripheralInfomation)
    }
}

