//
//  ConnectedListViewController+MultiConnectionTest.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/28.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit
import CoreMotion

extension ConnectedListViewController {
    func syncAll() {
        let peripherals = DeviceManager.sharedInstance.savePeripheralArray
        for peripheral in peripherals {
            if peripheral.name == ProfileName.arc.rawValue {
                sensor(infomation: peripheral)
            }
        }
    }
    
    func sensor(infomation: HMPeripheralInfomation) {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: infomation) else { return }
        var totalData = Data()
        let operation = BlockOperation {
            do {
                var item = SensorItem.init()
                if infomation.name == ProfileName.mars.rawValue {
                    item.sensorType = [.gSensor, .gyro]
                } else {
                    item.sensorType = [.gSensor, .ppg]
                }
                
                try (profile as! RealtimeSensorDataProtocol).registerRealtimeSensorDataNotification(item: item, calback: { [weak self] (data, error) in
                    totalData.append(data)
                    self?.analysisSensorData(data, infomation: infomation)
                })
            } catch LEPeripheralError.invailedResponse(let data) {
                let error = NSError(domain: "invailedResponse: \(data.toHexString())", code: 0, userInfo: nil)
                print("sensor error: \(error)")
            } catch {
                print("sensor error: \(error)")
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
        let mac = infomation.deviceInfomation!.macAddress!
        let repeatingTimer = RepeatingTimer()
        repeatingTimer.repeating = DispatchTimeInterval.seconds(60)
        repeatingTimer.eventHandler = {
            print("\(mac) totalData: \(totalData.count)")
        }
        repeatingTimer.resume()
        timers.append(repeatingTimer)
    }
    
    func analysisSensorData(_ data: Data, infomation: HMPeripheralInfomation) {
        do {
            var sensorInfomation = RealSensorInfomation()
            try sensorInfomation.analysisBleData(data)
        } catch {
            print("sensor analysis error: \(error)")
        }
    }
    
    func sync(infomation: HMPeripheralInfomation) {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: infomation) else { return }
        let operation = BlockOperation {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current // 设置时区
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: "2018-02-20 20:18:19") {
                    print("start sync: \(String(describing: infomation.deviceInfomation!.macAddress!)): \(Date())")
                    let data = try (profile as! ActivityDataProtocol).getTotalActivityData(from: date)
                    print("\(String(describing: infomation.deviceInfomation!.macAddress!)): \(Date())")
                    print("sync: \(data)")
                }
            } catch {
                print("sync error: \(error)")
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }
}
