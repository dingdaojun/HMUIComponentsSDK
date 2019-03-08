//
//  HMBluetoothPeripheralManager+Delegate.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/16.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth


extension LEPeripheral: CBPeripheralDelegate {
    // 读取RSSI值
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        response = .readRSSI(peripheral, RSSI, error)
        let _ = readRSSIResponseSemaphore.signal()
    }
    
    // 发现服务回调
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        response = .discoverService(peripheral, error)
        let _ = responseSemaphore.signal()
    }
    
    // 发现特征回调
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        response = .discoverCharacteristic(peripheral, service, error)
        let _ = responseSemaphore.signal()
    }
    
    // 值更新
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if hasPendingReadRequest.contains(characteristic.uuid) {
            self.peripheral(peripheral, didReadValueFor: characteristic, error: error)
        } else {
            self.peripheral(peripheral, didNotifyFor: characteristic, error: error)
        }
    }
    
    // 写入值回调
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        response = .writeCharacteristic(peripheral, characteristic, error)
        let _ = responseSemaphore.signal()
    }
    
    // 订阅回调
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        response = .setNotifyValue(peripheral, characteristic, error)
        let _ = responseSemaphore.signal()
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices: \(String(describing: peripheral.services)); modifyServiceCallback: \(String(describing: modifyServiceCallback))")
        
        if let callback = modifyServiceCallback {
            callback(invalidatedServices)
        } else {
            fatalError("didModifyServices but not call back")
        }
    }
}

extension LEPeripheral {
    func peripheral(_ peripheral: CBPeripheral, didReadValueFor characteristic: CBCharacteristic, error: Error?) {
        response = .readCharacteristic(peripheral, characteristic, error)
        let _ = responseSemaphore.signal()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didNotifyFor characteristic: CBCharacteristic, error: Error?) {
        if let notifyCallBackArray = notifyCallBackDictionary[characteristic.identifier] {
            for callback in notifyCallBackArray {
                callback(peripheral, characteristic, error)
            }
        }
    }
}

