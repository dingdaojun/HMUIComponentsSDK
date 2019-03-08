//
//  DeviceViewController+Sensor.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/19.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func sensorHandle() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: true,
                shouldAutoDismiss: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            var item = SensorItem()
            
            let hzTextField = alert.addTextField("HZ")
            hzTextField.text = "25"
            hzTextField.keyboardType = .phonePad
            
            _ = alert.addButton("Sensor", action: {
                item.sensorType = .gSensor
                self.openSensor(item: item, hz: hzTextField.text)
            })
            
            _ = alert.addButton("PPG", action: {
                item.sensorType = .ppg
                self.openSensor(item: item, hz: hzTextField.text)
            })
            
            _ = alert.addButton("ECG", action: {
                item.sensorType = .ecg
                self.openSensor(item: item, hz: hzTextField.text)
            })
            
            _ = alert.addButton("Time", action: {
                item.sensorType = .time
                self.openSensor(item: item, hz: hzTextField.text)
            })
            
            _ = alert.showInfo("传感器开启", subTitle:"请选择类型\n(默认为25HZ)")
        }
    }
    
    private func openSensor(item: SensorItem, hz: String?) {
        var item = item
        DispatchQueue.main.async {
            if let hzString = hz {
                if let hzInt = Int(hzString) {
                    item.hz = hzInt
                }
            }
            
            self.baseDevice?.sensorDelegate = self
            self.baseDevice?.openSensor(item: item)
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("关闭", action: {
                self.baseDevice?.sensorDelegate = self
                self.baseDevice?.closeSensor()
            })
            
            var title: String = ""
            switch item.sensorType {
            case .gSensor:
                title = "实时Sensor数据"
                break
            case .ppg:
                title = "实时PPG数据"
                break
            case .ecg:
                title = "实时ECG数据"
                break
            case .time:
                title = "实时Time数据"
                break
            }
            
            self.sensorAlert = alert.showWait(title, subTitle: "等待传输传感器数据\n\n\n")
        }
    }
}

extension DeviceViewController: HMBluetoothSensorServiceResponseProtocol {
    func openSensorResult(error: SensorServiceError?) {
        DispatchQueue.main.async {
            if let err = error {
                DispatchQueue.main.async {
                    self.sensorAlert?.setSubTitle("失败原因: \(err)")
                }
            }
        }
    }
    
    func closeSensorResult(error: SensorServiceError?) {
        DispatchQueue.main.async {
            if let err = error {
                DispatchQueue.main.async {
                    DeviceViewController.failTips(title: "关闭传感器失败", subTitle: "失败原因: \(err)")
                    print("关闭传感器失败: \(err)")
                }
            } else {
                DispatchQueue.main.async {
                    DeviceViewController.successTips(title: "成功", subTitle: "关闭传感器成功")
                }
            }
        }
    }
    
    func sensortRealResultForECGType(sample: Int) {
        DispatchQueue.main.async {
            self.sensorAlert?.setSubTitle("实时数据: \(sample)")
        }
    }
    
    func sensortRealResultForPPGType(sample: Int) {
        DispatchQueue.main.async {
            self.sensorAlert?.setSubTitle("实时数据: \(sample)")
        }
    }
    
    func sensorRealResultForSensorType(sensor: (x: Int, y: Int, z: Int)) {
        DispatchQueue.main.async {
            self.sensorAlert?.setSubTitle("x: \(sensor.x)\ny:\(sensor.y)\nz: \(sensor.z)")
        }
    }
    
    func sensortRealResultForTimeType(startTime: Int, sensorType: SensorServiceType) {
        DispatchQueue.main.async {
            self.sensorAlert?.setSubTitle("startTime: \(startTime)")
        }
    }
}

