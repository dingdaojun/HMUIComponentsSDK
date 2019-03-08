//  NavigationBarView.swift
//  Created on 2018/2/1
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

import UIKit

class NavigationBarView: UIView {

    @IBOutlet var navHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    var backAction: (() -> Void)?
    
    var rightAction: (() -> Void)?
    
    lazy var bottomLineView = UIView()

    lazy var backGroundView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navHeightConstraint.constant = UIDevice.isPhoneX ? 88 : 64
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    @IBAction func rightButtonClick(_ sender: UIButton) {
        rightAction?()
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        backAction?()
    }
}

extension NavigationBarView {
    private func configuration() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLineView)

        let views = ["bottomLineView" : bottomLineView]
        let metric = ["lineHeight" : 1.0 / UIScreen.main.scale.native ]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[bottomLineView]|", metrics: metric, views: views))

        addSubview(toFill: backGroundView)
        backGroundView.alpha = 0
        sendSubview(toBack: backGroundView)

    }
}
