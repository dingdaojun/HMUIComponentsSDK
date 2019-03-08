//
//  BLEConnectManager+ReConnect.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/26.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation

extension BLEConnectManager {
    public func reconnectAllSavePeripheral() {
        for infomation in DeviceManager.sharedInstance.savePeripheralArray {
            reconnect(peripheralInfomation: infomation)
        }
    }
    
    public func reconnect(peripheralInfomation: HMPeripheralInfomation) {
        // 重连机制: 如果没有授权的，不进行重连
        guard let _ = peripheralInfomation.authKey else { return }
        connect(peripheralInfomation: peripheralInfomation)
    }
}
