//
//  DeviceViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/22.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import UIKit


class DeviceViewController: UITableViewController {
    var peripheralInfomation: HMPeripheralInfomation
    private var featureList: Dictionary<String, Array<Feature>> = [:]
    private var typeList: Array<String> = []
    private var observer: BLEStateObserver?
    
    var authConnectAlert: SCLAlertViewResponder?
    var realStepAlert: SCLAlertViewResponder?
    var heartRateAlert: SCLAlertViewResponder?
    var upgradeFirmwareAlert: SCLAlertViewResponder?
    var upgradeTypeAlert: SCLAlertViewResponder?
    var userInfomationAlert: SCLAlertViewResponder?
    var sensorAlert: SCLAlertViewResponder?
    var syncAlert: SCLAlertViewResponder?
    var syncLoadingAlert: SCLAlertViewResponder?
    
    var baseTitle: String {
        var title = ""
        if let macAddress = peripheralInfomation.deviceInfomation?.macAddress {
            title += "\(macAddress)"
        } else if let name = peripheralInfomation.name {
            title += name
        }
        
        return title
    }
    
    init(peripheralInfomation: HMPeripheralInfomation) {
        self.peripheralInfomation = peripheralInfomation
        super.init(style: .plain)
        if BLEConnectManager.sharedInstance.isConnected(peripheralInfomation: peripheralInfomation) {
            self.title = baseTitle + " (已连接)"
        } else if peripheralInfomation.authKey == nil {
            authConnect()
        } else {
            self.title = baseTitle + " (连接中)"
        }
        
        guard let list = DeviceDataSource.feature(peripheralName: peripheralInfomation.name!) else {
            DeviceViewController.failTips(title: "警告", subTitle: "当前设备暂不支持")
            return
        }
        
        featureList = list.featureList
        typeList = list.typeList
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observer = BLEStateObserver.init(info: peripheralInfomation)
        observer?.name = String(describing: self)
        observer?.observer = { [weak self] (state, info) in
            guard let strongSelf = self else { return }
            switch state {
            case .connected:
                strongSelf.updateTitle(lastState: " (已连接)")
            case .powerOn:
                strongSelf.updateTitle(lastState: " (蓝牙已打开)")
            case .powerOff:
                strongSelf.updateTitle(lastState: " (蓝牙关闭)")
            case .disConnect(let error):
                print("disConnect error: \(String(describing: error))")
                strongSelf.updateTitle(lastState: " (断开连接)")
            }
            DispatchQueue.main.async { strongSelf.authConnectAlert?.close() }
        }
        BLEConnectManager.sharedInstance.addBLEConnectStateObserver(observer!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let ob = observer else { return }
        BLEConnectManager.sharedInstance.removeBLEConnectStateOberver(ob)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0)]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "scanPeripheral"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier) }
        let type = typeList[indexPath.section]
        if let feature = featureList[type] { cell?.textLabel?.text = feature[indexPath.row].featureName }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return typeList[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = typeList[section]
        let feature = featureList[type]
        return feature!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = typeList[indexPath.section]
        if let feature = featureList[type] { self.perform(feature[indexPath.row].featureAction) }
    }
}

extension DeviceViewController {
    // 空实现
    @objc public func findPeripheralAction() {}
}

extension DeviceViewController {
    func updateTitle(lastState: String) {
        DispatchQueue.main.async {
            self.title = self.baseTitle + lastState
        }
    }
}

extension DeviceViewController {
    static func successTips(title: String, subTitle: String) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 2.0, timeoutAction: {})
        _ = alert.showSuccess(title, subTitle: subTitle, timeout: timeout)
    }
    
    static func failTips(title: String, subTitle: String) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 2.0, timeoutAction: {})
        _ = alert.showError(title, subTitle: subTitle, timeout: timeout)
    }
    
    public func waitAlert(_ title: String, content: String) -> SCLAlertViewResponder {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        return alertView.showWait(title, subTitle: content, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
    }
}
