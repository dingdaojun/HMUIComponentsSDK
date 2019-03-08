//
//  ViewControll+NFC.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/31.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import HMBluetoothKit
import huamipay


extension ViewController: NFCBLEProtocol {
    func openNFCChannel() throws {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { throw LEPeripheralError.unConnected }
        let startDate = Date()
        try (profile as! NFCProtocol).openApdu()
        let endDate = Date()
        let timeConsuming = endDate.timeIntervalSince(startDate)
        totalTime += timeConsuming
        DispatchQueue.main.async {
            self.speedTextView.text.append("Open NFC: \((String.init(format: "%2.3f", timeConsuming)))s\n")
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
        self.speedTextView.text.append("close NFC: \((String.init(format: "%2.3f", timeConsuming)))s\n")
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
        self.speedTextView.text.append("send apdu: \((String.init(format: "%2.3f", timeConsuming)))s\n")
        }
        return resp
    }
    
    func readCardTag() throws -> Data {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) else { throw LEPeripheralError.unConnected }
        return try (profile as! NFCProtocol).getMiFareTag()
    }
}
