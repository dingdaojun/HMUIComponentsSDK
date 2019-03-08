//
//  ViewController.swift
//  HMNFCCardemuExample
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import HMNFCCardemu
import HMBluetoothKit
import CryptoSwift
import WalletService
import huamipay
import HMService

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
                return "1000330723"
            case .staging, .stagingNFC:
                return "1010628081"
            }
        }
    }
    static var token: String {
        get {
            switch ViewController.serviceEvn {
            case .line:
                return "CQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAACsApPq8ORYtrDwNildD66KcEqAc--yjWFFlKJkezvz2KeTG4BVP7fHclSEQF4aVHMEkkDUWek8ejy_kaLscI62JwwbHtgs2kDsme9I11mF3cBPNJK3aIlAu2d-74FH9ukQfcuXjO5Yy8ATHPYSpr612T_su2VfyfIXkOsIjbMQT"
            case .staging, .stagingNFC:
                return
            "cQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAAB3BrE8PAxJaWJutQC8wBk6hCzcwVjDtuJOtRVaOxXfFmCOdcuw8d3VoOJvKE8meHC2LOrulaGE5ozowMh20NRIFpoPR9vOUH9ubI2KMXI1EX0uuM_34RdGa-Pla6Es5Oz_qIA5lPEEqMn2UsWJC2iQ5TP8LpBCkM8Wv7Ba7KvvD"
            }
        }
    }
    public static var sn: String?
    public static var cplc: String?
    public static var module: String = ""
    public static var serviceEvn = ServiceEvn.line
    public static var tsm: SupportTSM = .snowball
    public static var city = PayCity.hefei
    public static var defaultCity: PayCity?
    public static var infomation: HMPeripheralInfomation?
    public static var waitAlert: SCLAlertViewResponder?
    public static var pay: HuamiPay!
    
    public var switchResponse: SCLAlertViewResponder?
    public var totalTime: TimeInterval = 0.0
    public var miPayResponse: SCLAlertViewResponder?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true;
        
        ViewController.pay = HuamiPay(with: self, service: HMServiceAPI.defaultService())
        
        DispatchQueue.main.asyncAfter(deadline: 1) { self.connect() }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cplcButtonClick(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: 1) { self.connect() }
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        PublicInterface.shared.interfaceEntrance(nfc: self, service: HMServiceAPI.defaultService(), delegate: self) { vc, error in
            guard let nextVC = vc else {
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @IBAction func startButtonClick(_ sender: UIButton) {
        let scan = ScanTableViewController(style: .plain)
        self.navigationController?.pushViewController(scan, animated: true)
    }
}

extension ViewController: HMNFCCardemuDelegate {
    func swapDefaultCard(actionType: UInt8, aid: String?) {
        print("swapDefaultCard")
    }
}

