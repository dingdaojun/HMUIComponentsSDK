//
//  ECFViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/7/18.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit


struct ECFDataSource {
    let name: String
    let type: ECFType
    
    static var allTypes: [ECFDataSource] {
        return [ECFDataSource(name: "蓝牙广播", type: .advertisement),
                ECFDataSource(name: "时间制度", type: .timeFormat),
                ECFDataSource(name: "里程单位", type: .mileAgeUnit),
                ECFDataSource(name: "抬腕亮屏", type: .wristBright),
                ECFDataSource(name: "时间样式", type: .timeDisplay),
                ECFDataSource(name: "转腕切屏", type: .wristFlip),
                ECFDataSource(name: "目标步数", type: .goalReminder),
                ECFDataSource(name: "显示选项", type: .displayItem)]
    }
}


class ECFViewController: UIViewController {
    var myTableView: UITableView!
    var ecfTypes = ECFDataSource.allTypes
    var infomation: HMPeripheralInfomation!
    
    override func viewDidLoad() {
        self.title = "ECF Setting"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
    }
}

extension ECFViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") }
        cell?.textLabel?.text = ecfTypes[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ecfTypes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = ecfTypes[indexPath.row].type
        switch type {
        case .advertisement:
            alertView(for: .advertisement, btnTitle: "开启", value: "1", otherBtnTitle: "关闭", otherValue: "0", title: "蓝牙广播", subTitle: "设置开启或者关闭")
            break
        case .mileAgeUnit:
            alertView(for: .mileAgeUnit, btnTitle: "公里", value: "1", otherBtnTitle: "英里", otherValue: "0", title: "里程单位", subTitle: "设置为公里或者英里")
            break
        case .timeDisplay:
            alertView(for: .timeDisplay, btnTitle: "时间", value: "0", otherBtnTitle: "时间+日期", otherValue: "1", title: "时间样式", subTitle: "设置只显示时间或者显示时间和日期")
            break
        case .timeFormat:
            alertView(for: .timeFormat, btnTitle: "12小时制", value: "0", otherBtnTitle: "24小时制", otherValue: "1", title: "时间制度", subTitle: "设置为12/24小时制")
            break
        case .wristBright:
            alertView(for: .wristBright, btnTitle: "开启", value: "1", otherBtnTitle: "关闭", otherValue: "0", title: "抬腕亮屏", subTitle: "设置开启或者关闭")
            break
        case .wristFlip:
            alertView(for: .wristFlip, btnTitle: "开启", value: "1", otherBtnTitle: "关闭", otherValue: "0", title: "转腕切屏", subTitle: "设置开启或者关闭")
            break
        case .goalReminder:
            goalSetting()
            break
        case .displayItem:
            let display = DisplayItemViewController()
            display.infomation = infomation
            self.navigationController?.pushViewController(display, animated: true)
            break
        }
    }
    
    private func alertView(for type: ECFType, btnTitle: String, value: String, otherBtnTitle: String, otherValue: String, title: String, subTitle: String) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton(btnTitle) {
                self.setECF(with: Int(value)!, for: type)
            }
            _ = alert.addButton(otherBtnTitle) {
                self.setECF(with: Int(otherValue)!, for: type)
            }
            _ = alert.showEdit(title, subTitle: subTitle)
        }
    }
    
    func setECF(with value: Int, for type: ECFType) {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: infomation) else { return }
        
        do {
            try (profile as! ECFProtocol).setECF(with: value, for: type)
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "设置成功")
            }
        } catch  {
            print("error: \(error)")
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "失败", subTitle: "设置失败")
            }
        }
    }
    
    private func goalSetting() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let goalTextField = alert.addTextField("目标步数")
            goalTextField.keyboardType = .phonePad
            _ = alert.addButton("设置目标值") {
                if let v = goalTextField.text {
                    if let intValue = Int(v) {
                        self.setECF(with: intValue, for: .goalReminder)
                    }
                }
            }
            _ = alert.showEdit("设置目标", subTitle: "设置目标步数")
        }
    }
}
