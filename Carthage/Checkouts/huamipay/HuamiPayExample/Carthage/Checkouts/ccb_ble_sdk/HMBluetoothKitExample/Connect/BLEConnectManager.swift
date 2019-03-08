//
//  BLEConnectManager.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/2/23.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit
import CoreBluetooth

let APPID_MIFIT = 10
enum BLEState {
    case powerOn
    case powerOff
    case disConnect(error: Error?)
    case connected
}

class BLEStateObserver {
    typealias Observer = (_ state: BLEState, _ infomation: HMPeripheralInfomation) -> Void
    // 唯一性: 建议使用class name
    var name: String?
    var observer: Observer?
    var infomation: HMPeripheralInfomation
    
    init(info: HMPeripheralInfomation) {
        self.infomation = info
    }
}

class BLEConnectManager {
    var observersDictionary: Dictionary<String, Array<BLEStateObserver>> = [:]
    static let sharedInstance = BLEConnectManager()
    
    init() {
        LECentralManager.sharedInstance.subscribeBluetoothStatus { [weak self] (state) in
            ProfileManager.sharedInstance.deleteAllProfile()
            switch state {
            case .ready:
                self?.bleStateChangedToServer(state: .powerOn)
            default: self?.bleStateChangedToServer(state: .powerOff)
            }
            self?.reconnectAllSavePeripheral()
        }
    }
}

// MARK: - 对外方法
extension BLEConnectManager {
    /// 连接
    ///
    /// - Parameter peripheralInfomation: 设备信息
    public func connect(peripheralInfomation: HMPeripheralInfomation) {
        guard let macaddress = peripheralInfomation.deviceInfomation?.macAddress else {
            print("no macAddress: \(peripheralInfomation)")
            return
        }
        let operation = BlockOperation {
            do {
                let profile = try ProfileManager.sharedInstance.buildProfile(peripheralInfomation: peripheralInfomation)
                if peripheralInfomation.identifier == nil {
                    peripheralInfomation.identifier = profile.peripheral.identifier
                    DeviceManager.sharedInstance.saveOrUpdatePeripheral(peripheral: peripheralInfomation)
                }
                profile.peripheral.subscribeModifyService({ (_) in
                    self.connect(peripheralInfomation: peripheralInfomation)
                })
                try ProfileManager.sharedInstance.saveConnectedProfile(infomation: peripheralInfomation, profile: profile)
                guard profile.peripheral.isConnected else {
                    print("未连接去连接: \(macaddress)")
                    LECentralManager.sharedInstance.setDelegate(delegate: self, for: profile.peripheral.identifier.uuidString)
                    try LECentralManager.sharedInstance.connectPeripheral(peripheral: profile.peripheral)
                    return
                }
                print("已连接,扫描服务: \(macaddress)")
                try profile.peripheral.discoverAllServiceAndCharacteristics()
                print("扫描服务完成,去认证: \(macaddress)")
                self.auth(profile: profile, peripheralInfomation: peripheralInfomation)
            } catch {
                print("connect error: \(error)")
                self.sendBleConnectStateToObserver(infomation: peripheralInfomation, state: BLEState.disConnect(error: error))
            }
        }
        OperationQueueManager.sharedInstance.bleQueue.addOperation(operation)
    }
    
    /// 添加订阅蓝牙连接状态: 一定要记得移除
    ///
    /// - Parameter observer: 订阅信息
    public func addBLEConnectStateObserver(_ observer: BLEStateObserver) {
        guard let macAddress = observer.infomation.deviceInfomation?.macAddress else { return }
        var observers: Array<BLEStateObserver> = []
        if let os = observersDictionary[macAddress] { observers = os}
        observers.append(observer)
        observersDictionary[macAddress] = observers
    }
    
    /// 移除订阅蓝牙连接状态
    ///
    /// - Parameter observer: 订阅信息
    public func removeBLEConnectStateOberver(_ observer: BLEStateObserver) {
        guard let macAddress = observer.infomation.deviceInfomation?.macAddress else { return }
        guard var observers = observersDictionary[macAddress] else { return }
        for (index, ob) in observers.enumerated() {
            if ob.name == observer.name { observers.remove(at: index) }
        }
        observersDictionary[macAddress] = observers
    }
    
