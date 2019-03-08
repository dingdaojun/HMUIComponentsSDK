//
//  DeviceViewController+Time.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/30.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController: HMBluetoothUpdateTimeServiceResponseProtocol {
    @objc func updateTime() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let dateTextField = alert.addTextField("2017-08-10 10:28:30")
            dateTextField.text = "2017-08-10 10:28:30"
            _ = alert.addButton("使用自定义时间") {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current // 设置时区
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                if let dateString = dateTextField.text {
                    if let date = dateFormatter.date(from: dateString) {
                        self.updateTimeForPeripheral(date: date)
                    }
                }
            }
            
            _ = alert.addButton("使用当前时间") {
                self.updateTimeForPeripheral(date: nil)
            }
            
            _ = alert.showEdit("设置时间", subTitle:"设置自定义时间的，请注意格式")
        }
    }
    
    func updateTimeForPeripheral(date: Date?) {
        baseDevice?.updateTimeDelegate = self
        baseDevice?.updateTimeForPeripheral(date: date)
    }
    
    func updateTimeResult(error: UpdateTimeServiceError?) {
        if let err = error {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "设置时间失败", subTitle: "失败原因: \(err)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "设置时间成功")
            }
        }
    }
}
