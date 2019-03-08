//
//  DeviceViewController+UserInfomation.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/15.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func readUserInfomation() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: true,
                shouldAutoDismiss: false
                )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("读取用户信息") {
                self.baseDevice?.userInfomationDelegate = self
                self.baseDevice?.readUserInfomation()
            }
            
            _ = alert.addButton("设置用户信息", action: {
                self.settUserInfomation()
            })
            
            let _ = alert.showInfo("用户信息", subTitle:"设置/读取设备中的用户信息")
        }
    }
    
    private func settUserInfomation() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: true
            )
            
            let alert = SCLAlertView(appearance: appearance)
            let userIDTextField = alert.addTextField("userID")
            let birthdayTextField = alert.addTextField("出生日期")
            let genderTextField = alert.addTextField("性别")
            let weightTextField = alert.addTextField("体重")
            let heightTextField = alert.addTextField("身高")
            userIDTextField.keyboardType = .phonePad
            genderTextField.keyboardType = .phonePad
            weightTextField.keyboardType = .phonePad
            heightTextField.keyboardType = .phonePad
            userIDTextField.text = "190420175"
            genderTextField.text = "1"
            weightTextField.text = "180"
            heightTextField.text = "180"
            birthdayTextField.text = "1988-11-11"
            _ = alert.addButton("设置用户信息") {
                var userInfomation = BluetoothUserInfomation()
                
                if let userID = userIDTextField.text {
                    if let userIDInt = Int(userID) {
                        userInfomation.userID = userIDInt
                    }
                }
                
                if let gender = genderTextField.text {
                    if let genderInt = Int(gender) {
                        userInfomation.gender = genderInt
                    }
                }

                if let weight = weightTextField.text {
                    if let weightInt = Int(weight) {
                        userInfomation.weight = weightInt
                    }
                }

                if let height = heightTextField.text {
                    if let heightInt = Int(height) {
                        userInfomation.height = heightInt
                    }
                }

                if let dateString = birthdayTextField.text {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.current // 设置时区
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    if let date = dateFormatter.date(from: dateString) {
                        userInfomation.birthdayDate = date
                    }
                }
                
                self.baseDevice?.userInfomationDelegate = self
                self.baseDevice?.settingUserInfomation(userInfomation: userInfomation)
            }

            let _ = alert.showEdit("用户信息", subTitle:"设置/读取设备中的用户信息")
        }
    }
}

extension DeviceViewController: HMBluetoothUserInfomationServiceResponseProtocol {
    func settingUserInfomationResult(error: BluetoothUserInfomationServiceError?) {
        DispatchQueue.main.async {
            guard error == nil else {
                DeviceViewController.failTips(title: "更新用户信息失败", subTitle: "失败原因: \(String(describing: error))")
                return
            }
            
            DeviceViewController.successTips(title: "成功", subTitle: "更新用户信息成功")
        }
    }
    
    func readUserInfomation(userInfomation: BluetoothUserInfomation?, error: BluetoothUserInfomationServiceError?) {
        DispatchQueue.main.async {
            guard error == nil else {
                DeviceViewController.failTips(title: "用户信息失败", subTitle: "失败原因: \(String(describing: error))")
                return
            }
            
            var msg: String = ""
            
            if let userID = userInfomation?.userID {
                msg += "userID: \(userID)\n"
            }
            
            if let date = userInfomation?.birthdayDate {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current // 设置时区
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let stringDate = dateFormatter.string(from: date)
                msg += "birthdayDate: \(stringDate)\n"
            }
            
            if let weight = userInfomation?.weight {
                msg += "weight: \(weight)\n"
            }
            
            if let height = userInfomation?.height {
                msg += "height: \(height)\n"
            }
            
            if let gender = userInfomation?.gender {
                msg += "gender: \(gender)\n"
            }

            _ = SCLAlertView().showInfo("用户信息", subTitle: msg)
        }
    }
}
