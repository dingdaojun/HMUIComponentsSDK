//
//  MIExecApdu.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/30.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay


struct MIExecApdu {
    var order: PayOrderInfo!
    var operationParam: MIOperationParam!
    var issueCardToken: PayOrderInfo.ActionToken?
    var chargeToken: PayOrderInfo.ActionToken?
    var protocolID: String?
    
    mutating func execApdu(_ orderInfo: PayOrderInfo) {
        order = orderInfo
        
        guard let tokens = orderInfo.tokens else { ViewController.failTips(title: "订单详情", subTitle: "无有效token"); return }
        
        if let openCardToken = tokens.filter({ return $0.type == PayOrderInfo.ActionType.openCard }).first {
            self.issueCardToken = openCardToken
        }
        
        if let chargeToken = tokens.filter({ return $0.type == PayOrderInfo.ActionType.charge }).first {
            self.chargeToken = chargeToken
        }
        
        if let token = issueCardToken?.token {
            issuecard(MIOperationParam(token: token, in: ViewController.city))
        } else if let token = chargeToken?.token {
            charge(MIOperationParam(token: token, in: ViewController.city))
        }
    }
    
    func issuecard(_ issuecardParam: MIOperationParam) {
        guard let proID = protocolID else {
            ViewController.failTips(title: "失败", subTitle: "开卡操作，必须有协议ID")
            return
        }
        issuecardParam.protocolID = proID
        let startDate = Date()
        DispatchQueue.main.async { ViewController.waitAlert? = ViewController.waitAlert("Loading", content: "开卡中....") }
        ViewController.pay.miCloud.issuecard(issuecardParam) { (error) in
            DispatchQueue.main.async { ViewController.waitAlert?.close() }
            guard error == nil else { ViewController.failTips(title: "开卡失败", subTitle: "失败原因: \(error!)"); return }
            let endDate = Date()
            let timeConsuming = endDate.timeIntervalSince(startDate)
            ViewController.successTips(title: "成功", subTitle: "开卡成功: \(String.init(format: "%2.0f", timeConsuming))")
            
            guard let token = self.chargeToken?.token else { DispatchQueue.main.async { ViewController.waitAlert?.close() }; return; }
            self.charge(MIOperationParam(token: token, in: ViewController.city))
        }
    }
    
    func charge(_ chargeParam: MIOperationParam) {
        let startDate = Date()
        DispatchQueue.main.async { ViewController.waitAlert? = ViewController.waitAlert("Loading", content: "充值中....") }
        ViewController.pay.miCloud.recharge(chargeParam, callback: { (err) in
            DispatchQueue.main.async { ViewController.waitAlert?.close() }
            guard err == nil else { ViewController.failTips(title: "充值失败", subTitle: "失败原因: \(err!)"); return }
            let endDate = Date()
            let timeConsuming = endDate.timeIntervalSince(startDate)
            ViewController.successTips(title: "成功", subTitle: "充值成功: \(String.init(format: "%2.0f", timeConsuming))")
        })
    }
}
