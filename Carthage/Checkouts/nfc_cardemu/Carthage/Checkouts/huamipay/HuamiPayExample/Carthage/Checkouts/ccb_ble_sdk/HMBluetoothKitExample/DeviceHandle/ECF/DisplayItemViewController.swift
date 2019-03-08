//
//  DisplayItemViewController.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/7/18.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMBluetoothKit

enum DispayItem: Int {
    case step = 1
    case distance = 2
    case consume = 4
    case heartRate = 8
    case battery = 16
    
    static var allDisplay: [(DispayItem, String)] {
        return [(.step, "步数"),
                (.distance, "距离"),
                (.consume, "卡路里"),
                (.heartRate, "心率"),
                (.battery, "电池")]
    }
}


class DisplayItemViewController: UIViewController {
    var myTableView: UITableView!
    var displayItems = DispayItem.allDisplay
    var infomation: HMPeripheralInfomation!
    
    override func viewDidLoad() {
        self.title = "ECF Display Setting"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        let filterItem = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(getSelectRows))
        self.navigationItem.rightBarButtonItems = [filterItem]
    }
    
    @objc func getSelectRows() {
        // 获取 tableView 被 select 的 row,是一个数组
        guard let selecteRows = myTableView.indexPathsForSelectedRows else {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "失败", subTitle: "未选择")
            }
            return
        }
        var displayOptions = 0
        for indexPath in selecteRows {
            let item = displayItems[indexPath.row].0
            displayOptions = displayOptions ^ item.rawValue
        }
        
        setECF(with: displayOptions, for: .displayItem)
    }
}

extension DisplayItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") }
        cell?.textLabel?.text = displayItems[indexPath.row].1
        
        //判断是否选中,如果 tableView有 select 的 row ,就把 cell 标记checkmark
        if let _ = tableView.indexPathsForSelectedRows?.index(of: indexPath){
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems.count
    }
    
    // 选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    // 取消选中
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    func setECF(with value: Int, for type: ECFType) {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: infomation) else { return }
        
        do {
            try (profile as! ECFProtocol).setECF(with: value, for: type)
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "设置成功")
            }
        } catch  {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "失败", subTitle: "设置失败")
            }
        }
    }
}
