//
//  PaySNCloud+SE.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/13.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


extension PaySNCloud {
    /// 解锁卡
    ///
    /// - Parameters:
    ///   - param: SNOperationParam
    ///   - enable: 锁卡/解锁卡
    ///   - callback: LockCardCallback
    public func lockCard(_ param: SNOperationParam, enable: Bool, callback: @escaping LockCardCallback) {
        PayTransmit.shared.payQueue.async {
            param.actionType = .lock
            if !enable { param.actionType = .unlock }
            let operation = PaySNOperation(param)
            operation.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 删卡
    ///
    /// - Parameters:
    ///   - param: SNOperationParam
    ///   - callback: DeleteCardCallback
    public func deleteCard(_ param: SNOperationParam, callback: @escaping DeleteCardCallback) {
        PayTransmit.shared.payQueue.async {
            param.actionType = .deleteapp
            let operation = PaySNOperation(param)
            operation.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 充值操作
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: RechargeCallback
    public func recharge(_ param: SNOperationParam, callback: @escaping RechargeCallback) {
        guard !param.orderNum.isEmpty else { callback(PayError.paramError("雪球充值，订单号不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .topup
            let operation = PaySNOperation(param)
            operation.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 下载cap包
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 京津冀需要传手机号
    ///   - callback: LoadCallback
    public func loadCap(_ param: SNOperationParam, callback: @escaping LoadCallback) {
        guard !param.orderNum.isEmpty else { callback(PayError.paramError("雪球下载cap包，订单号不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .load
            let operation = PaySNOperation(param)
            operation.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 开卡
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 手机号一定要传，有校验；
    ///   - callback: IssueCardCallback
    public func issuecard(_ param: SNOperationParam, callback: @escaping IssueCardCallback) {
        guard !param.orderNum.isEmpty else { callback(PayError.paramError("雪球开卡，订单号不能为空")); return; }
        guard !param.phone.isEmpty else { callback(PayError.paramError("雪球开卡，手机号不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .issuecard
            let operation = PaySNOperation(param)
            operation.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 开卡+充值
    ///
    /// - Parameters:
    ///   - param: SNOperationParam  订单号一定要传; 手机号一定要传，有校验；
    ///   - callback: IssueCardCallback
    public func issueReCharge(_ param: SNOperationParam, callback: @escaping IssueRechargeCardCallback) {
        guard !param.orderNum.isEmpty else { callback(PayError.paramError("雪球开卡充值，订单号不能为空")); return; }
        guard !param.phone.isEmpty else { callback(PayError.paramError("雪球开卡充值，手机号不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .issueTopup
            let operation = PaySNOperation(param)
            operation.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
}
