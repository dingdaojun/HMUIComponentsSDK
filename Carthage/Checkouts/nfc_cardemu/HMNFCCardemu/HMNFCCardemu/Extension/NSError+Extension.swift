//  NSError+Extension.swift
//  Created on 2018/4/1
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import Foundation
import huamipay

extension NSError {
    static let domain = "com.hm.wallet.error"

    convenience init(error: Error) {
        if let e = error as? PayError{
            switch e {
            case .errorApduResponse(_):
                self.init(domain: NSError.domain, code: 0, userInfo: nil)
            case .timeout:
                self.init(domain: NSError.domain, code: 1, userInfo: nil)
            case .unlikey(_):
                self.init(domain: NSError.domain, code: 2, userInfo: nil)
            case .weakRelease:
                self.init(domain: NSError.domain, code: 3, userInfo: nil)
            case .overdraftLessThanZero(_):
                self.init(domain: NSError.domain, code: 3, userInfo: nil)
            case .overdraftBalanceBothValue(_):
                self.init(domain: NSError.domain, code: 4, userInfo: nil)
            case .bleError(_):
                self.init(domain: NSError.domain, code: 5, userInfo: nil)
            case .networkError(_):
                self.init(domain: NSError.domain, code: 6, userInfo: nil)
            case .paramError(_):
                self.init(domain: NSError.domain, code: 7, userInfo: nil)
            case .blackCard:
                self.init(domain: NSError.domain, code: 8, userInfo: nil)
            case .notMiFare:
                self.init(domain: NSError.domain, code: 9, userInfo: nil)
            }
        } else {
            self.init(domain: NSError.domain, code: 9, userInfo: nil)
        }
    }
}
