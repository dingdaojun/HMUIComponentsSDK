//
//  BLEConnectManager+Observer.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/26.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

extension BLEConnectManager {
    /// 设备断链
    ///
    /// - Parameters:
    ///   - infomation: 设备信息
    ///   - state: 状态
    func sendBleConnectStateToObserver(infomation: HMPeripheralInfomation, state: BLEState) {
        guard let macAddress = infomation.deviceInfomation?.macAddress else { return }
        guard let observers = observersDictionary[macAddress] else { return }
        for observer in observers {
            observer.observer?(state, infomation)
        }
    }
    
    /// 蓝牙状态更改powerOff/powerOn
    ///
    /// - Parameter state: 状态信息
    func bleStateChangedToServer(state: BLEState) {
        for (macAddress, observers) in observersDictionary {
            guard let infomation = DeviceManager.sharedInstance.getPeripheralInfomation(macAddress: macAddress) else { continue }
            for observer in observers {
                observer.observer?(state, infomation)
            }
        }
    }
}
