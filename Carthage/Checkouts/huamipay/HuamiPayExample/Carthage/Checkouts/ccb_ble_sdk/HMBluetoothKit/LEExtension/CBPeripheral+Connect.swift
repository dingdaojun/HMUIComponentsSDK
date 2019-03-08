//
//  CBPeripheral+Connect.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/2.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth


extension CBPeripheral {
    public var isconnect: Bool {
        return self.state == .connected
    }
}
