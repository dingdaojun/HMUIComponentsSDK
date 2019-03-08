//
//  ViewController+NFC.swift
//  HMNFCCardemuExample
//
//  Created by Karsa Wu on 2018/7/19.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import Foundation
import HMBluetoothKit
import huamipay

extension ViewController: NFCBLEProtocol {
    func readCardTag() throws -> Data {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { throw LEPeripheralError.unConnected }
        
        let tagData = try (profile as! NFCProtocol).getMiFareTag()
        
        return tagData;
    }
    
    func openNFCChannel() throws {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { throw LEPeripheralError.unConnected }
        let startDate = Date()
        try (profile as! NFCProtocol).openApdu()
        let endDate = Date()
        let timeConsuming = endDate.timeIntervalSince(startDate)
        totalTime += timeConsuming
        DispatchQueue.main.async {
//            self.speedTextView.text.append("Open NFC: \((String.init(format: "%2.3f", timeConsuming)))s\n")
        }
    }
    
    func closeNFCChannel() throws {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { throw LEPeripheralError.unConnected }
        let startDate = Date()
        try (profile as! NFCProtocol).closeApdu()
        let endDate = Date()
        let timeConsuming = endDate.timeIntervalSince(startDate)
        totalTime += timeConsuming
        DispatchQueue.main.async {
//            self.speedTextView.text.append("close NFC: \((String.init(format: "%2.3f", timeConsuming)))s\n")
        }
    }
    
    func transmit(_ apdu: NFCBLEProtocol.APDU) throws -> Data {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { throw LEPeripheralError.unConnected }
        let startDate = Date()
        let resp = try (profile as! NFCProtocol).sendApdu(apdu, cmdLength: apdu.count, isEncryp: false).rawData
        let endDate = Date()
        let timeConsuming = endDate.timeIntervalSince(startDate)
        totalTime += timeConsuming
        DispatchQueue.main.async {
//            self.speedTextView.text.append("send apdu: \((String.init(format: "%2.3f", timeConsuming)))s\n")
        }
        return resp
    }
}
