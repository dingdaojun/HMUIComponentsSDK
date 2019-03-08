//
//  ProfileProtocol.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/2/24.
//

import Foundation

public protocol ProfileProtocol {
    var peripheral: LEPeripheral {get set}
    var deviceInfomationService: DeviceInfomationService {get}
}
