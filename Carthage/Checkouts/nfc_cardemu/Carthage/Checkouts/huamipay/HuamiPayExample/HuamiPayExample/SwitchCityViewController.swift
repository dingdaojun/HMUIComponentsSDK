//
//  CityListViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay


class SwitchCityViewController: UIViewController {
    typealias CompleteCallback = () -> Void
    var completeCallback: CompleteCallback?
    var cities: [PayCityInfo] = PayCity.all
    
    override func viewDidLoad() {
        self.title = "huamipay支持城市"
        let myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
    }
}


extension SwitchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let city = cities[indexPath.row]
        if city.city == ViewController.city { cell?.accessoryType = .checkmark }
        cell?.textLabel?.text = city.name
        cell?.detailTextLabel?.text = "AID: \(city.aid.toHexString())"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        ViewController.city = city.city
        completeCallback!()
        ViewController.successTips(title: "成功", subTitle: "已切换到: \(city.name)")
        self.navigationController?.popViewController(animated: true)
    }
}
