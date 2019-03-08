//
//  SNExecApdu.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/30.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay


struct SNExecApdu {
    var order: PayOrderInfo!
    var operationParam: SNOperationParam!
    
    mutating func execApdu(_ orderInfo: PayOrderInfo) {
        order = orderInfo
        
        guard !order.orderNum.isEmpty else {
            ViewController.failTips(title: "失败", subTitle: "订单号不正确");
            return
        }
        
        operationParam = SNOperationParam(city: ViewController.city)
        operationParam.orderNum = order.orderNum
        operationParam.phone = "15855196280"
        
        switch self.order.orderType {
        case .recharge: recharge(); break;
        case .activateCard: activateCard(); break;
        case .all: activateCardAndRecharge(); break;
        }
    }
    
    func recharge() {
        DispatchQueue.main.async { ViewController.waitAlert = ViewController.waitAlert("充值", content: "充值中...") }
        let startDate = Date()
        switch ViewController.tsm {
        case .mi: break
        case .snowball:
            ViewController.pay.snCloud.recharge(operationParam) { (error) in
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
                guard error == nil else { ViewController.failTips(title: "充值失败", subTitle: "失败原因: \(error!)"); return }
                let endDate = Date()
                let timeConsuming = endDate.timeIntervalSince(startDate)
                ViewController.successTips(title: "成功", subTitle: "充值成功: \(String.init(format: "%2.0f", timeConsuming))")
            }
        }
        
    }
    
    func activateCard() {
        DispatchQueue.main.async { ViewController.waitAlert = ViewController.waitAlert("开卡", content: "开卡中...") }
        let startDate = Date()
        switch ViewController.tsm {
        case .mi: break
        case .snowball:
            ViewController.pay.snCloud.issuecard(operationParam) { (error) in
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
                guard error == nil else { ViewController.failTips(title: "开卡失败", subTitle: "失败原因: \(error!)"); return }
                let endDate = Date()
                let timeConsuming = endDate.timeIntervalSince(startDate)
                ViewController.successTips(title: "成功", subTitle: "开卡成功: \(String.init(format: "%2.0f", timeConsuming))")
            }
        }
    }
    
    func activateCardAndRecharge() {
        DispatchQueue.main.async { ViewController.waitAlert = ViewController.waitAlert("开卡+充值", content: "开卡+充值中....") }
        let startDate = Date()
        switch ViewController.tsm {
        case .mi: break
        case .snowball:
            ViewController.pay.snCloud.issuecard(operationParam) { (error) in
                guard error == nil else {
                    DispatchQueue.main.async { ViewController.waitAlert?.close() }
                    ViewController.failTips(title: "开卡失败", subTitle: "失败原因: \(error!)")
                    return
                }
                
                ViewController.pay.snCloud.recharge(self.operationParam, callback: { (error) in
                    DispatchQueue.main.async { ViewController.waitAlert?.close() }
                    guard error == nil else { ViewController.failTips(title: "充值失败", subTitle: "失败原因: \(error!)"); return }
                    let endDate = Date()
                    let timeConsuming = endDate.timeIntervalSince(startDate)
                    ViewController.successTips(title: "成功", subTitle: "开卡充值成功: \(String.init(format: "%2.0f", timeConsuming))")
                })
            }
        }
    }
}
