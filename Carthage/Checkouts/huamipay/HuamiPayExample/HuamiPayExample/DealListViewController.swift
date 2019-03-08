//
//  DealListViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/30.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay

enum DealSource {
    case se
    case network
}

class DealListViewController: UIViewController {
    var dealList: [DealInfo] = []
    var myTableView: UITableView!
    var source: DealSource = .se
    
    override func viewDidLoad() {
        self.title = "交易数据"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        switch source {
        case .network: deallistFromService(); break;
        case .se: localDeallist(); break;
        }
        
        let sourceItem = UIBarButtonItem(title: "数据源", style: .done, target: self, action: #selector(selectAlert))
        self.navigationItem.rightBarButtonItem = sourceItem
    }
}

extension DealListViewController {
    @objc func selectAlert() {
        let alertCtl : UIAlertController = UIAlertController(title: "提醒", message: "切换数据源", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var seTitle = "SE"
        var serviceTitle = "服务端"
        
        if source == .se {
            seTitle = "\(seTitle)(当前)"
            let uploadAction = UIAlertAction(title: "上传", style: .destructive, handler: { (param : UIAlertAction!) -> Void in
                self.uploadDealInfos()
            })
            alertCtl.addAction(uploadAction)
        } else {
            serviceTitle = "\(serviceTitle)(当前)"
        }
        
        let seAction = UIAlertAction(title: seTitle, style: .default, handler: { (param : UIAlertAction!) -> Void in
            self.localDeallist()
        })
        
        let serviceAction = UIAlertAction(title: serviceTitle, style: .default, handler: { (param : UIAlertAction!) -> Void in
            self.deallistFromService()
        })
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertCtl.addAction(seAction)
        alertCtl.addAction(serviceAction)
        alertCtl.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertCtl, animated: true, completion: nil)
    }
}

extension DealListViewController {
    func localDeallist() {
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async {
                    ViewController.waitAlert = ViewController.waitAlert("本地交易记录", content: "获取本地交易记录中...")
                }
                
                self.dealList = try ViewController.pay.se.dealInfoListFromCard(ViewController.city)
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    self.myTableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    ViewController.failTips(title: "已安装城市列表失败", subTitle: "失败原因: \(error)");
                }
            }
        }
    }
    
    func deallistFromService() {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("服务器交易记录", content: "获取服务器交易记录中...")
        }
        ViewController.pay.hmCloud.dealInfoListFromNetwork(city: ViewController.city, cardNumber: "67741955", nextDate: Date(), limit: 1000) { (infos, nextDate, error) in
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
            }
            guard error == nil else { ViewController.failTips(title: "获取服务器交易记录失败", subTitle: "失败原因: \(String(describing: error))"); return }
            if let s = infos { self.dealList = s }
            
            DispatchQueue.main.async { self.myTableView.reloadData() }
        }
    }
    
    func uploadDealInfos() {
        guard !dealList.isEmpty else {
            ViewController.failTips(title: "上传交易记录", subTitle: "无交易数据")
            return
        }
        
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("上传交易记录", content: "上传交易记录中...")
        }
        ViewController.pay.hmCloud.uploadDealList(city: ViewController.city, cardNumber: "67741955", dealList: dealList) { (error) in
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
            }
            guard error == nil else { ViewController.failTips(title: "上传交易记录失败", subTitle: "失败原因: \(String(describing: error))"); return }
            ViewController.successTips(title: "成功", subTitle: "上传交易记录成功")
        }
    }
}

extension DealListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let info = dealList[indexPath.row]
        switch info.dealType {
        case .localConsumption, .remoteConsumption:
            cell?.textLabel?.text = "消费"
            break
        case .recharge:
            cell?.textLabel?.text = "充值"
            break
        case .openCard:
            cell?.textLabel?.text = "开卡"
            break
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let stringTime = dateFormatter.string(from: info.dealTime)
        cell?.detailTextLabel?.text = "交易时间: \(stringTime)   交易金额: -\(info.dealAmount)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
