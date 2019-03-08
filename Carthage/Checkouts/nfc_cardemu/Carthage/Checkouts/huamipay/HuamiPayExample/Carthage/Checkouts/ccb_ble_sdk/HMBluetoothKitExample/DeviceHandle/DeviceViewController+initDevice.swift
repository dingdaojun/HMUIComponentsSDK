//
//  DeviceViewController+initDevice.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/6.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    func initDevice() {
        if let name = self.peripheral.peripheralName {
            baseDevice = HMBluetoothDevice(peripheral: self.peripheral)
            
            if name == "HuaShan" {
                nfcDevice = HMBluetoothNFCDevice(peripheral: self.peripheral)
            } else if name == "Amazfit HB" ||
                      name == "MI Band 2" {
                proBaseDevice = HMBluetoothProBaseDevice(peripheral: self.peripheral)
                ecgDevice = HMBluetoothECGDevice(peripheral: self.peripheral)
            }
        }
    }
}
