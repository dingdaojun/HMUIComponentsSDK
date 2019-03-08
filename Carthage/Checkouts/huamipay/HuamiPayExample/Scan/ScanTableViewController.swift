//
//  ScanTableViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/7.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import UIKit
import HMBluetoothKit


class ScanTableViewController: UITableViewController {
    private var scanResultArray: Array<ScanResult> = []
    private var alert: SCLAlertViewResponder?
    private var waitScanAlert: SCLAlertViewResponder?
    lazy var scanOption = ScanOption()
    private var connectAlert: SCLAlertViewResponder?
    private var observer: BLEStateObserver?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        scanOption.name = "Amazfit Beats"
        scan()
        
        let filterItem = UIBarButtonItem(title: "条件扫描", style: .done, target: self, action: #selector(scanFilter))
        self.navigationItem.rightBarButtonItems = [filterItem]
    }
    
    @objc func scanFilter() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let macTextField = alert.addTextField("mac地址")
            
            if let macAddress = self.scanOption.macAddress {
                macTextField.text = macAddress
            }
            
            _ = alert.addButton("根据此mac地址扫描") {
                if let macAddress = macTextField.text {
                    self.scanOption.name = nil
                    self.scanOption.macAddress = macAddress
                    self.scan()
                }
            }
            
            let nameTextField = alert.addTextField("设备名称,如HuaShan")
            
            if let name = self.scanOption.name {
                nameTextField.text = name
            }
            
            _ = alert.addButton("根据此设备名称扫描", action: {
                if let name = nameTextField.text {
                    self.scanOption.macAddress = nil
                    self.scanOption.name = name
                    self.scan()
                }
            })
            
            _ = alert.addButton("没有条件直接扫描", action: {
                self.scanOption.macAddress = nil
                self.scanOption.name = nil
                self.scan()
            })
            
            _ = alert.showEdit("扫描服务", subTitle:"条件扫描，请注意mac地址/设备名称的填写正确，否则会扫描不到设备")
        }
    }
    
    private func scan(_ alert: Bool = true) {
        if alert {
            DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                
                let alertView = SCLAlertView(appearance: appearance)
                _ = alertView.addButton("停止扫描扫描", action: {
                    self.stopScan()
                })
                self.waitScanAlert = alertView.showWait("扫描", subTitle: "扫描中...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
            }
        }
        
        let manager = LECentralManager.sharedInstance
        do {
            try manager.scanWithOptional(scanOption, callback: { (scanResults) in
                self.scanResultArray = scanResults
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        } catch {
            DispatchQueue.main.async {
                ViewController.failTips(title: "扫描失败", subTitle: "\(error)")
                self.waitScanAlert?.close()
            }
        }
    }
    
    func stopScan() {
        LECentralManager.sharedInstance.stopScan()
        DispatchQueue.main.async {
            self.waitScanAlert?.close()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "scanPeripheral"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier) }
        
        let scanResult = scanResultArray[indexPath.row]
        cell?.textLabel?.text = scanResult.name
        
        if let macAddress = scanResult.macAddress {
            cell?.detailTextLabel?.text = "mac: \(String(describing: macAddress))   rssi: \(String(describing: scanResult.rssi))"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scanResultArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scanResult = scanResultArray[indexPath.row]
        let infomation = HMPeripheralInfomation(identifier: scanResult.identifier)
        infomation.name = scanResult.name
        var deviceInfomation = DeviceInfomation()
        deviceInfomation.macAddress = scanResult.macAddress
        infomation.deviceInfomation = deviceInfomation
        authConnect(infomation)
    }
    
    func authConnect(_ info: HMPeripheralInfomation) {
        observer = BLEStateObserver.init(info: info)
        observer?.name = String(describing: self)
        observer?.observer = { [weak self] (state, info) in
            guard let strongSelf = self else { return }
            var msg = ""
            switch state {
            case .connected:
                msg = "授权成功"
            case .powerOn:
                msg = "蓝牙已打开"
            case .powerOff:
                msg = "蓝牙关闭"
            case .disConnect:
                msg = "断开连接"
            }
            
            DispatchQueue.main.async { strongSelf.connectAlert?.setSubTitle(msg) }
            
            DispatchQueue.main.asyncAfter(deadline: 3, execute: {
                self?.connectAlert?.close()
                self?.navigationController?.popViewController(animated: true)
            })
        }
        BLEConnectManager.sharedInstance.addBLEConnectStateObserver(observer!)
        
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            self.connectAlert = alertView.showWait("授权", subTitle: "授权中...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        }
        
        DeviceManager.sharedInstance.authorizeInfomation = info
        BLEConnectManager.sharedInstance.connect(peripheralInfomation: info)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let ob = observer else { return }
        BLEConnectManager.sharedInstance.removeBLEConnectStateOberver(ob)
    }
}
