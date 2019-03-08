//
//  MIAccessControlCloud.swift
//  huamipay
//
//  Created by 余彪 on 2018/7/17.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService


class AccessCard: NSObject, HMServiceAPIWalletaAcessCardInfoProtocol {
    var card: PayACCardProtocol
    init(card: PayACCardProtocol) { self.card = card }
    
    var api_walletAcessCardInfoAid: String! { return card.aid }
    var api_walletAcessCardInfoCardArt: String!  { return card.art }
    var api_walletAcessCardInfoCardType: Int = 0
    var api_walletAcessCardInfoFingerFlag: Int = 0
    var api_walletAcessCardInfoName: String!  { return card.name }
    var api_walletAcessCardInfoUserTerms: String!  { return card.userTerms }
    var api_walletAcessCardInfoVSStatus: Int  { return 0 }
}

open class MIAccessControlCloud: HuamipayMIAccessControlProtocol {
    /// 复制Mifare信息
    ///
    /// - Returns: CardTag
    /// - Throws: Error
    public func readCardTag() throws -> CardTag {
        guard let delegate = PayTransmit.shared.bleDelegate else { throw PayError.weakRelease }
        var tagData = try delegate.readCardTag()
        // 如果不是Mifare卡，接口会返回8D08
        guard tagData.bytes != [0x8D, 0x08] else { throw PayError.notMiFare }
        guard tagData.count > 4 else { throw PayError.errorApduResponse(response: tagData) }
        tagData = tagData.dropFirst(2)
        let sak = tagData.subdata(in: 2..<3).toHexString()
        let atqa = tagData.subdata(in: 0..<2).toHexString()
        let uid = tagData.dropFirst(4).toHexString()
        let tag = CardTag(uid: uid,
                          sak: sak,
                          atqa: atqa)
        return tag
    }
    
    /// 删卡
    ///
    /// - Parameters:
    ///   - param: MIAccessControlOperationParam aid参数一定不为空
    ///   - callback: DeleteCardCallback
    public func deleteCard(_ param: MIAccessControlOperationParam, callback: @escaping HuamipayMIAccessControlProtocol.DeleteCardCallback) {
        guard param.aid.count > 0 else { callback(PayError.paramError("删除门禁卡，aid不能为空"));return }
        PayTransmit.shared.payQueue.async {
            param.actionType = .deleteapp
            let operation = PayMIAccessControlOperation(param)
            operation.start({ (_ ,error) in
                PayTransmit.shared.payQueue.async {
                    callback(error)
                }
            })
        }
    }
    
    /// 开卡
    ///
    /// - Parameters:
    ///   - param: MIAccessControlOperationParam， uid、sak、atqa不能为空
    ///   - callback: InstallCallback
    public func installCard(_ param: MIAccessControlOperationParam, callback: @escaping HuamipayMIAccessControlProtocol.InstallCallback) {
        guard param.uid.count > 0,
              param.sak.count > 0,
              param.atqa.count > 0 else { callback(nil, PayError.paramError("安装门禁卡，uid/sak/atqa不能为空"));return }
        PayTransmit.shared.payQueue.async {
            param.actionType = .copyFareCard
            let operation = PayMIAccessControlOperation(param)
            operation.start({ (sessionId, error) in
                PayTransmit.shared.payQueue.async {
                    try? PayTransmit.shared.closeNFCChannel()
                    callback(sessionId, error)
                }
            })
        }
    }
    
    /// 根据sessionID获取门禁卡信息
    ///
    /// - Parameters:
    ///   - sessionId: sessionID
    ///   - callback: 回调
    public func cardInfomation(with sessionId: String, callback: @escaping HuamipayMIAccessControlProtocol.CardInfoCallback) {
        guard sessionId.count > 0 else { callback(nil ,PayError.paramError("门禁卡信息，sessionId不能为空")); return }
        print("-------------------------------------------------------------------------------------------------------------------")
        PayTransmit.shared.nfcService.wallet_acessCard(withSessionID: sessionId) { (state, msg, pros) in
            guard state != PayNetworkState.networkFail.rawValue else {
                callback(nil, PayError.networkError(msg: msg ?? ""))
                return
            }
            
            guard state == PayNetworkState.success.rawValue,
                let info = pros?.first else {
                    callback(nil, PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                                     PayError.errorMsg: msg ?? ""])))
                    return
            }
            
            callback(self.generalACCard(with: info), nil)
        }.printCURL()
        print("-------------------------------------------------------------------------------------------------------------------")
    }
    
    /// 获取门禁卡列表数据
    ///
    /// - Parameter callback: CardListCallback
    public func accessCardList(callback: @escaping HuamipayMIAccessControlProtocol.CardListCallback) {
        PayTransmit.shared.nfcService.wallet_acessCard { (state, msg, pros) in
            guard state != PayNetworkState.networkFail.rawValue else {
                callback(nil, PayError.networkError(msg: msg ?? ""))
                return
            }
            
            guard state == PayNetworkState.success.rawValue else {
                    callback(nil, PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                                     PayError.errorMsg: msg ?? ""])))
                    return
            }
            
            guard let infos = pros else {
                callback([], nil)
                return
            }
            
            let cards = infos.map({ (pro) -> PayACCCard in
                return self.generalACCard(with: pro)
            })
            callback(cards, nil)
        }.printCURL()
    }
    
    
    /// 更新门禁卡数据
    ///
    /// - Parameters:
    ///   - info: PayACCardProtocol
    ///   - callback: UpdateCardCallback
    public func updateAccessCardInfomation(with info: PayACCardProtocol, callback: @escaping HuamipayMIAccessControlProtocol.UpdateCardCallback) {
        
        PayTransmit.shared.nfcService.wallet_updateAcessCard(AccessCard(card: info)) { (state, msg) in
            guard state != PayNetworkState.networkFail.rawValue else {
                callback(PayError.networkError(msg: msg ?? ""))
                return
            }
            
            guard state == PayNetworkState.success.rawValue else {
                callback(PayError.unlikey(error: NSError(domain: PayError.domain, code: PayNetworkState.tsmCode, userInfo: [PayError.errorCode: state ?? "",
                                                                                                                            PayError.errorMsg: msg ?? ""])))
                return
            }
            
            callback(nil)
        }.printCURL()
    }
}

extension MIAccessControlCloud {
    fileprivate func generalACCard(with pro: HMServiceAPIWalletaAcessCardInfoProtocol) -> PayACCCard {
        let cardInfomation = PayACCCard(aid: pro.api_walletAcessCardInfoAid ?? "", art: pro.api_walletAcessCardInfoCardArt ?? "", name: pro.api_walletAcessCardInfoName ?? "", userTerms: pro.api_walletAcessCardInfoUserTerms ?? "", isFinger: pro.api_walletAcessCardInfoFingerFlag != 0)
        return cardInfomation
    }
}
