//
//  RetriveLEPeripheral.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/5.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import CoreBluetooth
import HMBluetoothKit

// helper
class RetriveLEPeripheral {
    typealias ScanBlockQueue = ValueSemaphore<LEPeripheral>
    
    static func retrivePeripheral(identifier: UUID) -> LEPeripheral? {
        let peripheralList = LECentralManager.sharedInstance.retrievePeripherals(identifiers: [identifier])
        if peripheralList.count > 0 { return peripheralList.first! }
        return nil
    }
    
    static func retriveConnectedPeripheral(_ peripheralName: String) -> LEPeripheral? {
        let services = [CBUUID(string: "FEE1"),]
        var peripheralList = LECentralManager.sharedInstance.retrieveConnectedPeripherals(withServices: services)
        peripheralList = peripheralList.filter { (peripheral) -> Bool in
            return peripheral.peripheral.name == peripheralName
        }
        
        guard peripheralList.count > 0 else { return nil}
        return peripheralList.first!
    }
    
    static func findPeripheral(_ macAddress: String, timeout seconds: Int = 30) throws -> LEPeripheral {
        let queue = ScanBlockQueue()
        try LECentralManager.sharedInstance.scanPeripheralsWithServiceUUDIs([CBUUID(string: "FEE0")], nil) { (scanResponse) in
            var scanResult = ScanResult(identifier: scanResponse.peripheral.identifier)
            scanResult.analysisAdvertisement(advertisement: scanResponse.advertisement)
            if scanResult.macAddress == macAddress {
                queue.push(LEPeripheral(peripheral: scanResponse.peripheral))
            }
        }
        
        do {
            let peripheral = try queue.pop(timeout: Double(seconds))
            LECentralManager.sharedInstance.stopScan()
            return peripheral
        } catch {
            LECentralManager.sharedInstance.stopScan()
            throw error
        }
    }
}
