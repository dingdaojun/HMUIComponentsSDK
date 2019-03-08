//
//  StartDetectionViewController.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import UIKit
import huamipay
import HMService
import HMBluetoothKit

class StartDetectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(withType: .Loading, title: "正在检测")
        PublicInterface.shared.operationQueue.addOperation {
            do {
                let cardTag = try PublicInterface.shared.pay?.miACCloud.readCardTag()
                
                guard cardTag != nil else {
                    DispatchQueue.main.async {
                        HUD.show(withType: .Error, title: "检测失败")
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    return
                }
              
                let vc : DetectionSuccessViewController = UIStoryboard.init(openCard: .Detection).instantiate()
                vc.cardTag = cardTag!
                
                DispatchQueue.main.async {
                    HUD.hide()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch PayError.notMiFare {
                let alertController: UIAlertController = UIAlertController.init(title: "", message: "不支持该类型卡", preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "我知道了", style: .default) { action  -> Void in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                alertController.addAction(okAction)
                
                DispatchQueue.main.async {
                    HUD.hide()
                    self.present(alertController, animated: true, completion: nil)
                }
                return;
            } catch {
                DispatchQueue.main.async {
                    HUD.hide()
                    HUD.show(withType: .Error, title: "检测失败")
                    self.navigationController?.popViewController(animated: true)
                }
                return;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func supportButtonClick(_ sender: UIButton) {
        let vc : SupportDescriptionViewController = UIStoryboard.init(openCard: .Detection).instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
