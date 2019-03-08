//
//  HMBluetoothCoreManager.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/10/20.
//  Copyright © 2017年 余彪. All rights reserved.
//

import UIKit
import CoreBluetooth


public typealias StatusCallBack = (_ statue: HMBluetoothStatus) -> Void
public typealias ScanCallBack = (_ scanResponse: LEScanResponse) -> Void


public class LECentralManager: NSObject {
    /// reStore Identifier
    public static var identifier = "com.blue.identifier"
    /// single
    public static let sharedInstance = LECentralManager()
    public var bleutoothStatus: HMBluetoothStatus = .unknow
    var centeralManager: CBCentralManager!
    let queue: DispatchQueue = DispatchQueue(label: "com.huami.bluetooth.core")
    let cacheQueue: DispatchQueue = DispatchQueue(label: "com.huami.bluetooth.core.cache")
    var scanCallBack: ScanCallBack?
    var statusUpdateCallBack: StatusCallBack?
    var delegateDictionary: Dictionary<String, LECentralManagerProtocol> = [:]
    
    override init() {
        // 私有化 不被外界进行调用
        super.init()
        let optional: Dictionary<String, Any> = [CBCentralManagerOptionShowPowerAlertKey: true,
                                                 CBCentralManagerOptionRestoreIdentifierKey: LECentralManager.identifier]
        centeralManager = CBCentralManager(delegate: self as CBCentralManagerDelegate, queue: queue, options: optional)
    }
}
