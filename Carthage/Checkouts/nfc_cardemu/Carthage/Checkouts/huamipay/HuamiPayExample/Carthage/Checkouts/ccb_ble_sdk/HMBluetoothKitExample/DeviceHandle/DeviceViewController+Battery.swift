//
//  DeviceViewController+Battery.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/30.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

extension DeviceViewController {
    @objc func readBattery() {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) else { return }
        let operation = BlockOperation {
            do {
                let data = try (profile as! GenericProtocol).getBatteryInfomation()
                let batteryInfomation = try BatteryInfomation(data)
                self.readBatteryInfomationResult(batteryInfo: batteryInfomation, error: nil)
            } catch {
                self.readBatteryInfomationResult(batteryInfo: nil, error: error)
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }

    func readBatteryInfomationResult(batteryInfo: BatteryInfomation?, error: Error?) {
        if let battery = batteryInfo {
            DispatchQueue.main.async {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current // 设置时区
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let stringDate = dateFormatter.string(from: battery.lastChargeDate!)
                
                _ = SCLAlertView().showInfo("电池信息", subTitle:  "当前电量: \(battery.level)%\n上次充电时间: \(stringDate)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "电池失败", subTitle: "失败原因: \(String(describing: error))")
            }
        }
    }
}
