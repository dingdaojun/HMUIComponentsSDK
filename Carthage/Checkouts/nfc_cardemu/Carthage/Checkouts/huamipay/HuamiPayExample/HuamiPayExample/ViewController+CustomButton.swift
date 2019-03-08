//
//  ViewController+CustomButton.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/31.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation

extension ViewController {
    public func createButton(title: String, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) -> UIButton {
        // Add button
        let btn = SCLButton(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColorFromRGB(0xA429FF)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.titleLabel?.numberOfLines = 0;
        return btn
    }
}
