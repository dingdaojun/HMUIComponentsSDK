//
//  AccessCardListViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/7/20.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay
import HMBluetoothKit

class AccessCardListViewController: UIViewController {
    var cardList: [PayACCCard] = []
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        self.title = "门禁卡列表数据"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        getCardList()
    }
    
    func getCardList() {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("门禁卡", content: "刷新列表中...")
        }
        ViewController.pay.miACCloud.accessCardList { (cards, error) in
            DispatchQueue.main.async { ViewController.waitAlert?.close() }
            if error != nil {
                ViewController.failTips(title: "失败", subTitle: "失败原因: \(error!)")
                return
            }
            
            self.cardList = cards as! [PayACCCard]
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
}

extension AccessCardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let info = cardList[indexPath.row]
        let isDefault = try? PayCityBase().isDefault(Data.init(hex: info.aid))
        if isDefault ?? false {
            cell?.textLabel?.text = "\(info.name): 默认卡"
        } else {
            cell?.textLabel?.text = "\(info.name)"
        }
        
        cell?.detailTextLabel?.text = "aid: \(info.aid)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = cardList[indexPath.row]
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        
        _ = alert.addButton("更新名称") {
            self.update(with: info)
        }
        _ = alert.addButton("设置默认卡") {
            self.setDefaultCard(with: Data(hex: info.aid))
        }
        _ = alert.addButton("删卡") {
            self.delete(with: info)
        }
        _ = alert.showEdit("操作", subTitle:"卡操作")
    }
    
    func update(with card: PayACCCard) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        let nameTextField = alert.addTextField("\(card.name)")
        
        _ = alert.addButton("更新") {
            if let name = nameTextField.text {
                var cardInfo = card
                cardInfo.name = name
                DispatchQueue.main.async {
                    ViewController.waitAlert = ViewController.waitAlert("门禁卡", content: "更新卡名称中...")
                }
                ViewController.pay.miACCloud.updateAccessCardInfomation(with: cardInfo, callback: { (error) in
                    DispatchQueue.main.async { ViewController.waitAlert?.close() }
                    if error != nil {
                        ViewController.failTips(title: "失败", subTitle: "失败原因: \(error!)")
                    } else {
                        ViewController.successTips(title: "成功", subTitle: "更新卡名称成功!")
                        self.getCardList()
                    }
                })
            } else {
                ViewController.failTips(title: "失败", subTitle: "卡名称无效")
            }
        }
        
        _ = alert.showEdit("更新", subTitle:"更新卡名称")
    }
    
    func delete(with card: PayACCCard) {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("门禁卡", content: "删卡中...")
        }
        let param = MIAccessControlOperationParam()
        param.aid = card.aid
        ViewController.pay.miACCloud.deleteCard(param) { (error) in
            DispatchQueue.main.async { ViewController.waitAlert?.close() }
            guard let error = error else {
                self.getCardList()
                ViewController.successTips(title: "成功", subTitle: "删卡成功")
                return
            }
            ViewController.failTips(title: "失败", subTitle: "失败原因: \(error)")
            self.setDefaultCard(with: nil)
        }
    }
    
    func setDefaultCard(with aid: Data?) {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("门禁卡", content: "设置默认卡中...")
        }
        
        DispatchQueue.global().async {
            do {
                if let aid = aid {
                    try PayCityBase().setDefault(true, aid: aid)
                    self.getCardList()
                    DispatchQueue.main.async { ViewController.waitAlert?.close() }
                    ViewController.successTips(title: "成功", subTitle: "设置默认卡成功")
                }
                
                if let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: ViewController.infomation!) {
                    try? (profile as! NFCProtocol).swapAid(aid, for: .access)
                }
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
            } catch {
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
            }
        }
    }
}
