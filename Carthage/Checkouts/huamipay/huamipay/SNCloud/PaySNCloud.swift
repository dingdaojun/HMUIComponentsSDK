//
//  PaySNCloud.swift
//  huamipay
//
//  Created by 余彪 on 2018/6/11.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import WalletService

public class PaySNCloud: HuamipaySNCloudProtocol {
    /// 是否打印CURL
    public var printCurl: Bool = false
    
    public var extendedInfo = ""
    public var deviceID = ""
}
