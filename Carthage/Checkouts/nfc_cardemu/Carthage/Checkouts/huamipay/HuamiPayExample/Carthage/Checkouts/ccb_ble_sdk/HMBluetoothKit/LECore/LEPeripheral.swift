//
//  HMBluetoothPeripheralManager.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/16.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth

public final class LEPeripheral: NSObject, LESynchronizedPeripheralProtocol {
    public var peripheral: CBPeripheral
    lazy var readRSSIRequestSemaphore = DispatchSemaphore.init(value: 1)
    lazy var readRSSIResponseSemaphore = DispatchSemaphore.init(value: 0)
    lazy var requestSemaphore = DispatchSemaphore.init(value: 1)
    lazy var responseSemaphore = DispatchSemaphore.init(value: 0)
    var response: LEPeripheralResponse?
    var timeout: Int = DEFAULT_TIMEOUT
    var notifyCallBackDictionary: Dictionary<String, Array<LESynchronizedPeripheralProtocol.NotifyCallback>> = [:]
    var modifyServiceCallback: ModifyServiceCallback?
    let pendingReadRequestQueue = DispatchQueue(label: "PendingReadRequestQueue")
    var hasPendingReadRequest: Set<CBUUID> = []
    
    /// identifier
    public var identifier: UUID {
        get {
            return peripheral.identifier
        }
    }
    
    /// is connected: peripheral.state == .connected
    public var isConnected: Bool {
        get {
            return peripheral.state == .connected
        }
    }
    
    public init(peripheral ph: CBPeripheral) {
        self.peripheral = ph
        super.init()
        peripheral.delegate = self
    }
    
    deinit {
        print("LEPeripheral deinit")
        readRSSIResponseSemaphore.signal()
        responseSemaphore.signal()
    }
}
