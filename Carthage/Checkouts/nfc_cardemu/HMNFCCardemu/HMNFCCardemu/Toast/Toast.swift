//  Toast.swift
//  Created on 2018/3/27
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

public class Toast: UIView {

    @IBOutlet var backgroundView: UIView!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var topConstraint: NSLayoutConstraint!

    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    @IBOutlet var leadingConstraint: NSLayoutConstraint!

    @IBOutlet var trailingConstraint: NSLayoutConstraint!

    fileprivate var minWidth: CGFloat = 0

    fileprivate var maxWidth: CGFloat = 0

    @discardableResult
    static func makeToast(title: String) -> Toast{
        guard let window = UIApplication.shared.delegate?.window else {
            fatalError("can't found the key window of application")
        }
        return makeToast(title: title, in: window!)
    }

    @discardableResult
    static func makeToast(title: String, in view: UIView) -> Toast {
        view.subviews.forEach {
            if $0 is Toast {
                ($0 as! Toast).hide()
            }
        }
        guard let toast = Bundle.NFCCardemu?.loadNibNamed("Toast", owner: nil, options: nil)?.first as? Toast else {
            fatalError("can't found 'Toast.xib' in \(String(describing: Bundle.NFCCardemu))")
        }
        toast.config(title: title, in: view)
        return toast
    }
}

extension Toast {
    fileprivate func config(title: String, in view: UIView) {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375.0
        titleLabel.text = title
        minWidth = 104.0 * ratio
        maxWidth = 203.0 * ratio
        topConstraint.constant = 16.0 * ratio
        bottomConstraint.constant = 16.0 * ratio
        leadingConstraint.constant = 13.7 * ratio
        leadingConstraint.constant = 13.7 * ratio
        layer.cornerRadius = 9 * ratio
        view.addSubview(self)
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -112 * ratio))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 0, constant: minWidth))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 0, constant: maxWidth))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hide()
        }
    }

    fileprivate func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
