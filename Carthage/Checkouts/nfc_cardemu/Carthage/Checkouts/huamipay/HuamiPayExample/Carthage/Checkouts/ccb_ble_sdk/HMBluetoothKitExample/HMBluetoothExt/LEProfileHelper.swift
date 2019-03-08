//
//  LEProfileHelper.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/9.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

let arcName = "Amazfit Arc";//"Wuhan";

extension LEArcProfile {
    func readBattery(callback: @escaping (BatteryInfomation?, Error?) -> Void) {
        let operation = BlockOperation {
            do {
                let data = try self.genericService.getBatteryInfomation()
                let batteryInfomation = try BatteryInfomation(data)
                callback(batteryInfomation, nil)
            } catch {
                callback(nil, error)
            }
        }
        
        OperationQueueManager.sharedInstance.addOperation(operation, for: self.peripheral.identifier)
    }
}

extension ProfileProtocol {
    func readDeviceInfomation(callback: @escaping (DeviceInfomation?, Error?) -> Void) {
        let operation = BlockOperation {
            do {
                var infomation = DeviceInfomation()
                infomation.serial = try self.deviceInfomationService.getSerialNumber()
                infomation.hardwareVersion = try self.deviceInfomationService.getHardwareRevision()
                infomation.softwareVersion = try self.deviceInfomationService.getSoftwareRevision()
                
                let deviceIDData = try self.deviceInfomationService.getSystemID()
                guard deviceIDData.count == 8 else { callback(nil, NSError(domain: "get system id data count error: \(deviceIDData.toHexString())", code: 0, userInfo: nil)); return }
                infomation.deviceID = deviceIDData.toHexString()
                var macAddress = deviceIDData.subdata(in: 0..<3)
                macAddress.append(deviceIDData.subdata(in: (deviceIDData.count - 3)..<deviceIDData.count))
                let mac = macAddress.toHexString()
                infomation.macAddress = mac.macAddresFormat()
                
                let pnpData = try self.deviceInfomationService.getPnPID()
                let pnpBytes = pnpData.bytes
                infomation.companyID = "\(pnpBytes[0] & 0xFF)"
                let venderID = ((pnpBytes[2] & 0xFF) << 8) | (pnpBytes[1] & 0xFF)
                infomation.venderID = "\(venderID)"
                let productID = ((pnpBytes[4] & 0xFF) << 8) | (pnpBytes[3] & 0xFF)
                infomation.productID = "\(productID)"
                let productVersion = ((pnpBytes[6] & 0xFF) << 8) | (pnpBytes[5] & 0xFF)
                infomation.productVersion = "\(productVersion)"
                callback(infomation, nil)
            } catch {
                callback(nil, error)
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: peripheral.identifier)
    }
}
