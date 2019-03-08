//
//  PayMIAccessControlOperation.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/18.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


class AccessControlApdu: NSObject,  HMServiceAPIWalletOrderAPDUProtocol {
    var api_walletOrderAPDUSession: String!
    var api_walletOrderAPDUNextStep: String!
    var api_walletOrderAPDUCommands: [HMServiceAPIWalletOrderAPDUCommandProtocol]!
}

public class MIAccessControlOperationParam: NSObject, HMServiceAPIWalletaAcessCardProtocol {
    public var aid: String = ""
    public var atqa: String = ""
    public var content: String {
        var test: String = ""
        for _ in 0..<1024 {
            test.append("FF")
        }
        return test
    }
    public var sak: String = ""
    public var uid: String = ""
    public var size: Int = 1024
    public var type: Int = 0
    
    
    override public init() {
        self.aid = ""
        self.atqa = ""
        self.sak = ""
        self.uid = ""
        self.type = 0
        super.init()
    }
    
    public init(uid: String, sak: String, atqa: String) {
        super.init()
        self.uid = uid
        self.sak = sak
        self.atqa = atqa
    }
    
    /// 协议ID
    var actionType: HMServiceWalletInstructionType = .topup
    
    public var api_walletOrderRequestAPDUType: HMServiceWalletInstructionType {
        return actionType
    }
    public var api_walletAcessCardAtqa: String! {
        return atqa
    }
    
    public var api_walletAcessCardBlockContent: String! {
        return content
    }
    
    public var api_walletAcessCardSak: String! {
        return sak
    }
    
    public var api_walletAcessCardUid: String! {
        return uid
    }
    
    public var api_walletAcessCardSize: Int {
        return size
    }
    
    public var api_walletAcessCardFareCardType: Int {
        return type
    }
    
    public var api_walletOrderRequestAPDUAid: String {
        return aid
    }
    
    public var api_walletOrderRequestAPDUExtraInfo: String = ""
    public var api_walletOrderRequestAPDUOrderToken: String = ""
    public var api_walletOrderRequestAPDUFetchMode: String = "SYNC"
    public var api_walletOrderRequestAPDUXiaomiCityID: String = ""
    public var api_walletOrderRequestAPDUCityID: String = ""
    public var api_walletOrderRequestAPDUBalance: String = "0"
    public var api_walletOrderRequestAPDUCardNumber: String = ""
    public var api_walletOrderRequestAPDUOrderID: String = ""
}


class PayMIAccessControlOperation {
    typealias Callback = (_ sessionID: String?, _ payError: PayError?) -> Void
    private var cb: Callback?
    let param: MIAccessControlOperationParam
    var printCurl = false
    
    init(_ p: MIAccessControlOperationParam) { self.param = p }
    
    /// 开始
    ///
    /// - Parameter callback: 回调
    func start(_ callback: @escaping Callback) {
        cb = callback
        
        do {
            try PayTransmit.shared.openNFCChannel()
        } catch {
            cb?(nil, PayError.unlikey(error: error))
            return
        }
        
        let apdu = AccessControlApdu()
        let network = PayTransmit.shared.nfcService.wallet_cacessCard(param) { (state, msg, pro) in
            PayTransmit.shared.payQueue.async {
                guard state != PayNetworkState.networkFail.rawValue else {
                    self.cb?(nil, PayError.networkError(msg: msg ?? ""))
                    return
                }
                
                guard state == PayNetworkState.success.rawValue else {
                    let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                           PayError.errorMsg: msg ?? ""])
                    self.cb?(nil, PayError.unlikey(error: error))
                    return
                }
                
                let currentStep = pro?.api_walletOrderAPDUNextStep
                let session = pro?.api_walletOrderAPDUSession
                
                if currentStep == "EOF" {
                    if state == PayNetworkState.success.rawValue {
                        self.cb?(session ,nil)
                    } else {
                        let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                               PayError.errorMsg: msg ?? ""])
                        self.cb?(nil, PayError.unlikey(error: error))
                    }
                    return
                }
                
                apdu.api_walletOrderAPDUNextStep = currentStep
                apdu.api_walletOrderAPDUSession = session
                
                if let commands = pro?.api_walletOrderAPDUCommands {
                    let (results, isSuccess) = self.excApdu(commands)
                    apdu.api_walletOrderAPDUCommands = results
                    self.uploadApduResult(apdu, isSuccess: isSuccess)
                } else {
                    self.uploadApduResult(apdu, isSuccess: false)
                }
            }
        }
        if printCurl { network?.printCURL() }
    }
    
    fileprivate func uploadApduResult(_ apdu: AccessControlApdu, isSuccess: Bool) {
        let network = PayTransmit.shared.nfcService.wallet_nextStepCacessCard(param, result: apdu, resultSucess: isSuccess) { (state, msg, pro) in
            guard state != PayNetworkState.networkFail.rawValue else {
                self.cb?(nil, PayError.networkError(msg: msg ?? ""))
                return
            }
            
            guard state == PayNetworkState.success.rawValue else {
                let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                       PayError.errorMsg: msg ?? ""])
                self.cb?(nil, PayError.unlikey(error: error))
                return
            }
            
            let currentStep = pro?.api_walletOrderAPDUNextStep
            let session = pro?.api_walletOrderAPDUSession
            
            if currentStep == "EOF" {
                if state == PayNetworkState.success.rawValue {
                    self.cb?(session, nil)
                } else {
                    let error = NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                           PayError.errorMsg: msg ?? ""])
                    self.cb?(nil, PayError.unlikey(error: error))
                }
                return
            }
            
            apdu.api_walletOrderAPDUNextStep = currentStep
            apdu.api_walletOrderAPDUSession = session
            PayTransmit.shared.payQueue.async {
                if let apduCommands = pro?.api_walletOrderAPDUCommands {
                    let (results, isSuccess) = self.excApdu(apduCommands)
                    apdu.api_walletOrderAPDUCommands = results
                    self.uploadApduResult(apdu, isSuccess: isSuccess)
                } else {
                    self.uploadApduResult(apdu, isSuccess: false)
                }
            }
        }
        if printCurl { network?.printCURL() }
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

