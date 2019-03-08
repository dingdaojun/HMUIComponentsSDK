//
//  MarsAuthService.swift
//  HMBluetoothKit
//
//  Created by 余彪 on 2018/3/2.
//

import Foundation
import CoreBluetooth
import CryptoSwift

public class MarsAuthService: AuthProtocol {
    var peripheral: LEPeripheral
    fileprivate var appID: UInt8 = 0x00 // default MIFit app ID
    fileprivate var authKey: [UInt8] = []
    fileprivate let serviceUUID: CBUUID = CBUUID(string: "FEE0")
    fileprivate let characteristicUUID: CBUUID = CBUUID(string: "00000009-0000-3512-2118-0009AF100700")
    fileprivate let FLAG_RSP: UInt8 = 0x10
    fileprivate let FLAG_RSP_OK: UInt8 = 0x01
    fileprivate let CMD_REQ_WRITERANDOM: UInt8 = 0x01
    fileprivate let CMD_REQ_READRANDOM: UInt8 = 0x02
    fileprivate let CMD_REQ_WRITECIPHER: UInt8 = 0x03
    
    public init(peripheral: LEPeripheral) {
        self.peripheral = peripheral
    }
    
    /// authorize
    ///
    /// - Parameters:
    ///   - appid: application id, like as mifit is 0
    ///   - key: UUID md5
    /// - Throws: Error
    public func authorize(appid: Int, key: [UInt8]) throws {
        // 授权
        appID = UInt8(appid)
        authKey = key
        let characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        let queue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic) { queue.push(($1.value!, $2))}
        
        try peripheral.writeNoRsp(randomCommandData(), to: characteristic)
        var (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.elementsEqual([FLAG_RSP, CMD_REQ_WRITERANDOM, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
        
        try peripheral.writeNoRsp(readRandomData(), to: characteristic)
        (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.starts(with: [FLAG_RSP, CMD_REQ_READRANDOM, FLAG_RSP_OK]) && value.count == 19 else { throw LEPeripheralError.invailedResponse(value) }
        
        let readRandomResponseData = value.dropFirst(3)
        try peripheral.writeNoRsp(cipherData(plainData: readRandomResponseData), to: characteristic)
        (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.elementsEqual([FLAG_RSP, CMD_REQ_WRITECIPHER, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
    }
    
    /// authenticate
    ///
    /// - Parameters:
    ///   - appid: application id, like as mifit is 0
    ///   - key: last generate key
    /// - Throws: Error
    public func authenticate(appid: Int, key: [UInt8]) throws {
        // 认证
        appID = UInt8(appid)
        authKey = key
        let characteristic = try peripheral.characteristic(characteristicUUID, in: serviceUUID)
        let queue = BlockingQueue()
        try peripheral.setNotify(true, for: characteristic) { queue.push(($1.value!, $2))}
        
        try peripheral.writeNoRsp(readRandomData(), to: characteristic)
        var (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.starts(with: [FLAG_RSP, CMD_REQ_READRANDOM, FLAG_RSP_OK]) && value.count == 19 else { throw LEPeripheralError.invailedResponse(value) }
        
        let readRandomResponseData = value.dropFirst(3)
        try peripheral.writeNoRsp(cipherData(plainData: readRandomResponseData), to: characteristic)
        (value, error) = try queue.pop()
        guard error == nil else { throw LEPeripheralError.unlikely(error!) }
        guard value.elementsEqual([FLAG_RSP, CMD_REQ_WRITECIPHER, FLAG_RSP_OK]) else { throw LEPeripheralError.invailedResponse(value) }
    }
    
    fileprivate func randomCommandData() -> Data {
        var bytes: [UInt8] = [CMD_REQ_WRITERANDOM, appID]
        bytes += authKey
        return Data.init(bytes: bytes)
    }
    
    fileprivate func readRandomData() -> Data {
        return Data.init(bytes: [CMD_REQ_READRANDOM, appID])
    }
    
    fileprivate func cipherData(plainData: Data) -> Data {
        let aes = try! AES(key: authKey, blockMode: ECB(), padding: .noPadding)
        let aesResult = try! aes.encrypt(plainData.bytes)
        var cipher: [UInt8] = [CMD_REQ_WRITECIPHER, appID]
        cipher += aesResult
        return Data.init(bytes: cipher)
    }
}
