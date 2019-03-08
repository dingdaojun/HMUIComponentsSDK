//  UIView+Extension.swift
//  Created on 2018/2/1
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

extension UIView {

    func applyBorder(width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    func applyCorner(radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }

    func applyShadow(offset:CGSize,radius:CGFloat,opacity:Float) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }

    @discardableResult
    func addSubview(toFill view: UIView) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let views = ["view" : view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", metrics: nil, views: views))
        return view
    }
}

