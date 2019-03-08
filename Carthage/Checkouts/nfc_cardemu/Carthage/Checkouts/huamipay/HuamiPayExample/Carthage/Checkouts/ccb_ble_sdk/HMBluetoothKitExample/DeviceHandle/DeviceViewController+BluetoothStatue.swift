//
//  DeviceViewController+BluetoothStatue.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/4.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController: HMBluetoothStatueServiceResponseProtocol {
    func bluetoothStatueChanged(bleStatue: HMBluetoothStatue) {
        DispatchQueue.main.async {
            DeviceViewController.failTips(title: "提醒", subTitle: "蓝牙状态变化: \(bleStatue)")
            self.peripheral.isConnected = false
            DeviceManager.sharedInstance.updateDevice(peripheral: self.peripheral)
            self.naviagtionTitle()
        }
    }
}
