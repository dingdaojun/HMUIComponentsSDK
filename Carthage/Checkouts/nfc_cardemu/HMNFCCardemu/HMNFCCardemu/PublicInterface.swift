//
//  PublicInterface.swift
//  HMNFCCardemu
//
//  Created by Karsa Wu on 2018/7/18.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

import Foundation
import huamipay
import HMService

@objc public protocol HMNFCCardemuDelegate: NSObjectProtocol {
    func swapDefaultCard(actionType: UInt8, aid: String?) -> Void;
}

@objc
public class PublicInterface: NSObject {
    @objc public static let shared : PublicInterface = PublicInterface()
    
    private(set) var pay: HuamiPay?
    private(set) var cardExist: Bool = false
    private(set) var operationQueue = OperationQueue()
    private(set) weak var delegate: HMNFCCardemuDelegate?
    
    private override init() {
        
    }
    
    @objc public func interfaceEntrance(nfc: NFCBLEProtocol, service: HMServiceAPI, delegate: HMNFCCardemuDelegate, callBack: @escaping (UIViewController?, NSError?) -> Void ) {
        
        self.delegate = delegate
        
        pay = HuamiPay.init(with: nfc, service: service)
        
        pay?.miACCloud.accessCardList { cardProtocols, error in
            guard error == nil else {
                callBack(nil, NSError.init(error: error!))
                return
            }
            
            if cardProtocols!.count < 1 {
                self.cardExist = false
                let vc : CardDetectionViewController = UIStoryboard.init(openCard: .Detection).instantiate()
                callBack(vc, nil)
                return
            }
            
            self.cardExist = true
            
            let vc : CardListViewController = UIStoryboard.init(openCard: .OpenCard).instantiate()
            vc.cardProtocols = cardProtocols!
            callBack(vc, nil)
            
            return;
        }
    }
}
