//
//  DeviceViewController+SnowBall.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/5.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func openMainChannelForSnowBall() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let instanceIdTextField = alert.addTextField("instanceID")
            instanceIdTextField.text = "A000000151000000"
            _ = alert.addButton("打开主通道") {
                if let instanceID = instanceIdTextField.text {
                    self.nfcDevice?.snowBallDelegate = self
                    self.nfcDevice?.openChannel(instanceId: Data.init(hex: instanceID), channelType: 0)
                }
            }
            
            _ = alert.showEdit("雪球服务", subTitle:"一定要填写instanceID")
        }
    }
    
    func openManageChannelForSnowBall() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let instanceIdTextField = alert.addTextField("instanceID")
            instanceIdTextField.text = "A000000151000000"
            _ = alert.addButton("打开逻辑通道") {
                if let instanceID = instanceIdTextField.text {
                    self.nfcDevice?.snowBallDelegate = self
                    self.nfcDevice?.openChannel(instanceId: Data.init(hex: instanceID), channelType: 0)
                }
            }
            
            _ = alert.showEdit("雪球服务", subTitle:"一定要填写instanceID")
        }
    }
    
    func transmitForSnowBall() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let transmitTextField = alert.addTextField("命令")
            transmitTextField.text = "80CA9F7F00"
            _ = alert.addButton("打开逻辑通道") {
                if let transmit = transmitTextField.text {
                    self.nfcDevice?.snowBallDelegate = self
                    self.nfcDevice?.transmit(apdu: Data.init(hex: transmit))
                }
            }
            
            _ = alert.showEdit("雪球服务", subTitle:"一定要填写transmit命令")
        }
    }
    
    func closeForSnowBall() {
        self.nfcDevice?.snowBallDelegate = self
        self.nfcDevice?.close()
    }
}

extension DeviceViewController: HMBluetoothSnowBallServiceReponseProtocol {
    func openChannelResult(data: Data?, error: HMBluetoothNFCServiceError?) {
        print("雪球项目 openChannelResult: \(String(describing: data?.hexEncodedString())); error: \(String(describing: error))")
        if let err = error {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "打开通道失败", subTitle: "失败原因: \(err)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "打开通道成功")
            }
        }
    }
    
    func transmitResult(data: Data?, error: HMBluetoothNFCServiceError?) {
        print("雪球项目 transmitResult: \(String(describing: data?.hexEncodedString())); error: \(String(describing: error))")
        if let err = error {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "发送transmit失败", subTitle: "失败原因: \(err)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "发送transmit成功: \(String(describing: data?.hexEncodedString()))")
            }
        }
    }
    
    func closeResult(error: HMBluetoothNFCServiceError?) {
        print("雪球项目 closeResult: error: \(String(describing: error))")
        
        if let err = error {
            DispatchQueue.main.async {
                DeviceViewController.failTips(title: "关闭通道失败", subTitle: "失败原因: \(err)")
            }
        } else {
            DispatchQueue.main.async {
                DeviceViewController.successTips(title: "成功", subTitle: "关闭通道成功")
            }
        }
    }
}
