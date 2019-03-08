//
//  OpenedCitiesViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay

class OpenedCitiesViewController: UIViewController {
    typealias CompleteCallback = () -> Void
    var completeCallback: CompleteCallback?
    
    var openedCities: [PayCityCardInfo] = []
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        self.title = "云端已开通城市"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        guard let deviceID = ViewController.infomation?.deviceInfomation?.deviceID else {
            return
        }
        
        switch ViewController.tsm {
        case .snowball:
            ViewController.pay.snCloud.openedCityList(with: deviceID) { (infos, error) in
                self.showlist(infos, error: error)
            }
        case .mi:
            ViewController.pay.miCloud.openedCityList(with: deviceID) { (infos, error) in
                self.showlist(infos, error: error)
            }
        }
    }
}

extension OpenedCitiesViewController {
    func showlist(_ infos: [PayCityCardInfo]?, error: PayError?) {
        guard error == nil,
            let cities = infos else { ViewController.failTips(title: "查询已开通卡列表失败", subTitle: "失败原因: \(error!)"); return }
        
        openedCities = cities
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
}

extension OpenedCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let cityInfo = openedCities[indexPath.row]
        cell?.textLabel?.text = cityInfo.name
        
        if cityInfo.city == ViewController.city {
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
        return openedCities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityInfo = openedCities[indexPath.row]
        ViewController.city = cityInfo.city
        completeCallback!()
        ViewController.successTips(title: "成功", subTitle: "已切换到: \(cityInfo.cityName)")
        self.navigationController?.popViewController(animated: true)
    }
}
