//
//  ViewController+Tips.swift
//  HuamiPayExample
//
//  Created by 余彪 on 2018/3/31.
//  Copyright © 2018年 华米科技. All rights reserved.
//

import Foundation


extension ViewController {
    public static func successTips(title: String, subTitle: String) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.showSuccess(title, subTitle: subTitle)
        }
    }
    
    public static func failTips(title: String, subTitle: String) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.showError(title, subTitle: subTitle)
        }
    }
    
    public static func notifyTips(title: String, subTitle: String) {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.showNotice(title, subTitle: subTitle)
        }
    }
    
    public static func waitAlert(_ title: String, content: String) -> SCLAlertViewResponder {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        return alertView.showWait(title, subTitle: content, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
    }
}
