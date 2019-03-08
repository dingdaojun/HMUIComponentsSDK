//
//  DeviceViewController+ECF.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/7/18.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation


extension DeviceViewController {
    @objc func ecfService() {
        let ecf = ECFViewController()
        ecf.infomation = peripheralInfomation
        self.navigationController?.pushViewController(ecf, animated: true)
    }
}
