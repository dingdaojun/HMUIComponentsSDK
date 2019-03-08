//
//  ViewController+UpdateCity.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/4/2.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay


extension ViewController {
    func updateCity(payCity: PayCity) {
        ViewController.city = payCity
        currentCityLabel.text = "当前城市: \(ViewController.city.info.name)"
    }
}
     
