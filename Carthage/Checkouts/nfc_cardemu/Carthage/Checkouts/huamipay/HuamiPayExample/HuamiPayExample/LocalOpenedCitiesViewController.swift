//
//  LocalOpenedCitiesViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/27.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay

class LocalOpenedCitiesViewController: UIViewController {
    typealias CompleteCallback = () -> Void
    var completeCallback: CompleteCallback?
    
    var openedCities: [PayCityCardInstallInfo] = []
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        self.title = "SE已开通城市"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async {
                    ViewController.waitAlert = ViewController.waitAlert("已安装城市列表", content: "获取已安装城市列表中...")
                }
                
                self.openedCities = try ViewController.pay.se.queryCardListFromDevice()
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
}

extension LocalOpenedCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let cityInfo = openedCities[indexPath.row]
        var cityName = cityInfo.cityName
        if cityInfo.isActivity {
            ViewController.defaultCity = cityInfo.city
            cityName += "    (默认卡)"
        }
        cell?.textLabel?.text = cityName
        
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
