//
//  ProfileManager.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/23.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

enum BLEProfileError: Error {
    case noMacAddress
    case noPeripheral
    case unknowName(name: String)
}

enum ProfileName: String {
    case huaShan = "HuaShan"
    case arc = "Amazfit Arc"
    case miBand = "MI Band 2"
    case healthBand = "Amazfit HB"
    case mars = "HM0D"
    case beatsL = "Amazfit Beats"
    case chongqing = "Chongqing"
    case beatsH = "Amazfit BeatsP"
    case miBand3 = "Mi Band 3"
    case dth = "Amazfit Bip2" // 洞庭湖
}

class ProfileManager {
    private var profiles: Dictionary<String, Profile> = [:]
    static let sharedInstance = ProfileManager()
    
    // 建立Arc profile(不保存)
    public func buildArcProfile(peripheralInfomation: HMPeripheralInfomation) throws -> LEArcProfile {
        guard let macaddress = peripheralInfomation.deviceInfomation?.macAddress  else { throw BLEProfileError.noMacAddress }
        guard !profiles.keys.contains(macaddress) else { return profiles[macaddress]! as! LEArcProfile }
        let peripheral = try buildPeripheral(peripheralInfomation: peripheralInfomation)
        return LEArcProfile(peripheral: peripheral)
    }
    
    // 根据设备信息， 建立profile， 返回Profile
    public func buildProfile(peripheralInfomation: HMPeripheralInfomation) throws -> Profile {
        guard let macaddress = peripheralInfomation.deviceInfomation?.macAddress  else { throw BLEProfileError.noMacAddress }
        guard !profiles.keys.contains(macaddress) else { return profiles[macaddress]! }
        let peripheral = try buildPeripheral(peripheralInfomation: peripheralInfomation)
        return try buildProfile(peripheral: peripheral)
    }
    
    // 根据peripheral，建立profile，返回Profile
    public func buildProfile(peripheral: LEPeripheral) throws -> Profile {
        guard let name = peripheral.peripheral.name else { throw BLEProfileError.unknowName(name: "name is nil") }
        guard let profileName = ProfileName(rawValue: name) else { throw BLEProfileError.unknowName(name: name) }
        switch profileName {
        case .arc:
            return LEArcProfile(peripheral: peripheral)
        case .huaShan:
            return LEHuaShanProfile(peripheral: peripheral)
        case .mars:
            return LEMarsProfile(peripheral: peripheral)
        case .beatsL:
            return LEAmazfitBeatsProfile(peripheral: peripheral)
        case .chongqing, .miBand3:
            return LEChongQingProfile(peripheral: peripheral)
        case .beatsH:
            return LEAmazfitBeatsPProfile(peripheral: peripheral)
        case .dth:
            return LEAmazfitDTHProfile(peripheral: peripheral)
        default: throw BLEProfileError.unknowName(name: profileName.rawValue)
        }
    }
    
    // 根据设备信息获取已经保存的profile
    public func getProfile(peripheralInfomation: HMPeripheralInfomation) -> Profile? {
        guard let macaddress = peripheralInfomation.deviceInfomation?.macAddress  else { return nil }
        return profiles[macaddress]
    }
    
    // 保存已连接的profile
    public func saveConnectedProfile(infomation: HMPeripheralInfomation, profile: Profile) throws {
        guard let macaddress = infomation.deviceInfomation?.macAddress  else { throw BLEProfileError.noMacAddress }
        profiles[macaddress] = profile
    }
    
    // 删除profile
    public func deleteProfile(peripheralInfomation: HMPeripheralInfomation) {
        guard let macAddress = peripheralInfomation.deviceInfomation?.macAddress else { return }
        guard profiles.keys.contains(macAddress) else { return }
        profiles.removeValue(forKey: macAddress)
    }
    
    // 删除所有profile
    public func deleteAllProfile() {
        profiles.removeAll()
    }
}

extension ProfileManager {
    // 根据设备信息, 创建Peripheral: 1. 根据identifier去retrive; 2. 根据name去retriveConnect; 3. 如果1、2都没有获得，则根据macAddress scan.
    private func buildPeripheral(peripheralInfomation: HMPeripheralInfomation) throws -> LEPeripheral {
        let identifier = peripheralInfomation.identifier
        guard let macaddress = peripheralInfomation.deviceInfomation?.macAddress  else { throw BLEProfileError.noMacAddress }
        var peripheral: LEPeripheral?
        if let uuid = identifier {
            peripheral = RetriveLEPeripheral.retrivePeripheral(identifier: uuid)
        } else {
            if let name = peripheralInfomation.name { peripheral = RetriveLEPeripheral.retriveConnectedPeripheral(name) }
            if peripheral == nil { peripheral = try RetriveLEPeripheral.findPeripheral(macaddress) }
        }
        
        guard let p = peripheral else { throw BLEProfileError.noPeripheral }
        return p
    }
}
