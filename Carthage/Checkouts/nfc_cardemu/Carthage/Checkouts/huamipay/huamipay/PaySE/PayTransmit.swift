//
//  PayTransmit.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/4/8.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import HMService

class PayTransmit {
    static let shared = PayTransmit()
    weak var bleDelegate: NFCBLEProtocol?
    var payQueue = DispatchQueue.global()
    var nfcService: HMServiceAPI = HMServiceAPI.defaultService()
    
    public func openNFCChannel() throws {
        guard let delegate = bleDelegate else { throw PayError.weakRelease }
        do {
            try delegate.openNFCChannel()
        } catch {
            throw PayError.bleError(error: error)
        }
    }
    
    public func transmit(_ apdu: Data) throws -> Data {
        guard let delegate = bleDelegate else { throw PayError.weakRelease }
        do {
            return try delegate.transmit(apdu)
        } catch {
            throw PayError.bleError(error: error)
        }
    }
    
    public func closeNFCChannel() throws {
        guard let delegate = bleDelegate else { throw PayError.weakRelease }
        do {
            try delegate.closeNFCChannel()
        } catch {
            throw PayError.bleError(error: error)
        }
    }
}
