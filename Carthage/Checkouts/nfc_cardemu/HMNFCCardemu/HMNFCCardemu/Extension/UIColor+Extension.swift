//  UIColor.swift
//  Created on 2018/1/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

// MARK: - Generate
extension UIColor {
    convenience init?(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init?(hex: String, alpha: CGFloat) {
        if hex.count < 6 {
            print("hex生成UIColor，需要提供正确的hex值，您提供的为: \(hex)")
            return nil
        }

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        // strip 0X if it appears
        if cString.hasPrefix("0X") {
            cString = cString.replacingOccurrences(of: "0X", with: "")
        } else if cString.hasPrefix("#") {
            cString = cString.replacingOccurrences(of: "#", with: "")
        }

        let rRange = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let red = String(cString[rRange])
        let gRange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let green = String(cString[gRange])
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let blue = String(cString[bIndex...])

        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: red).scanHexInt32(&r)
        Scanner(string: green).scanHexInt32(&g)
        Scanner(string: blue).scanHexInt32(&b)

        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    static func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        let base: CGFloat = 255.0
        return UIColor(red: r / base, green: g / base, blue: b / base, alpha: a)
    }

    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return rgba(r: r, g: g, b: b, a: 1.0)
    }
}

extension UIColor {

    static var navigationTitleColor = UIColor(white: 0, alpha: 0.7)

    static var navigationBarColor = rgb(r: 238, g: 239, b: 240)

    static var blueTintColor = rgb(r: 65, g: 145, b: 225)

    static var blackColor20Percent = rgba(r: 0, g: 0, b: 0, a: 0.2)

    static var blackColor30Percent = rgba(r: 0, g: 0, b: 0, a: 0.3)

    static var blackColor40Percent = rgba(r: 0, g: 0, b: 0, a: 0.4)

    static var tipColor = rgba(r: 255, g: 102, b: 85, a: 1.0)
    
    static var viewBackgroundColor = UIColor.init(hex: "f6f7f8")
}
