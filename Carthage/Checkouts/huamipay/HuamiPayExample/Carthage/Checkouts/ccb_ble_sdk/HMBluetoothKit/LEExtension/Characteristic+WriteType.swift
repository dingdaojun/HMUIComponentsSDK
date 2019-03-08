//
//  Characteristic+WriteType.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/29.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {
    public var identifier: String {
        get {
            return self.uuid.uuidString
        }
    }
    
    public var writeResponseType: CBCharacteristicWriteType {
        get {
            var type: CBCharacteristicWriteType = .withResponse
            
            if self.properties.contains(CBCharacteristicProperties.writeWithoutResponse) == true {
                type = .withoutResponse
            }
            
            return type
        }
    }
}
