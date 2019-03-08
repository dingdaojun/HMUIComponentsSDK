//
//  PayCity.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation
import TWTagLengthValue


public class PayCityBase {
    public init() {}
    
    public static func select(_ aid: Data) -> Data {
        var selectBytes: [UInt8] = [0x00, 0xA4, 0x04, 0x00, UInt8(truncatingIfNeeded:aid.count)]
        selectBytes += [UInt8](aid)
        return Data(bytes: selectBytes)
    }
    
    public func setDefault(_ enable: Bool, aid: Data) throws {
        try PayTransmit.shared.openNFCChannel()
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(CRS_AID))
        guard selRes.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: selRes) }
        
        let aidTLV = try! TWTLV(tagId: ApduTag.aid.rawValue, value: aid.bytes)
        var transmitData: Data
        let lcDataString = Data.init(hex: "\(aidTLV.tlvString())").countHexCombin()
        if enable {
            // 设置默认卡
            transmitData = Data.init(hex: "80F00101\(lcDataString)")
        } else {
            // 去除默认卡
            transmitData = Data.init(hex: "80F00100\(lcDataString)")
        }
        var res = try PayTransmit.shared.transmit(transmitData)
        
        if res.validateRegex(".*6330$") {
            res.removeLast(2)
            try analysis(with: res, for: aid)
            return
        }
        
        guard res.validateRegex(successRegex) else {
            throw PayError.errorApduResponse(response: selRes)
        }
    }
    
    fileprivate func analysis(with rspData: Data, for defaultAid: Data) throws {
        var isSetDefault = false
        let tlv = try! TWTLV(data: rspData.bytes)
        print("6300 TLV: \(tlv.printableTlv())")
        for (_, childTLV) in tlv.children.enumerated() {
            if childTLV.tagId == 0xA0,
                let localTLV = childTLV.children.first {
                isSetDefault = true
                try setDefault(false, aid: Data(bytes: localTLV.value))
                try setDefault(true, aid: defaultAid)
            }
        }
        
        if isSetDefault == false {
            throw PayError.errorApduResponse(response: rspData)
        }
    }
    
    public func isDefault(_ aid: Data) throws -> Bool {
        try PayTransmit.shared.openNFCChannel()
        let selRes = try PayTransmit.shared.transmit(PayCityBase.select(CRS_AID))
        guard selRes.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: selRes) }
        let aidTLV = try! TWTLV(tagId: ApduTag.aid.rawValue, value: aid.bytes)
        let lcDataString = Data.init(hex: "\(aidTLV.tlvString())").countHexCombin()
        let queryData = Data.init(hex: "80F24002\(lcDataString)")
        var result = try PayTransmit.shared.transmit(queryData)
        guard result.validateRegex(successRegex) else { throw PayError.errorApduResponse(response: result) }
        result.remove9000()
        let tlv = try! TWTLV(data: result.bytes)
        let children = tlv.children.filter { return ($0.tagId == ApduTag.defaultTag.rawValue) && (Data(bytes: $0.value).validateRegex(".*01$")) }
        return children.count > 0
    }
}
