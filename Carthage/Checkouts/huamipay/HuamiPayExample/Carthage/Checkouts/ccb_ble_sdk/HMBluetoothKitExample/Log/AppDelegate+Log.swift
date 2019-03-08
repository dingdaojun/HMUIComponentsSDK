//
//  AppDelegate+Log.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/3/6.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMLog

extension AppDelegate {
    func configLog() {
        HMLogManager.setupDefaultConfiguration(LogHelper.logConfig())
    }
}
