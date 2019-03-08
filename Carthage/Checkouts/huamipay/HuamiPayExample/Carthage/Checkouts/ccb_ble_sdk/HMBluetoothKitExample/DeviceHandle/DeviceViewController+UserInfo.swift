//
//  File.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/3/15.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

extension DeviceViewController {
    @objc func wearLocationForHand() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("左手") {
                self.wearLocation(true, type: .hand)
            }
            
            _ = alert.addButton("右手", action: {
                self.wearLocation(false, type: .hand)
            })
            
            _ = alert.showEdit("左右手设置", subTitle:"设置手环的左右手")
        }
    }
    
    func wearLocation(_ isLeft: Bool, type: WearLocType) {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) else { return }
        
        let operation = BlockOperation {
            do {
                try (profile as! UserInfoProtocol).wearLocation(type, isLeft: true)
                print("right")
                DispatchQueue.main.async {
                    DeviceViewController.successTips(title: "左右手设置成功", subTitle: "左右手设置成功")
                }
            } catch {
                DispatchQueue.main.async {
                    DeviceViewController.failTips(title: "左右手设置失败", subTitle: "失败原因: \(error)")
                }
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }
}
