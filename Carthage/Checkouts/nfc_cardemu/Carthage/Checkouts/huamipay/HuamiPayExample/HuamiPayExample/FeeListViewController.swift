//
//  FeeListViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/27.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay
import HMPayKit

class FeeListViewController: UIViewController {
    typealias CompleteCallback = () -> Void
    var completeCallback: CompleteCallback?
    var payOrderFee: PayOrderFee!
    var fees: [PayOrderFee.Fee] = []
    var fee: PayOrderFee.Fee!
    var orderType: PayOrderType = .all
    var myTableView: UITableView!
    var orderNum: String!
    var payMoney: Int = 0
    var orderTypeDes: String = ""
    var protocolID: String?
    
    override func viewDidLoad() {
        self.title = "查询费用"
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("开卡") {
            self.orderTypeDes = "开卡"
            self.orderType = .activateCard
            self.queryFee()
            self.queryProtocols()
        }
        
        _ = alert.addButton("充值", action: {
            self.orderTypeDes = "充值"
            self.orderType = .recharge
            self.queryFee()
            self.queryProtocols()
        })
        
        _ = alert.addButton("开卡+充值", action: {
            self.orderTypeDes = "开卡+充值"
            self.orderType = .all
            self.queryFee()
            self.queryProtocols()
        })
        
        _ = alert.showEdit("选择要生成订单", subTitle:"选择要生成的订单")
    }
}

extension FeeListViewController {
    func queryFee() {
        switch ViewController.tsm {
        case .mi:
            ViewController.pay.miCloud.queryRelativeCost(orderType, inCity: ViewController.city) { (fee, error) in
                guard error == nil else { ViewController.failTips(title: "获取费用失败", subTitle: "查询相关费用出错: \(error!)"); return }
                guard let orderFee = fee else { ViewController.failTips(title: "获取费用失败", subTitle: "费用fee不存在)"); return }
                DispatchQueue.main.async {
                    self.payOrderFee = orderFee
                    self.fees = orderFee.fees
                    self.myTableView.reloadData()
                }
            }
            break
        case .snowball:
            ViewController.pay.snCloud.queryRelativeCost(orderType, inCity: ViewController.city) { (fee, error) in
                guard error == nil else { ViewController.failTips(title: "获取费用失败", subTitle: "查询相关费用出错: \(error!)"); return }
                guard let orderFee = fee else { ViewController.failTips(title: "获取费用失败", subTitle: "费用fee不存在)"); return }
                DispatchQueue.main.async {
                    self.payOrderFee = orderFee
                    self.fees = orderFee.fees
                    self.myTableView.reloadData()
                }
            }
            break
        }
    }
    
    func queryProtocols() {
        var actionType: PayProtocolActionType = .issue
        if orderType == .recharge { actionType = .charge }
        
        switch ViewController.tsm {
        case .mi:
            ViewController.pay.miCloud.fetchProtocol(for: ViewController.city, with: actionType) { (protool, error) in
                if let pro = protool {
                    self.protocolID = pro.identifier
                    return
                }
                
                ViewController.failTips(title: "失败", subTitle: "获取协议数据失败")
            }
        case .snowball:
            ViewController.pay.snCloud.fetchProtocol(for: ViewController.city, with: actionType) { (protool, error) in
                if let pro = protool {
                    self.protocolID = pro.identifier
                    return
                }
                
                ViewController.failTips(title: "失败", subTitle: "获取协议数据失败")
            }
        }
    }
}

extension FeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let fee = payOrderFee.fees[indexPath.row]
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.textLabel?.text = "\(orderTypeDes) 实际支付: \(fee.discountCharge + fee.discountOpenCard)"
        cell?.detailTextLabel?.text = "开卡: \(fee.normalOpenCard); 优惠: \(fee.discountOpenCard)\n充值: \(fee.normalCharge); 优惠: \(fee.discountCharge)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fees.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ViewController.tsm == .mi,
           orderType == .all,
           protocolID == nil {
            ViewController.failTips(title: "失败", subTitle: "开卡，协议不能为空")
            return
        }
        
        fee = fees[indexPath.row]
        payMoney = fee.discountCharge + fee.discountOpenCard
        switch ViewController.tsm {
        case .mi:
            ViewController.pay.miCloud.generateOrder(fee.feeID, in: ViewController.city, with: nil) { (result, error) in
                guard error == nil else { ViewController.failTips(title: "生成订单失败", subTitle: "原因: \(error!)"); return }
                self.orderNum = result?.orderNum
                guard self.payMoney != 0 else { self.orderDetail(with: result!.orderNum); return; }
                self.payWebView(result!.payURL!, returnUrl: result?.returnURL)
            }
            break
        case .snowball:
            payForSelectChannel()
            break
        }
    }
}

