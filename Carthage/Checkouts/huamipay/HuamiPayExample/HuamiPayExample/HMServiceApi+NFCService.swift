//
//  HMServiceApi+NFCService.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/5/28.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation
import HMService


extension HMServiceAPI {
    static func nfcService() -> HMServiceAPI {
        return HMServiceAPI.init(delegate: self.defaultDelegate)
    }
}
