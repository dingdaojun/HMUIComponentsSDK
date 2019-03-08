//
//  HMBluetoothCoreManager+Delegate.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/10/20.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

extension LECentralManager: CBCentralManagerDelegate {
    // 蓝牙状态改变回调
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unsupported:
            self.bleutoothStatus = .notSupport
        case .unauthorized:
            self.bleutoothStatus = .unauthorized
        case .poweredOff:
            self.bleutoothStatus = .powerOff
        case .resetting:
            self.bleutoothStatus = .reseting
        case .poweredOn:
            self.bleutoothStatus = .ready
        default:
            return
        }
        
        self.statusUpdateCallBack?(self.bleutoothStatus)
    }

    // 发现设备回调
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let scanResponse = LEScanResponse(rssi: RSSI.intValue, advertisement: advertisementData, peripheral: peripheral)
        self.scanCallBack?(scanResponse)
    }
    
    // 连接成功回调
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let delegate = findDelegate(for: peripheral.identifier.uuidString) {
            delegate.didConnected(for: peripheral)
        }
    }
    
    // 连接失败回调
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        var err = error
        
        if err == nil {
            err = NSError(domain: "CentralManagerError: FailToConnect", code: 100, userInfo: nil)
        }
        
        if let delegate = findDelegate(for: peripheral.identifier.uuidString) {
            delegate.didFailedConnect(for: peripheral, error: LECentralManagerError.unlikely(err!))
        }
    }
    
    // 断开连接回调
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        var err = error
        
        if err == nil {
            err = NSError(domain: "CentralManagerError: didDisconnectPeripheral", code: 100, userInfo: nil)
        }
        
        if let delegate = findDelegate(for: peripheral.identifier.uuidString) {
            delegate.didDisconnect(for: peripheral, error: LECentralManagerError.unlikely(err!))
        }
    }
    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
}

extension LECentralManager {
    fileprivate func findDelegate(for peripheralUUID: String) -> LECentralManagerProtocol? {
        return self.delegateDictionary[peripheralUUID]
    }
}