    // 根据设备信息，查看设备是否连接
    public func isConnected(peripheralInfomation: HMPeripheralInfomation) -> Bool {
        guard let _ = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) else {
            return false
        }
        return true
    }
}

// MARK: - 私有方法
extension BLEConnectManager {
    /// 授权/认证: 内部根据infomation是否有authKey进行自动判别
    ///
    /// - Parameters:
    ///   - profile: profile
    ///   - peripheralInfomation: 设备信息
    private func auth(profile: Profile, peripheralInfomation: HMPeripheralInfomation) {
        let operation = BlockOperation {
            do {
                if let key = peripheralInfomation.authKey {
                    try (profile as? AuthProtocol)?.authenticate(appid: APPID_MIFIT, key: Data.init(hex: key).bytes)
                } else {
                    let authkey = NSUUID().uuidString.md5()
                    peripheralInfomation.authKey = authkey
                    print("authKey: \(authkey)")
                    try (profile as? AuthProtocol)?.authorize(appid: APPID_MIFIT, key: Data.init(hex: peripheralInfomation.authKey!).bytes)
                    DeviceManager.sharedInstance.saveOrUpdatePeripheral(peripheral: peripheralInfomation)
                }
                try ProfileManager.sharedInstance.saveConnectedProfile(infomation: peripheralInfomation, profile: profile)
                self.sendBleConnectStateToObserver(infomation: peripheralInfomation, state: .connected)
                self.readDeviceInfomation(profile: profile)
            } catch LEPeripheralError.invailedResponse(let data) {
                print("auth error: invailedResponse(\(data.toHexString())")
                let error = NSError(domain: "invailedResponse: \(data.toHexString())", code: 0, userInfo: nil)
                self.sendBleConnectStateToObserver(infomation: peripheralInfomation, state: BLEState.disConnect(error: error))
            } catch {
                print("auth error: \(error)")
                self.sendBleConnectStateToObserver(infomation: peripheralInfomation, state: BLEState.disConnect(error: error))
            }
        }
        operation.name = OperationName.auth.rawValue
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }
    
    /// 删除profile
    ///
    /// - Parameter peripheral: LEPeripheral
    /// - Returns: 设备信息
    private func deleteProfile(for identifier: UUID) -> HMPeripheralInfomation? {
        guard let infomation = DeviceManager.sharedInstance.getPeripheralInfomation(identifier: identifier) else { return nil }
        ProfileManager.sharedInstance.deleteProfile(peripheralInfomation: infomation)
        return infomation
    }
    
    /// 读取设备信息
    ///
    /// - Parameter profile: profile
    private func readDeviceInfomation(profile: ProfileProtocol) {
        guard let infomation = DeviceManager.sharedInstance.getPeripheralInfomation(identifier: profile.peripheral.identifier) else { return }
        profile.readDeviceInfomation { (deviceInfomation, error) in
            guard error == nil else { return }
            infomation.deviceInfomation = deviceInfomation
            DeviceManager.sharedInstance.saveOrUpdatePeripheral(peripheral: infomation)
        }
    }
}

// MARK: - LECentralManagerProtocol
extension BLEConnectManager: LECentralManagerProtocol {
    func didConnected(for peripheral: CBPeripheral) {
        guard let infomation = DeviceManager.sharedInstance.getPeripheralInfomation(identifier: peripheral.identifier) else {
            print("didConnected error: 无设备信息")
            return
        }
        print("系统已连接: \(String(describing: infomation.deviceInfomation?.macAddress))")
        connect(peripheralInfomation: infomation)
    }
    
    func didDisconnect(for peripheral: CBPeripheral, error: LECentralManagerError?) {
        guard let infomation = deleteProfile(for: peripheral.identifier) else { return }
        sendBleConnectStateToObserver(infomation: infomation, state: BLEState.disConnect(error: error))
        reconnect(peripheralInfomation: infomation)
    }
    
    func didFailedConnect(for peripheral: CBPeripheral, error: LECentralManagerError?) {
        guard let infomation = deleteProfile(for: peripheral.identifier) else { return }
        sendBleConnectStateToObserver(infomation: infomation, state: BLEState.disConnect(error: error))
        reconnect(peripheralInfomation: infomation)
    }
}
