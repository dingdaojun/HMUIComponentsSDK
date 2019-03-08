//
//  ViewController+TableView.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/12.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import UIKit
import HMBluetoothKit
import huamipay

public struct Feature {
    enum FeatureType {
        case swicthCity
        case swicthBand
        case addBand
        case deleteBand
        case order
        case apdu
        case transactionRecord
        case orderList
        case cardInfo
        case deleteCard
        case setDefault
        case seCardList
        case cplc
        case deviceID
        case openedCityList
        case supportCityList
        case battery
        case readPhone
        case env
        case uid
    }
    
    var name: String = ""
    var type: FeatureType
    let selector: Selector
    
    init(name: String, type: FeatureType, selector: Selector) {
        self.name = name
        self.type = type
        self.selector = selector
    }
    
    init(type: FeatureType, selector: Selector) {
        self.type = type
        self.selector = selector
        
        if type == .env {
            name = "\(ViewController.serviceEvn.name)"
        }
    }
}

enum FeatureClass: String {
    case cardOperation = "卡操作"
    case network = "网络接口"
    case bandInfo = "手环信息"
    case band = "手环"
    case env = "当前环境"
    case cardSimulation = "门禁卡"
    
    static var list: [FeatureClass] {
        get {
            return [FeatureClass.env,
                    FeatureClass.network,
                    FeatureClass.cardOperation,
                    FeatureClass.cardSimulation,
                    FeatureClass.bandInfo,
                    FeatureClass.band]
        }
    }
}

