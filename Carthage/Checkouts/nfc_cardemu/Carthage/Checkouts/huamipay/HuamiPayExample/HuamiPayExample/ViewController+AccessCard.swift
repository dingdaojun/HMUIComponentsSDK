//
//  ViewController+AccessCard.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/7/20.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay


extension ViewController {
    @objc func readUID() {
        do {
            DispatchQueue.main.async {
                ViewController.waitAlert = ViewController.waitAlert("模拟门禁卡", content: "读取卡信息中...")
            }
            
            let tag = try ViewController.pay.miACCloud.readCardTag()
            ViewController.successTips(title: "tag", subTitle: "atqa: \(tag.atqa)\nsak: \(tag.sak)\nuid: \(tag.uid)")
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
            }
        } catch PayError.notMiFare {
            ViewController.failTips(title: "UID失败", subTitle: "非MiFare卡")
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
            }
        } catch {
            print("error: \(error)")
            ViewController.failTips(title: "UID失败", subTitle: "失败原因: \(error)")
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
            }
        }
    }
    
    @objc func copyMiFareCard() {
        do {
            
            DispatchQueue.main.async {
                ViewController.waitAlert = ViewController.waitAlert("模拟门禁卡", content: "读取卡信息中...")
            }
            
            let tag = try ViewController.pay.miACCloud.readCardTag()
            ViewController.successTips(title: "tag", subTitle: "atqa: \(tag.atqa)\nsak: \(tag.sak)\nuid: \(tag.uid)")
            DispatchQueue.main.async {
                ViewController.waitAlert?.setSubTitle("读取卡信息成功，开卡中...")
            }
            
            let param = MIAccessControlOperationParam()
            param.atqa = tag.atqa
            param.sak = tag.sak
            param.uid = tag.uid
            ViewController.pay.miACCloud.installCard(param) { (sessionID, error) in
                
                guard let error = error else {
                    DispatchQueue.main.async {
                        ViewController.waitAlert?.setSubTitle("获取卡信息中...")
                    }
                    
                    ViewController.pay.miACCloud.cardInfomation(with: sessionID!, callback: { (cardInfo, err) in
                        DispatchQueue.main.async {
                            ViewController.waitAlert?.close()
                        }
                        
                        guard let info = cardInfo else {
                            ViewController.failTips(title: "获取卡信息失败", subTitle: "失败原因: \(String(describing: err))")
                            return
                        }
                        
                        ViewController.successTips(title: "卡信息", subTitle: "\(info.aid)\n\(info.art)\n\(info.name)")
                        
                    })
                    
                    return
                }
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
                ViewController.failTips(title: "开卡失败", subTitle: "失败原因: \(error)")
            }
        } catch {
            print("error: \(error)")
            ViewController.failTips(title: "UID失败", subTitle: "失败原因: \(error)")
            DispatchQueue.main.async {
                ViewController.waitAlert?.close()
            }
        }
    }
    
    @objc func getAccessCards() {
        let cardlist = AccessCardListViewController()
        self.navigationController?.pushViewController(cardlist, animated: true)
    }
}
