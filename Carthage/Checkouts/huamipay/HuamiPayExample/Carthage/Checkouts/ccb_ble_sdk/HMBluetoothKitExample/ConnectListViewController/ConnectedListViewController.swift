//
//  ConnectedListViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/20.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import UIKit
import HMBluetoothKit

class ConnectedListViewController: UITableViewController {
    var timers: Array<RepeatingTimer> = []
    var huashanTotalData = Data()
    var arcTotalData = Data()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        let scanItem = UIBarButtonItem(title: "扫描", style: .done, target: self, action: #selector(startScan))
        self.navigationItem.rightBarButtonItem = scanItem
        let logItem = UIBarButtonItem(title: "日志", style: .done, target: self, action: #selector(log))
        self.navigationItem.leftBarButtonItem = logItem
        
        self.title = "设备"
        DeviceManager.sharedInstance.deviceUpdate = {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        
        DispatchQueue.global().asyncAfter(deadline: 1.0) { self.connect() }
    }
    
    func connect() {
        let peripherals = DeviceManager.sharedInstance.savePeripheralArray
        for peripheral in peripherals { connect(info: peripheral) }
    }
    
    func connect(info: HMPeripheralInfomation) {
        let observer = BLEStateObserver.init(info: info)
        observer.name = String(describing: self)
        observer.observer = { [weak self] (state, info) in
            guard let strongSelf = self else { return }
            switch state {
            case .connected:
                if info.name == ProfileName.mars.rawValue {
                    strongSelf.sensor(infomation: info)
                }
            default: break
            }
            DispatchQueue.main.async { strongSelf.tableView.reloadData() }
        }
        
        BLEConnectManager.sharedInstance.addBLEConnectStateObserver(observer)
        BLEConnectManager.sharedInstance.connect(peripheralInfomation: info)
    }
    
    func deletePeripehral(infomation: HMPeripheralInfomation) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("删除") { DeviceManager.sharedInstance.deletePeripheral(peripheral: infomation) }
            alertView.addButton("不删除") {}
            let msg: String = "删除后，数据将不在存储，如再此需要测试此设备，需前往扫描页面进行绑定后，到详情页进行保存即可"
            let _ = alertView.showWait("提醒", subTitle: msg, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        }
    }
    
    @objc func startScan() -> Void {
        let scanViewController = ScanTableViewController(style: .plain)
        self.navigationController?.pushViewController(scanViewController, animated: true)
    }
    
    @objc func log() {
        let logViewController = LogViewController(style: .plain)
        self.navigationController?.pushViewController(logViewController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "savePeripheral"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier) }
        let peripheral = DeviceManager.sharedInstance.savePeripheralArray[indexPath.row]
        var title: String = ""
        if let name = peripheral.name { title = name }
        if BLEConnectManager.sharedInstance.isConnected(peripheralInfomation: peripheral) { title += "   已连接" }
        cell?.textLabel?.text = title
        if let macAddress = peripheral.deviceInfomation?.macAddress { cell?.detailTextLabel?.text = "macAddress: \(String(describing: macAddress))" }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeviceManager.sharedInstance.savePeripheralArray.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除设备"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let peripheralInfomation = DeviceManager.sharedInstance.savePeripheralArray[indexPath.row]
        deletePeripehral(infomation: peripheralInfomation)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceViewController = DeviceViewController(peripheralInfomation: DeviceManager.sharedInstance.savePeripheralArray[indexPath.row])
        self.navigationController?.pushViewController(deviceViewController, animated: true)
    }
}
