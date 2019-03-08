//  UIDevice+Extension.swift
//  Created on 2018/2/1
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

enum UIDeviceResolution {
    case unKnown
    case iPhoneStandard
    case iPhoneRetina35
    case iPhoneRetina4
    case iPhoneRetina47
    case iPhoneRetina55
    case iPadStandard
    case iPadRetina
}

extension UIDevice {
    static var designPixel: CGFloat = 1.0 / UIScreen.main.scale

    static var isPhoneX: Bool {
        guard let mode = UIScreen.main.currentMode else { return false }
        return CGSize(width: 1125, height: 2436).equalTo(mode.size)
    }

    static var isPhone3_5InchDevice = (resolution == .iPhoneRetina35)

    static var isPhone4inchDevice = (resolution == .iPhoneRetina4)

    static var resolution: UIDeviceResolution {
        guard UI_USER_INTERFACE_IDIOM() == .phone else {
            return .iPadRetina
        }

        let screenHeight = UIScreen.main.bounds.height
        switch screenHeight {
        case 480:   return .iPhoneRetina35
        case 568:   return .iPhoneRetina4
        case 667:   return .iPhoneRetina47
        case 736:   return .iPhoneRetina55
        default:    return .iPhoneRetina55
        }

    }
}
