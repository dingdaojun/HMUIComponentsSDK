//
//  OrderListViewController.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/6/26.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import huamipay


class OrderListViewController: UIViewController {
    var orders: [PayOrderInfo] = []
    var protocolID: String?
    
    override func viewDidLoad() {
        self.title = "订单列表"
        let myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("订单列表", content: "获取订单列表中...")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let dateTime = dateFormatter.date(from: "1971-03-01 00:00:00")!

        switch ViewController.tsm {
        case .snowball:
            ViewController.pay.snCloud.ordersList(from: dateTime, to: Date(), orderState: .all, city: ViewController.city) { (infos, error) in
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    self.orders = infos
                    myTableView.reloadData()
                }
            }
            break
        case .mi:
            ViewController.pay.miCloud.ordersList(with: ViewController.city) { (infos, error) in
                DispatchQueue.main.async {
                    ViewController.waitAlert?.close()
                    self.orders = infos
                    myTableView.reloadData()
                }
            }
        }
    }
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let orderInfo = orders[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let stringTime = dateFormatter.string(from: orderInfo.orderTime)
        let infoString = "订单号: \(orderInfo.orderNum)\n订单状态:\(orderInfo.orderState)\n订单说明: \(orderInfo.orderStateDec)\n订单金额: \(orderInfo.orderAmount)\n订单时间: \(stringTime)\n支付流水号: \(orderInfo.payNum ?? "")"
        
        switch orderInfo.orderType {
        case .activateCard: cell?.textLabel?.text = "开卡"; break;
        case .recharge: cell?.textLabel?.text = "充值"; break;
        case .all: cell?.textLabel?.text = "开卡+充值"; break;
        }
        
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.text = infoString
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = orders[indexPath.row]
        
        
        
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            
            if info.isSupportRefund() {
                _ = alert.addButton("申请退款") { self.refund(info) }
            }
            
            if info.isSupportRetry() {
                self.queryProtocols(info.orderType)
                _ = alert.addButton("重试") { self.retry(info) }
            }
            
            _ = alert.addButton("详情") { self.detail(info) }
            _ = alert.showEdit("操作", subTitle:"选择订单操作")
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "复制订单号"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let info = orders[indexPath.row]
        
        UIPasteboard.general.string = "订单号:   \(info.orderNum)"
        ViewController.successTips(title: "成功", subTitle: "复制成功")
    }
    
    func queryProtocols(_ orderType: PayOrderType) {
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

extension OrderListViewController {
    func refund(_ info: PayOrderInfo) {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("申请退款", content: "申请退款中...")
        }
        switch ViewController.tsm {
        case .snowball:
            ViewController.pay.snCloud.requestRefund(orderNum: info.orderNum) { (error) in
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
                if error == nil {
                    ViewController.successTips(title: "成功", subTitle: "申请退款")
                } else {
                    ViewController.failTips(title: "失败", subTitle: "原因: \(String(describing: error))")
                }
            }
            break
        case .mi:
            ViewController.pay.miCloud.requestRefund(orderNum: info.orderNum) { (error) in
                DispatchQueue.main.async { ViewController.waitAlert?.close() }
                if error == nil {
                    ViewController.successTips(title: "成功", subTitle: "申请退款")
                } else {
                    ViewController.failTips(title: "失败", subTitle: "原因: \(String(describing: error))")
                }
            }
        }
    }
    
    func retry(_ info: PayOrderInfo) {
        switch ViewController.tsm {
        case .mi:
            var execApdu = MIExecApdu()
            execApdu.protocolID = self.protocolID
            execApdu.execApdu(info)
            break
        case .snowball:
            var execApdu = SNExecApdu()
            execApdu.execApdu(info)
            break
        }
    }
    
    func detail(_ info: PayOrderInfo) {
        DispatchQueue.main.async {
            ViewController.waitAlert = ViewController.waitAlert("Loading", content: "详情中...")
        }
        switch ViewController.tsm {
        case .snowball:
            ViewController.pay.snCloud.orderInfo(orderNum: info.orderNum) { (order, error) in
                self.showInfo(order, error: error)
            }
            break
        case .mi:
            ViewController.pay.miCloud.orderInfo(orderNum: info.orderNum) { (order, error) in
                self.showInfo(order, error: error)
            }
            break
        }
    }
}

extension OrderListViewController {
    func showInfo(_ info: PayOrderInfo?, error: PayError?) {
        guard error == nil,
            let orderInfo = info else
        { ViewController.failTips(title: "订单详情失败", subTitle: "原因: \(error!)"); return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var paynum = ""
        if let pay = orderInfo.payNum { paynum = pay }
        let stringTime = dateFormatter.string(from: orderInfo.orderTime)
        let infoString = "订单号: \(orderInfo.orderNum)\n订单状态:\(orderInfo.orderState)\n订单说明: \(orderInfo.orderStateDec)\n订单金额: \(orderInfo.orderAmount)\n订单时间: \(stringTime)\n支付流水号: \(paynum)\n\n"
        DispatchQueue.main.async { ViewController.waitAlert?.close() }
        ViewController.successTips(title: "成功", subTitle: "\(infoString)")
    }
}
