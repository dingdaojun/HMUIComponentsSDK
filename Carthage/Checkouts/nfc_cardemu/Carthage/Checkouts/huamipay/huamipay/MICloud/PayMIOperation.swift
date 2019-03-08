//
//  PayMIOperation.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/13.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


class OrderApdu: NSObject,  HMServiceAPIWalletOrderAPDUProtocol {
    var api_walletOrderAPDUSession: String!
    var api_walletOrderAPDUNextStep: String!
    var api_walletOrderAPDUCommands: [HMServiceAPIWalletOrderAPDUCommandProtocol]!
}

class ApduCommands: NSObject, HMServiceAPIWalletOrderAPDUCommandProtocol {
    var api_walletOrderAPDUIndex: String!
    var api_walletOrderAPDUCommand: String!
    var api_walletOrderAPDUCheckCode: String!
    var api_walletOrderAPDUResult: String!
}

open class MIOperationParam: NSObject, HMServiceAPIWalletOrderRequestAPDUProtocol {
    let city: PayCity
    fileprivate var fetchModel: String
    let token: String
    
    /// 协议ID
    open var protocolID: String?
    var actionType: HMServiceWalletInstructionType = .topup
    
    public init(token: String, in city: PayCity) {
        self.city = city
        self.token = token
        self.fetchModel = city.info.miFetchModel
    }
    
    public var api_walletOrderRequestAPDUAid: String  {
        get {
            return city.info.aid.toHexString().uppercased()
        }
    }
    
    public var api_walletOrderRequestAPDUOrderToken: String  {
        get {
            return token
        }
    }
    
    public var api_walletOrderRequestAPDUFetchMode: String {
        get {
            return fetchModel
        }
    }
    
    public var api_walletOrderRequestAPDUType: HMServiceWalletInstructionType {
        get {
            return actionType
        }
    }
    
    public var api_walletOrderRequestAPDUExtraInfo: String  {
        get {
            var extraInfo = [String: String]()
            if let pro = protocolID {
                extraInfo["userProtocolId"] = pro
            }
            return extraInfo.json
        }
    }
    
    public var api_walletOrderRequestAPDUXiaomiCityID: String = ""
    public var api_walletOrderRequestAPDUCityID: String = ""
    public var api_walletOrderRequestAPDUBalance: String = "0"
    public var api_walletOrderRequestAPDUCardNumber: String = ""
    public var api_walletOrderRequestAPDUOrderID: String = ""
}


class PayMIOperation {
    typealias Callback = (_ payError: PayError?) -> Void
    private var cb: Callback?
    let param: MIOperationParam
    
    init(_ p: MIOperationParam) { self.param = p }
    
    /// 开始
    ///
    /// - Parameter callback: 回调
    func start(_ callback: @escaping Callback) {
        cb = callback
        
        do {
            try PayTransmit.shared.openNFCChannel()
        } catch {
            cb?(PayError.unlikey(error: error))
            return
        }
        
        let orderApdu = OrderApdu()
        PayTransmit.shared.nfcService.wallet_APDU(with: param) { (state, msg, pro) in
            PayTransmit.shared.payQueue.async {
                guard state != PayNetworkState.networkFail.rawValue else {
                    self.cb?(PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                guard state == PayNetworkState.success.rawValue else {
                    let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                           PayError.errorMsg: msg ?? ""])
                    self.cb?(PayError.unlikey(error: error))
                    return
                }
                
                let currentStep = pro?.api_walletOrderAPDUNextStep
                if currentStep == "EOF" {
                    if state == PayNetworkState.success.rawValue {
                        self.cb?(nil)
                    } else {
                        let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                             PayError.errorMsg: msg ?? ""])
                        self.cb?(PayError.unlikey(error: error))
                    }
                    return
                }
                
                let session = pro?.api_walletOrderAPDUSession
                orderApdu.api_walletOrderAPDUNextStep = currentStep
                orderApdu.api_walletOrderAPDUSession = session
                if let commands = pro?.api_walletOrderAPDUCommands {
                    let (results, isSuccess) = self.excApdu(commands)
                    orderApdu.api_walletOrderAPDUCommands = results
                    self.uploadApduResult(orderApdu, isSuccess: isSuccess)
                } else {
                    self.uploadApduResult(orderApdu, isSuccess: false)
                }
            }
        }
    }
    
    fileprivate func uploadApduResult(_ orderApdu: OrderApdu, isSuccess: Bool) {
        PayTransmit.shared.nfcService.wallet_APDU(withResult: orderApdu, apdu: param, resultSucess: isSuccess) { (state, msg, pro) in
            guard state != PayNetworkState.networkFail.rawValue else {
                self.cb?(PayError.networkError(msg: msg ?? ""))
                return
            }
            
            guard state == PayNetworkState.success.rawValue else {
                let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                     PayError.errorMsg: msg ?? ""])
                self.cb?(PayError.unlikey(error: error))
                return
            }
            
            let currentStep = pro?.api_walletOrderAPDUNextStep
            let session = pro?.api_walletOrderAPDUSession
            
            if currentStep == "EOF" {
                if state == PayNetworkState.success.rawValue {
                    self.cb?(nil)
                } else {
                    let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                         PayError.errorMsg: msg ?? ""])
                    self.cb?(PayError.unlikey(error: error))
                }
                return
            }
            
            orderApdu.api_walletOrderAPDUNextStep = currentStep
            orderApdu.api_walletOrderAPDUSession = session
            PayTransmit.shared.payQueue.async {
                if let apduCommands = pro?.api_walletOrderAPDUCommands {
                    let (results, isSuccess) = self.excApdu(apduCommands)
                    orderApdu.api_walletOrderAPDUCommands = results
                    self.uploadApduResult(orderApdu, isSuccess: isSuccess)
                } else {
                    self.uploadApduResult(orderApdu, isSuccess: false)
                }
            }
        }
    }
    
    fileprivate func excApdu(_ commands: [HMServiceAPIWalletOrderAPDUCommandProtocol]) -> ([ApduCommands], Bool) {
        var isSuccess = true
        var results: Array<ApduCommands> = []
        for command in commands {
            let apdu = command.api_walletOrderAPDUCommand.uppercased()
            do {
                let rep = try PayTransmit.shared.transmit(Data.init(hex: apdu))
                let resultCommand = ApduCommands()
                resultCommand.api_walletOrderAPDUResult = rep.toHexString().uppercased()
                resultCommand.api_walletOrderAPDUCommand = apdu
                resultCommand.api_walletOrderAPDUIndex = command.api_walletOrderAPDUIndex
                if let checker = command.api_walletOrderAPDUCheckCode {
                    resultCommand.api_walletOrderAPDUCheckCode = command.api_walletOrderAPDUCheckCode
                    results.append(resultCommand)
                    let matcher = ValidateRegex(checker)
                    // 后两位进行正则
                    let respString = rep.subdata(in: (rep.count - 2)..<rep.count).toHexString()
                    if !matcher.match(input: respString) {
                        print("不匹配checker")
                        isSuccess = false
                        break
                    }
                } else {
                    resultCommand.api_walletOrderAPDUCheckCode = ""
                    results.append(resultCommand)
                }
            } catch {
                isSuccess = false
                break
            }
        }
        
        return (results, isSuccess)
    }
}
