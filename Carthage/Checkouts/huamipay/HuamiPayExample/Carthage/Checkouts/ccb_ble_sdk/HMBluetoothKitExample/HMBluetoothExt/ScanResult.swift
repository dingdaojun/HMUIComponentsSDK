//
//  ScanResult.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/1/2.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
//import CryptoSwift

public struct ScanResult: Equatable {
    public var macAddress: String? = nil
    public var name: String? = nil
    public var rssi: Int?
    public var identifier: UUID
    
    init(identifier id: UUID) {
        self.identifier = id
    }
    
    public mutating func analysisAdvertisement(advertisement: Dictionary<String, Any>?) {
        let isConnected = advertisement?["kCBAdvDataIsConnectable"] as? Bool
        
        guard isConnected == true else {
            return
        }
        
        let data: Data? = advertisement?["kCBAdvDataManufacturerData"] as? Data
        let hexString = data?.bytes.toHexString()
        let invaildHuamiDevice = hexString?.hasPrefix("5701")
        
        guard invaildHuamiDevice != nil && invaildHuamiDevice == true else {
            return
        }
        
        if let localName: String = advertisement?["kCBAdvDataLocalName"] as? String {
            self.name = localName
        }
        
        if let mac = hexString?.suffix(12) {
            let macString = String.init(mac)
            self.macAddress = macString.macAddresFormat()
        }
    }
    
    public static func ==(lhs: ScanResult, rhs: ScanResult) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
