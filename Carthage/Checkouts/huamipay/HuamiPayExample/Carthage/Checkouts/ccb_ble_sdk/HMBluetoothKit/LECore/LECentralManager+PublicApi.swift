//
//  HMBluetoothCoreManager+PublicApi.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/10/20.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth


extension LECentralManager {
    
    /// subscribe ble statue: when ble statue changed, will callback
    ///
    /// - Parameter callback: callback
    public func subscribeBluetoothStatus(callback: @escaping StatusCallBack) {
        self.statusUpdateCallBack = callback
    }
    
    /// peripehral status delegate: didConnect/disConnect/failedConnect. see: LECentralManagerProtocol  delegate
    ///
    /// - Parameters:
    ///   - delegate: delegate
    ///   - peripheralIdentifier: peripehral identifier
    public func setDelegate(delegate: LECentralManagerProtocol, for peripheralIdentifier: String = "") {
        self.delegateDictionary[peripheralIdentifier] = delegate
    }
    
    /// remove delegate
    ///
    /// - Parameter peripheralUUID: peripheral identifier
    public func removeDelegate(for peripheralUUID: String) {
        let _ = self.delegateDictionary.removeValue(forKey: peripheralUUID)
    }
    
    /// 扫描设备
    ///
    /// - Parameters:
    ///   - serviceUUIDS: serviceUUID this need a base service uuid
    ///   - option: option description
    ///   - scanCallBack: callback
    /// - Throws: error
    public func scanPeripheralsWithServiceUUDIs(_ serviceUUIDS: Array<CBUUID>? = nil, _ option: Dictionary<String, Any>? = nil, scanCallBack: @escaping ScanCallBack) throws {
        guard isAvaliableForSystemBluetooth() else {
            throw LECentralManagerError.poweroff(self.bleutoothStatus)
        }
        
        self.scanCallBack = scanCallBack
        self.centeralManager.scanForPeripherals(withServices: serviceUUIDS, options: option)
    }
    
    /// 停止扫描
    public func stopScan() {
        guard isAvaliableForSystemBluetooth() else {
            return
        }
        
        self.centeralManager.stopScan()
    }
    
    /// 连接设备
    ///
    /// - Parameter peripheral: LEPeripheral come from retrive/retriveConnect/scan
    /// - Throws: Error
    public func connectPeripheral(peripheral: LEPeripheral) throws {
        guard isAvaliableForSystemBluetooth() else {
            throw LECentralManagerError.poweroff(self.bleutoothStatus)
        }
        
        self.centeralManager.connect(peripheral.peripheral, options: nil)
    }
    
    /// 断链设备
    ///
    /// - Parameter peripheral: LEPeripheral come from retrive/retriveConnect/scan
    /// - Throws: Error
    public func disconnectPeripheral(peripheral: LEPeripheral) throws {
        guard isAvaliableForSystemBluetooth() else {
            throw LECentralManagerError.poweroff(self.bleutoothStatus)
        }
        
        self.centeralManager.cancelPeripheralConnection(peripheral.peripheral)
    }
}

extension LECentralManager {
    
    /// retrieve peripheral: the peripehral have scan
    ///
    /// - Parameter identifiers: peripheral identifier
    /// - Returns: LEPeripheral array
    public func retrievePeripherals(identifiers: [UUID]) -> [LEPeripheral] {
        let peripheralList = self.centeralManager.retrievePeripherals(withIdentifiers: identifiers)
        let lePeripheralList: Array<LEPeripheral> = peripheralList.map {
            LEPeripheral(peripheral: $0)
        }
        
        return lePeripheralList
    }
    
    /// retrieve connect peripheral: has connectted in iphone
    ///
    /// - Parameter servicesUUIDS: services uuid
    /// - Returns: LEPeripheral array
    public func retrieveConnectedPeripherals(withServices servicesUUIDS: [CBUUID]) -> [LEPeripheral] {
        let peripheralList = self.centeralManager.retrieveConnectedPeripherals(withServices: servicesUUIDS)
        let lePeripheralList: Array<LEPeripheral> = peripheralList.map {
            LEPeripheral(peripheral: $0)
        }
        
        return lePeripheralList
    }
}

extension LECentralManager {
    /// 判断系统蓝牙是否可用
    ///
    /// - Returns: true/false
    public func isAvaliableForSystemBluetooth() -> Bool {
        guard self.bleutoothStatus == .ready else {
            return false
        }
        
        return true
    }
}

