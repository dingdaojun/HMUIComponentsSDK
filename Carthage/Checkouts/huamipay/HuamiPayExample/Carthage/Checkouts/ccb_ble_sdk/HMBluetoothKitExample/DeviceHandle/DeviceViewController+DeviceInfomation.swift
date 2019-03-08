//
//  DeviceViewController+DeviceInfomation.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/30.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

extension DeviceViewController {
    @objc func readDeviceInfomation() {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) else { return }
        let operation = BlockOperation {
            do {
                let softwareRevision = try (profile as DeviceInfomationProtocol).getSoftwareRevision()
                let hardwareRevision = try (profile as DeviceInfomationProtocol).getHardwareRevision()
                let serialNumber = try (profile as DeviceInfomationProtocol).getSerialNumber()
                let systemID = try (profile as DeviceInfomationProtocol).getSystemID()
                
                var info = DeviceInfomation()
                info.deviceID = systemID.toHexString()
                info.serial = serialNumber
                info.hardwareVersion = hardwareRevision
                info.softwareVersion = softwareRevision
                self.readDeviceInfomationResult(info: info, error: nil)
            } catch {
                
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }
    
    func readDeviceInfomationResult(info: DeviceInfomation?, error: Error?) {
        if let deviceInfo = info {
            var msg: String = ""
            
            if let hardwareVersion = deviceInfo.hardwareVersion {
                msg.append("硬件版本: \(hardwareVersion) \n")
            }
            
            if let softwareVersion = deviceInfo.softwareVersion {
                msg.append("固件版本: \(softwareVersion) \n")
            }
            
            if let hardwareVersion = deviceInfo.hardwareVersion {
                msg.append("硬件版本: \(hardwareVersion) \n")
            }
            
            if let deviceID = deviceInfo.deviceID {
                msg.append("设备ID: \(deviceID) \n")
            }
            
            if let serial = deviceInfo.serial {
                msg.append("serialNumber: \(serial) \n")
            }
            
            var pnp: String = "PNP: "
            
            if let comp = deviceInfo.companyID {
                pnp.append("公司:\(comp) ")
            }
            
            if let proversion = deviceInfo.productVersion {
                pnp.append("产品:\(proversion) ")
            }
            
            if let proID = deviceInfo.productID {
                pnp.append("产品ID:\(proID) ")
            }
            
            msg.append(pnp)
            
            DispatchQueue.main.async {
                _ = SCLAlertView().showInfo("设备信息", subTitle:  msg)
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "设备信息失败", subTitle: "设备信息失败原因: \(String(describing: error))")
            }
        }
    }
}
