//  HUD.swift
//  Created on 2018/1/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

enum HUDType {
    case Success
    case Error
    case Loading
}

class HUD: UIView {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    private let animationDuration = 0.1

    private var type: HUDType? = .Loading

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @discardableResult
    class func show(withLoading title: String) -> HUD {
        return show(withType: .Loading, title: title)
    }

    @discardableResult
    class func show(withType type: HUDType, title: String) -> HUD {
        return show(withType: type, title: title, in: UIApplication.shared.delegate!.window!!)
    }

    @discardableResult
    class func show(withType type: HUDType, title: String, in view: UIView) -> HUD {
        for subview in view.subviews {
            if subview.isKind(of: self) {
                let hud = subview as! HUD
                hud.hide(withAnimated: false)
            }
        }


        let hud = Bundle.NFCCardemu?.loadNibNamed("HUD", owner: nil, options: nil)?.first as! HUD
        hud.config(withType: type, title: title, inView: view)
        return hud
    }

    class func hide() {
        hide(in: UIApplication.shared.delegate!.window!!)
    }

    class func hide(in view: UIView) {
        for subview in view.subviews {
            if subview.isKind(of: self) {
                let hud = subview as! HUD
                hud.hide(withAnimated: true)
            }
        }
    }

    private func hide(withAnimated animated: Bool) {
        imageView.layer.removeAnimation(forKey: "rotation")
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
            }, completion: { (finished) in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }

    private func config(withType type: HUDType, title: String, inView view: UIView) {
        self.type = type
        titleLabel.text = title
        view.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        let hud = self
        let layoutHorizontals = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[hud]-|", options: [], metrics: nil, views: ["hud" : hud])
        view.addConstraints(layoutHorizontals)

        let layoutVerticals = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[hud]-|", options: [], metrics: nil, views: ["hud" : hud])
        view.addConstraints(layoutVerticals)

        self.alpha = 0
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
        }

        imageView.layer.removeAnimation(forKey: "rotation")

        if type == .Loading {
            imageView.image = UIImage(nfcCardemuNamed: "img_toast_loading")
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
            rotationAnimation.duration = 0.6
            rotationAnimation.repeatCount = MAXFLOAT
            rotationAnimation.isRemovedOnCompletion = false
            imageView.layer.add(rotationAnimation, forKey: "rotation")
        } else {
            isUserInteractionEnabled = false
            let imageName = (type == .Success) ? "img_toast_complete" : "img_toast_error"
            imageView.image = UIImage(nfcCardemuNamed: imageName)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.hide(withAnimated: true)
            }
        }
    }
}
