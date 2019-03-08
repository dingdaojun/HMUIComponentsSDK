//
//  ViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/2/2.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import UIKit
import HMBluetoothKit
import CryptoSwift
import WalletService
import HMPayKit
import huamipay

enum ServiceEvn: String {
    case staging = "https://api-mifit-staging.huami.com/"
    case stagingNFC = "http://mifit-device-service-staging-nfc.mi-ae.net/"
    case line = "https://api-mifit.huami.com/"
    
    var name: String {
        switch self {
        case .staging:
            return "测试环境"
        case .stagingNFC:
            return "NFC测试环境"
        case .line:
            return "正式环境"
        }
    }
}

class ViewController: UIViewController {
    static var userid: String {
        get {
            switch ViewController.serviceEvn {
            case .line:
                return "1005823644"
            case .staging, .stagingNFC:
                return "1010628081"
            }
        }
    }
    static var token: String {
        get {
            switch ViewController.serviceEvn {
            case .line:
                return "CQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAADh78_0tGMDt8_en1LtjsHY-IApiMH0syLyptpeIcDgXX8GTkP2tFri1BQA-RdcNiXihpOjLeYL0gHG7Nf9tQG-5adO2goixP0AUPzYk4D5Yy8ya2DjBugnsR02ZNMhgVDwsLo_Gxek2TRzz24c_jrQoFnp3FfRH9UMR9owvRryE"
            case .staging, .stagingNFC:
                return "cQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAAIAANxTG4wVguiA8M4uMxavXRgj3Kb1DrEWr7ZG7KCnAakga0h6ASZYaroz5--1i3WbB-0VvtXBwsMFI02PrQv7AT3bOdprvVWJeOgNJceTY782B5dC9eQjk3F4fIZKbnEX1ph9WxXrWYYNSnzok03n0AqO_KN-9eTLUZ1h3YkJo"
            }
        }
    }
    public static var sn: String?
    public static var cplc: String?
    public static var module: String = ""
    public static var serviceEvn = ServiceEvn.stagingNFC
    public static var tsm: SupportTSM = .snowball
    public static var city = PayCity.hefei
    public static var defaultCity: PayCity?
    public static var infomation: HMPeripheralInfomation?
    public static var waitAlert: SCLAlertViewResponder?
    public static var pay: HuamiPay!
    
    public var switchResponse: SCLAlertViewResponder?
    public var totalTime: TimeInterval = 0.0
    public var miPayResponse: SCLAlertViewResponder?
    @IBOutlet weak var speedTextView: UITextView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var currentCityLabel: UILabel!
    
    public var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let y = speedTextView.frame.size.height + 80
        myTableView = UITableView(frame: CGRect(x: 0, y: y, width: self.view.frame.size.width, height: self.view.frame.size.height - y), style: .grouped)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .singleLine
        myTableView.allowsSelection = true
        myTableView.allowsMultipleSelection = false
        self.view.addSubview(myTableView)
        
        ViewController.city = .wuhan
        ViewController.pay = HuamiPay(with: self, service: HMServiceAPI.nfcService())

        DispatchQueue.main.asyncAfter(deadline: 1) { self.connect() }
        updateCity(payCity: ViewController.city)
        self.title = "Huamipay"
    }
}
