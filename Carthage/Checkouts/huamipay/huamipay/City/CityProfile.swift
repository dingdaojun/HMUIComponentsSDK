//
//  CityList.swift
//  huamipay
//
//  Created by 余彪 on 2018/3/21.
//

import Foundation


public let ISD_AID = Data.init(hex: "A000000151000000")
public let CRS_AID = Data.init(hex: "A00000015143525300")
public let successRegex = ".*9000$"
public let dealSuccessRegex = "\\w*[^0]+\\w*9000$"
public let defaultChannel = 0
public let defaultDealCount = 10

enum ApduTag: UInt64 {
    case aid = 0x4F
    case defaultTag = 0x9F70
}
