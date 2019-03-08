//
//  DeviceViewController+ECFService.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/8.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import UIKit


extension DeviceViewController: HMBluetoothECFServiceResponseProtocol {
    @objc func ecfSetting() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonHeight: 40,
                showCloseButton: true,
                shouldAutoDismiss: false)
            let alert = SCLAlertView(appearance: appearance)

            _ = alert.addButton("蓝牙广播") {
                self.alertView(for: .advertisement, btnTitle: "开启", value: "1", otherBtnTitle: "关闭", otherValue: "0", title: "蓝牙广播", subTitle: "设置开启或者关闭")
            }
            _ = alert.addButton("时间制度") {
                self.alertView(for: .timeFormat, btnTitle: "12小时制", value: "0", otherBtnTitle: "24小时制", otherValue: "1", title: "时间制度", subTitle: "设置为12/24小时制")
            }
            _ = alert.addButton("里程单位") {
                self.alertView(for: .mileAgeUnit, btnTitle: "公里", value: "1", otherBtnTitle: "英里", otherValue: "0", title: "里程单位", subTitle: "设置为公里或者英里")
            }
            _ = alert.addButton("抬腕亮屏") {
                self.alertView(for: .wristBright, btnTitle: "开启", value: "1", otherBtnTitle: "关闭", otherValue: "0", title: "抬腕亮屏", subTitle: "设置开启或者关闭")
            }
            _ = alert.addButton("时间样式") {
                self.alertView(for: .timeDisplay, btnTitle: "时间", value: "0", otherBtnTitle: "时间+日期", otherValue: "1", title: "时间样式", subTitle: "设置只显示时间或者显示时间和日期")
            }
            _ = alert.addButton("转腕切屏") {
                self.alertView(for: .wristFlip, btnTitle: "开启", value: "1", otherBtnTitle: "关闭", otherValue: "0", title: "转腕切屏", subTitle: "设置开启或者关闭")
            }
            _ = alert.addButton("目标步数") {
                self.goalSetting()
            }
            _ = alert.addButton("显示选项") {
                self.dispayItem()
            }
            _ = alert.showEdit("ECF设置", subTitle:"")
        }
    }
    
    private func alertView(for type: ECFType, btnTitle: String, value: String, otherBtnTitle: String, otherValue: String, title: String, subTitle: String) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton(btnTitle) {
                self.setting(type: type, text: value)
            }
            _ = alert.addButton(otherBtnTitle) {
                self.setting(type: type, text: otherValue)
            }
            _ = alert.showEdit(title, subTitle: subTitle)
        }
    }
    
    private func goalSetting() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let goalTextField = alert.addTextField("目标步数")
            goalTextField.keyboardType = .phonePad
            _ = alert.addButton("设置目标值") {
                if let v = goalTextField.text {
                    if let intValue = Int(v) {
                        self.setting(type: .goalReminder, text: "\(intValue)")
                    }
                }
            }
            _ = alert.showEdit("设置目标", subTitle: "设置目标步数")
        }
    }
    
    private func dispayItem() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                kButtonHeight: 40,
                showCloseButton: true,
                shouldAutoDismiss: false)
            let alert = SCLAlertView(appearance: appearance)
            
            // Creat the subview
            let width = CGFloat(appearance.kWindowWidth) - CGFloat(12 * 2.0)
            let subview = UIView()
            // Add button
            let distance: CGFloat = 5.0
            let buttonWidth = width / 2.0 - 10.0
            let leftXPos: CGFloat = 0.0
            let rightXPos: CGFloat = width / 2.0 + 10.0
            let timeButton = self.createButton(title: "时间", xPos: leftXPos, yPos: distance, width: buttonWidth)
            timeButton.setTitleColor(.black, for: .normal)
            timeButton.isEnabled = false
            timeButton.isSelected = true
            let stepButton = self.createButton(title: "步数", xPos: rightXPos, yPos: distance, width: buttonWidth)
            let distanceButton = self.createButton(title: "距离", xPos: leftXPos, yPos: timeButton.frame.maxY + distance, width: buttonWidth)
            let consumeButton = self.createButton(title: "卡路里", xPos: rightXPos, yPos: distanceButton.frame.origin.y, width: buttonWidth)
            let heartRateButton = self.createButton(title: "心率", xPos: leftXPos, yPos: distanceButton.frame.maxY + distance, width: buttonWidth)
            let batteryLevelButton = self.createButton(title: "电池", xPos: rightXPos, yPos: heartRateButton.frame.origin.y, width: buttonWidth)
            subview.addSubview(timeButton)
            subview.addSubview(stepButton)
            subview.addSubview(distanceButton)
            subview.addSubview(consumeButton)
            subview.addSubview(heartRateButton)
            subview.addSubview(batteryLevelButton)
            subview.frame = CGRect(x: 0, y: 0, width: width, height: batteryLevelButton.frame.maxY)
            alert.customSubview = subview
            
            alert.addButton("显示设置", action: {
                var displayOptions = 0
                
                if stepButton.isSelected {
                    displayOptions = displayOptions ^ 1
                }
                
                if distanceButton.isSelected {
                    displayOptions = displayOptions ^ 2
                }
                
                if consumeButton.isSelected {
                    displayOptions = displayOptions ^ 4
                }
                
                if heartRateButton.isSelected {
                    displayOptions = displayOptions ^ 8
                }
                
                if batteryLevelButton.isSelected {
                    displayOptions = displayOptions ^ 16
                }
                
                self.setting(type: .displayItem, text: "\(displayOptions)")
            })
            alert.addButton("全部显示", action: {
                
            })
            _ = alert.showEdit("设置目标", subTitle: "设置目标步数")
        }
    }
    
    @objc public func dispayItemDone(button: UIButton) {
        DispatchQueue.main.async {
            button.isSelected = !button.isSelected
        }
    }
    
    func setting(type: ECFType, text: String?) {
        var value: Int = 1
        
        if let v = text {
            if let intValue = Int(v) {
                value = intValue
            }
        }
        
        if self.nfcDevice != nil {
            self.nfcDevice?.ecfDelegate = self
            self.nfcDevice?.ecfSetting(forECFType: type, withValue: value)
        } else if self.proBaseDevice != nil {
            self.proBaseDevice?.ecfDelegate = self
            self.proBaseDevice?.ecfSetting(forECFType: type, withValue: value)
        }
    }
    
    func ecfSettingResult(error: ECFServiceError?) {
        if let err = error {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "ECF设置失败", subTitle: "失败原因: \(err)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "ECF设置成功")
            }
        }
    }
    
    private func createButton(title: String, xPos: CGFloat, yPos: CGFloat, width: CGFloat) -> UIButton {
        // Add button
        let btn = SCLButton(frame: CGRect(x: xPos, y: yPos, width: width, height: 30.0))
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColorFromRGB(0xA429FF)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(self.dispayItemDone(button:)), for: .touchUpInside)
        btn.setTitleColor(.black, for: .selected)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }
}