extension ViewController {
    var features: [FeatureClass: [Feature]] {
        get {
            return [
                FeatureClass.env: [
                    Feature(type: .env, selector: #selector(ViewController.switchEvn))
                ],
                FeatureClass.cardSimulation: [
                    Feature(name: "读取门禁卡", type: .uid, selector: #selector(ViewController.readUID)),
                    Feature(name: "复制门禁卡", type: .uid, selector: #selector(ViewController.copyMiFareCard)),
                    Feature(name: "获取门禁卡列表数据", type: .uid, selector: #selector(ViewController.getAccessCards)),
                ],
                FeatureClass.network: [
                    Feature(name: "已开通城市列表", type: .openedCityList, selector: #selector(ViewController.readOpenedCardListFromNetwork)),
                    Feature(name: "支持城市列表", type: .supportCityList, selector: #selector(ViewController.supportCityList)),
                    Feature(name: "手机号", type: .readPhone, selector: #selector(ViewController.readMobile)),
                    Feature(name: "协议数据", type: .readPhone, selector: #selector(ViewController.fetchProtocol)),],
                FeatureClass.cardOperation: [
                    Feature(name: "SE卡列表查询", type: .seCardList, selector: #selector(ViewController.queryCardListFromDevice)),
                    Feature(name: "城市卡详情", type: .cardInfo, selector: #selector(ViewController.cardInfo)),
                    Feature(name: "设置默认卡", type: .setDefault, selector: #selector(ViewController.setDefault)),
                    Feature(name: "开卡/充值", type: .order, selector: #selector(ViewController.selectOrderType)),
                    Feature(name: "交易记录", type: .transactionRecord, selector: #selector(ViewController.readDealList)),
                    Feature(name: "订单列表", type: .orderList, selector: #selector(ViewController.readOrderList)),
                    Feature(name: "删卡", type: .deleteCard, selector: #selector(ViewController.deleteCard)),
                    Feature(name: "切换城市", type: .swicthCity, selector: #selector(ViewController.switchCity)),],
               FeatureClass.bandInfo: [
                    Feature(name: "电量", type: .battery, selector: #selector(ViewController.readBattery)),
                    Feature(name: "cplc", type: .cplc, selector: #selector(ViewController.getCPLC)),
                    Feature(name: "deviceID", type: .deviceID, selector: #selector(ViewController.getDeviceID)),],
               FeatureClass.band: [
                    Feature(name: "添加手环", type: .addBand, selector: #selector(ViewController.addBand)),
                    Feature(name: "切换手环", type: .swicthBand, selector: #selector(ViewController.switchBand))],]
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let type = FeatureClass.list[indexPath.section]
        if let feature = features[type] { cell?.textLabel?.text = feature[indexPath.row].name }
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FeatureClass.list.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FeatureClass.list[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = FeatureClass.list[section]
        return features[type]!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = FeatureClass.list[indexPath.section]
        if let feature = features[type] { self.perform(feature[indexPath.row].selector) }
    }
}

extension ViewController {
    @objc func readOrderList() {
        let orderlist = OrderListViewController()
        self.navigationController?.pushViewController(orderlist, animated: true)
    }
    
    @objc func switchBand() {
        let bandlist = BandListViewController()
        bandlist.currentInfomation = ViewController.infomation
        bandlist.completeCallback = { (info) in
            ViewController.infomation = info
            self.getCplc()
            
            if let mac = ViewController.infomation?.deviceInfomation?.macAddress,
               let name = ViewController.infomation?.name {
                DispatchQueue.main.async {
                    self.title = name
                    self.stateLabel.text = "设备: \(mac)"
                }
            }
        }
        bandlist.deleteCallback = {
            if ViewController.infomation == nil {
                ViewController.cplc = nil
                ViewController.sn = nil
                DispatchQueue.main.async {
                    self.title = "无设备"
                    self.stateLabel.text = "无设备"
                }
            }
        }
        self.navigationController?.title = "切换手环"
        self.navigationController?.pushViewController(bandlist, animated: true)
    }
    
    @objc func switchCity() {
        let switchCity = SwitchCityViewController()
        switchCity.completeCallback = {
            self.updateCity(payCity: ViewController.city)
        }
        self.navigationController?.pushViewController(switchCity, animated: true)
    }
    
    @objc func selectOrderType() {
        let feelist = FeeListViewController()
        self.navigationController?.pushViewController(feelist, animated: true)
    }
    
    @objc func addBand() {
        let scan = ScanTableViewController(style: .plain)
        self.navigationController?.pushViewController(scan, animated: true)
    }
    
    @objc func readDealList() {
        let deallist = DealListViewController()
        self.navigationController?.pushViewController(deallist, animated: true)
    }
    
    @objc func fetchProtocol() {
        switch ViewController.tsm {
        case .mi:
            ViewController.pay.miCloud.fetchProtocol(for: ViewController.city, with: .charge) { (protool, error) in
                if let pro = protool {
                    ViewController.successTips(title: "成功", subTitle: "\(pro.title)\n协议ID: \(pro.identifier)")
                    return
                }
                
                ViewController.failTips(title: "失败", subTitle: "获取协议数据失败")
            }
        case .snowball:
            ViewController.pay.snCloud.fetchProtocol(for: ViewController.city, with: .charge) { (protool, error) in
                if let pro = protool {
                    ViewController.successTips(title: "成功", subTitle: "\(pro.title)\n协议ID: \(pro.identifier)")
                    return
                }
                
                ViewController.failTips(title: "失败", subTitle: "获取协议数据失败")
            }
        }
    }
    
    @objc func switchEvn() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            var env = ServiceEvn.line
            var name = env.name
            if env == ViewController.serviceEvn { name = "\(name)(当前环境)" }
            alert.addButton(name, action: {
                ViewController.serviceEvn = .line
                DispatchQueue.main.async { self.myTableView.reloadData() }
            })
            
            env = ServiceEvn.staging
            name = env.name
            if env == ViewController.serviceEvn { name = "\(name)(当前环境)" }
            alert.addButton(name, action: {
                ViewController.serviceEvn = .staging
                DispatchQueue.main.async { self.myTableView.reloadData() }
            })
            
            env = ServiceEvn.stagingNFC
            name = env.name
            if env == ViewController.serviceEvn { name = "\(name)(当前环境)" }
            alert.addButton(name, action: {
                ViewController.serviceEvn = .stagingNFC
                DispatchQueue.main.async { self.myTableView.reloadData() }
            })
            _ = alert.showNotice("确认", subTitle: "是否确认删卡")
        }
    }
}
