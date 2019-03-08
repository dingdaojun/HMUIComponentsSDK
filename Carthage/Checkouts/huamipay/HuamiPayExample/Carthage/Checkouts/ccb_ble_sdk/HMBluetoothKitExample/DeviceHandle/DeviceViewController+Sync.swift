//
//  DeviceViewController+Sync.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/20.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func syncPeripheral() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            let dateTextField = alert.addTextField("2017-08-10 10:28:30")
            dateTextField.text = "2017-08-10 10:28:30"
            
            _ = alert.addButton("同步活动数据", action: {
                self.sync(type: .bandData, time: dateTextField.text)
            })
            
            _ = alert.addButton("同步心率数据", action: {
                self.sync(type: .heartRate, time: dateTextField.text)
            })
            
            if self.ecgDevice != nil {
                _ = alert.addButton("同步ECG数据", action: {
                    self.sync(type: .ecg, time: dateTextField.text)
                })
            }
            
            _ = alert.addButton("同步Temp数据", action: {
                self.sync(type: .temperature, time: dateTextField.text)
            })
            
            _ = alert.addButton("同步Sport数据", action: {
                self.sync(type: .sport, time: dateTextField.text)
            })
            
            _ = alert.addButton("同步GPS Log数据", action: {
                self.sync(type: .gpsLog, time: dateTextField.text)
            })
            
            _ = alert.addButton("关闭", action: {
                DispatchQueue.main.async {
                    self.syncAlert?.close()
                }
            })
            
            self.syncAlert = alert.showInfo("同步", subTitle: "请输入从哪个时间同步(注意格式), 并选择同步类型")
        }
    }
    
    private func sync(type: SyncType, time: String?) {
        if let timeString = time {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current // 设置时区
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatter.date(from: timeString) {
                self.baseDevice?.startSync(type: type, date: date, timeZone: TimeZone.current.bleOffset())
            } else {
                DispatchQueue.main.async {
                    DeviceViewController.failTips(title: "失败", subTitle: "时间格式不正确")
                }
            }
        }
    }
}

extension DeviceViewController: HMBluetoothSyncServiceResponseProtocol {
    func syncProgress(progress: Int) {
        DispatchQueue.main.async {
            self.syncLoadingAlert?.setSubTitle("进度: \(progress)")
        }
    }
    
    func syncComplete(syncInfomation: SyncResultInfomation) {
        DispatchQueue.main.async {
            self.syncLoadingAlert?.setSubTitle("同步成功!")
            
            DispatchQueue.main.asyncAfter(deadline: 2, execute: {
                self.syncLoadingAlert?.close()
            })
        }
    }
    
    func startSyncResult(error: HMBluetoothSyncServiceError?) {
        guard error == nil else {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "同步失败", subTitle: "失败原因:  \(error!)")
            }
            return
        }
        
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("关闭", action: {
                self.baseDevice?.stopSync()
                
                DispatchQueue.main.async {
                    self.syncLoadingAlert?.close()
                }
            })
            
            self.syncLoadingAlert = alert.showWait("同步", subTitle: "数据同步中...")
        }
    }
    
    func stopSyncResult(error: HMBluetoothSyncServiceError?) {
        guard error == nil else {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "停止同步失败", subTitle: "失败原因:  \(error!)")
            }
            return
        }
        
        DispatchQueue.main.async {
            DeviceViewController.failTips(title: "成功", subTitle: "停止同步成功")
        }
    }
}
