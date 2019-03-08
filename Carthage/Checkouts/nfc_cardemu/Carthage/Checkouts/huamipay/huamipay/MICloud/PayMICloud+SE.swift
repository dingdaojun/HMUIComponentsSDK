//
//  PayMICloud+SE.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/13.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


extension PayMICloud {
    /// 解锁卡
    ///
    /// - Parameters:
    ///   - param: MIOperationParam
    ///   - enable: 锁卡/解锁卡
    ///   - callback: LockCardCallback
    public func lockCard(_ param: MIOperationParam, enable: Bool, callback: @escaping LockCardCallback) {
        PayTransmit.shared.payQueue.async {
            param.actionType = .lock
            if enable { param.actionType = .unlock }
            let op = PayMIOperation(param)
            op.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 充值操作
    ///
    /// - Parameters:
    ///   - param: MIOperationParam  Token一定要传
    ///   - callback: RechargeCallback
    public func recharge(_ param: MIOperationParam, callback: @escaping RechargeCallback) {
        guard !param.token.isEmpty else { callback(PayError.paramError("小米充值，token不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .topup
            let op = PayMIOperation(param)
            op.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 删卡(小米删卡前，需要告知小米添加任务)
    ///
    /// - Parameters:
    ///   - param: SNOperationParam
    ///   - callback: DeleteCardCallback
    public func deleteCard(_ param: MIOperationParam, callback: @escaping DeleteCardCallback) {
        PayTransmit.shared.payQueue.async {
            param.actionType = .deleteapp
            let op = PayMIOperation(param)
            op.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 下载cap包
    ///
    /// - Parameters:
    ///   - param: MIOperationParam  Token一定要传
    ///   - callback: LoadCallback
    public func loadCap(_ param: MIOperationParam, callback: @escaping LoadCallback) {
        guard !param.token.isEmpty else { callback(PayError.paramError("小米下载cap包，token不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .load
            let op = PayMIOperation(param)
            op.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 开卡
    ///
    /// - Parameters:
    ///   - param: MIOperationParam Token一定要传;
    ///   - callback: IssueCardCallback
    public func issuecard(_ param: MIOperationParam, callback: @escaping IssueCardCallback) {
        guard !param.token.isEmpty else { callback(PayError.paramError("小米开卡，token不能为空")); return; }
        PayTransmit.shared.payQueue.async {
            param.actionType = .issuecard
            let op = PayMIOperation(param)
            op.start({ (error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
}
