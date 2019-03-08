//
//  DeviceManager.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/22.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import Cache

typealias DeviceUpdate = () -> Void

final class DeviceManager: NSObject {
    static let sharedInstance = DeviceManager()
    private(set) var savePeripheralArray: [HMPeripheralInfomation] = []
    private var storage: Storage
    private let peripheralCacheKey = "peripheralCacheKey"
    var deviceUpdate: DeviceUpdate?
    var authorizeInfomation: HMPeripheralInfomation?
    
    
    private override init() {
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let diskConfig = DiskConfig(name: peripheralCacheKey, expiry: .never, maxSize: 100, directory: docsurl, protectionType: nil)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 100, totalCostLimit: 100)
        self.storage = try! Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
        super.init()
        
        storage.async.object(ofType: Array<HMPeripheralInfomation>.self, forKey: peripheralCacheKey) { [weak self] (result) in
            switch result {
            case .value(let peripheralArray):
                var array: Array<HMPeripheralInfomation> = []
                for peripheral in peripheralArray { array.append(peripheral) }
                self?.savePeripheralArray = array
                self?.deviceUpdate?()
            case .error:
                print("no such object")
            }
        }
    }
    
    /// 保存设备信息
    ///
    /// - Parameter peripheral: 设备信息
    public func saveOrUpdatePeripheral(peripheral: HMPeripheralInfomation) {
        if peripheral == authorizeInfomation { authorizeInfomation = nil }
        guard savePeripheralArray.contains(peripheral) == false else {
            updateDevice(peripheral: peripheral)
            return
        }
        savePeripheralArray.append(peripheral)
        deviceUpdate?()
        save()
    }
    
    /// 是否存在当前设备信息
    ///
    /// - Parameter peripheral: 设备信息
    /// - Returns: true/false
    public func isExsit(peripheral: HMPeripheralInfomation) -> Bool {
        return savePeripheralArray.contains(peripheral)
    }
    
    // 根据identifier获取设备信息
    public func getPeripheralInfomation(identifier: UUID) -> HMPeripheralInfomation? {
        let infomation = savePeripheralArray.filter({ (info) -> Bool in
            return info.identifier == identifier
        }).first
        guard infomation == nil else { return infomation }
        guard authorizeInfomation?.identifier == identifier else { return nil }
        return authorizeInfomation
    }
    
    // 根据macAddress获取设备信息
    public func getPeripheralInfomation(macAddress: String) -> HMPeripheralInfomation? {
        return savePeripheralArray.filter({ (info) -> Bool in
            return info.deviceInfomation?.macAddress == macAddress
        }).first
    }
    
    /// 删除设备信息
    ///
    /// - Parameter peripheral: 设备信息
    public func deletePeripheral(peripheral: HMPeripheralInfomation) {
        if let index = savePeripheralArray.index(of: peripheral) {
            savePeripheralArray.remove(at: index)
            deviceUpdate?()
            save()
        }
    }
    
    /// 更新设备信息
    ///
    /// - Parameter peripheral: 设备信息
    public func updateDevice(peripheral: HMPeripheralInfomation) {
        if let index = savePeripheralArray.index(of: peripheral) {
            savePeripheralArray[index] = peripheral
            deviceUpdate?()
            save()
        }
    }
}

extension DeviceManager {
    private func save() {
        storage.async.setObject(savePeripheralArray, forKey: peripheralCacheKey) { (result) in
            switch result {
            case .value:
                print("saved successfully")
            case .error(let error):
                print("save failed: \(error)")
            }
        }
    }
}
