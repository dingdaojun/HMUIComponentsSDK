//
//  ScanHelper.swift
//  StandfordApp
//
//  Created by 余彪 on 2018/1/22.
//  Copyright © 2018年 zhanggui. All rights reserved.
//

import Foundation
import CoreBluetooth
import HMBluetoothKit

struct ScanOption {
    var macAddress: String?
    var name: String?
    var maxRSSI: Int?
    var limitNumber: Int?
}

extension LECentralManager {
    typealias ScanResultCallback = (_ scanResults: [ScanResult]) -> Void
    
    func scanWithOptional(_ option: ScanOption?, callback: @escaping ScanResultCallback) throws {
        var scanResults: [ScanResult] = []
        let manager = LECentralManager.sharedInstance
        try manager.scanPeripheralsWithServiceUUDIs([CBUUID(string: "FEE0")], nil) { (scanResponse) in
            var scanResult = ScanResult(identifier: scanResponse.peripheral.identifier)
            scanResult.rssi = scanResponse.rssi
            scanResult.analysisAdvertisement(advertisement: scanResponse.advertisement)
            guard let scanMac = scanResult.macAddress,let name = scanResult.name else { return }
            
            if let maxRSSI = option?.maxRSSI { if abs(scanResult.rssi!) > abs(maxRSSI) { return }}
            if let optionMac = option?.macAddress {
                if optionMac == scanMac {
                    scanResults = self.addToScanResults(scanResult, scanResults: scanResults, limit: option?.limitNumber)
                    callback(scanResults)
                }
                return
            }
            
            if let optionName = option?.name {
                if optionName == name {
                    scanResults = self.addToScanResults(scanResult, scanResults: scanResults, limit: option?.limitNumber)
                    callback(scanResults)
                }
                return
            }
            
            scanResults = self.addToScanResults(scanResult, scanResults: scanResults, limit: option?.limitNumber)
            callback(scanResults)
        }
    }
    
    func addToScanResults(_ scanResult: ScanResult, scanResults: [ScanResult], limit: Int? = nil) -> [ScanResult] {
        var results = scanResults
        results.append(scanResult)
        results.sort(by: { (lResult, rResult) -> Bool in
            return lResult.rssi! > rResult.rssi!
        })
        
        if let limitNumber = limit {
            if results.count >= limitNumber {
                LECentralManager.sharedInstance.stopScan()
            }
        }
        
        return results
    }
}
