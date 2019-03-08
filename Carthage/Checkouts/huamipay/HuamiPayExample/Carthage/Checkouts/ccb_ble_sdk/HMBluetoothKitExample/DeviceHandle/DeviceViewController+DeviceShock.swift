//
//  DeviceViewController+DeviceShock.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/28.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

extension DeviceViewController {
    @objc func findDevice() {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) else { return }
        let operation = BlockOperation {
            do {
                try (profile as! GenericProtocol).deviceShock()
            } catch {
                DispatchQueue.main.async {
                    DeviceViewController.failTips(title: "查找手环失败", subTitle: "失败原因: \(error)")
                }
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }
}