// MARK: - 雪球
extension FeeListViewController {
    func payForSelectChannel() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("支付宝") { self.payChannel(.alipay) }
        _ = alert.addButton("微信", action: { self.payChannel(.wechat) })
        _ = alert.addButton("支付宝(测试环境使用...)", action: { self.payChannel(.testAlipay) })
        let _ = alert.showEdit("选择支付方式", subTitle:"选择支付方式")
    }
    
    public func payChannel(_ channel: PayChannel) {
        let startDate = Date()
        ViewController.pay.snCloud.generateOrder(orderType, inCity: ViewController.city, payChannel: channel, payAmount: payMoney, callback: { (result, error) in
            guard error == nil else { ViewController.failTips(title: "订单生成失败", subTitle: "\(error!)"); return; }
            if let num = result?.orderNum { self.orderNum = num }
            var order = HMPayOrderTester()
            let endDate = Date()
            let timeConsuming = endDate.timeIntervalSince(startDate)
            DispatchQueue.main.async { ViewController.successTips(title: "成功(\(String.init(format: "%2.3f", timeConsuming))s)", subTitle: "生成订单成功") }
            var payChannel: HMPayType = .wxPay
            switch channel {
            case .alipay, .testAlipay:
                order.ali_signChargeStr = result?.signed
                payChannel = .aliPay
            case .wechat:
                guard let wxOrder = HMPayOrderTester.wxTester(result!.signed) else {
                    ViewController.failTips(title: "订单生成失败", subTitle: "\(String(describing: result?.signed))")
                    return
                }
                order = wxOrder
                break
            }
            
            HMPay.default().pay(payChannel, order: order) { (status, orderInfo, error) in
                switch status {
                case .success:
                    var orderDetail = PayOrderInfo()
                    orderDetail.orderNum = self.orderNum
                    orderDetail.orderType = self.orderType
                    var execApdu = SNExecApdu()
                    execApdu.execApdu(orderDetail)
                    break;
                case .cancel: ViewController.failTips(title: "支付失败", subTitle: "取消支付"); break;
                case .failure: ViewController.failTips(title: "支付失败", subTitle: "支付失败"); break;
                default: print("pay other \(status)"); break;
                }
            }
        })
    }
}

// MARK: - 小米的开卡充值操作
extension FeeListViewController {
    func payWebView(_ url: URL, returnUrl: String?) {
        DispatchQueue.main.async {
            let payContrller = PayWebViewController()
            payContrller.payURL = url
            payContrller.returnUrl = returnUrl
            self.navigationController?.pushViewController(payContrller, animated: true)
            
            payContrller.completeCallback = {
                self.orderDetail(with: self.orderNum)
            }
        }
    }
    
    func orderDetail(with orderNum: String) {
        switch ViewController.tsm {
        case .mi:
            DispatchQueue.main.async {
                ViewController.waitAlert = ViewController.waitAlert("Loading", content: "查询订单中...")
            }
            ViewController.pay.miCloud.orderInfo(orderNum: orderNum) { (info, error) in
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                }
                guard error == nil,
                    let orderInfo = info else
                {
                    DispatchQueue.main.async { ViewController.waitAlert?.close() }
                    ViewController.failTips(title: "订单详情失败", subTitle: "原因: \(error!)");
                    return
                }
                
                var execApdu = MIExecApdu()
                execApdu.protocolID = self.protocolID
                execApdu.execApdu(orderInfo)
            }
            break
        case .snowball: break;
        }
    }
}

