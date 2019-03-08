//
//  BandListViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import HMBluetoothKit


class BandListViewController: UIViewController {
    var currentInfomation: HMPeripheralInfomation?
    typealias CompleteCallback = (_ info: HMPeripheralInfomation) -> Void
    var completeCallback: CompleteCallback?
    typealias DeleteCallback = () -> Void
    var deleteCallback: DeleteCallback?
    
    override func viewDidLoad() {
        self.title = "切换手环"
        let myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
    }
}

extension BandListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let info = DeviceManager.sharedInstance.savePeripheralArray[indexPath.row]
        var name = info.name ?? ""
        if BLEConnectManager.sharedInstance.isConnected(peripheralInfomation: info) { name += "(已连接)" }
        cell?.textLabel?.text = name
        cell?.detailTextLabel?.text = info.deviceInfomation?.macAddress
        
        if currentInfomation?.deviceInfomation?.macAddress == info.deviceInfomation?.macAddress {
            cell?.accessoryType = .checkmark
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeviceManager.sharedInstance.savePeripheralArray.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除设备"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let peripheralInfomation = DeviceManager.sharedInstance.savePeripheralArray[indexPath.row]
        
        if let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) {
            try? LECentralManager.sharedInstance.disconnectPeripheral(peripheral: profile.peripheral)
        }
        
        DeviceManager.sharedInstance.deletePeripheral(peripheral: peripheralInfomation)
        ViewController.successTips(title: "成功", subTitle: "删除成功")
        
        if currentInfomation?.deviceInfomation?.macAddress == peripheralInfomation.deviceInfomation?.macAddress {
            currentInfomation = nil
            ViewController.infomation = nil
        }
        deleteCallback!()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = DeviceManager.sharedInstance.savePeripheralArray[indexPath.row]
        guard BLEConnectManager.sharedInstance.isConnected(peripheralInfomation: info) else {
            ViewController.failTips(title: "失败", subTitle: "未连接")
            return
        }
        completeCallback!(info)
        self.navigationController?.popViewController(animated: false)
    }
}
