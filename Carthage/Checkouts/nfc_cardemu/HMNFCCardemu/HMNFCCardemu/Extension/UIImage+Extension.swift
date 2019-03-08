//  UIImage+Extension.swift
//  Created on 2018/2/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

extension UIImage {
    convenience init?(nfcCardemuNamed name: String) {
        let bundle = Bundle(for: CardDetectionViewController.self)
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}
