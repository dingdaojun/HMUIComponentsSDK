//
//  DeviceViewController+NFC.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/1.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

extension DeviceViewController {
    @objc func openApdu() {
        nfcDevice?.nfcServiceDelegate = self
        nfcDevice?.openApdu()
    }
    
    @objc func sendApdu() {
        nfcDevice?.nfcServiceDelegate = self
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let apduTextField = alert.addTextField("apdu指令")
            let lengthTextField = alert.addTextField("apdu长度")
            apduTextField.text = "00A4040008A0000001510000000D00"
            lengthTextField.keyboardType = .phonePad
            _ = alert.addButton("非加密发送") {
                if let apdu = apduTextField.text {
                    let apduData = Data.init(hex: apdu)
                    self.nfcDevice?.sendApdu(apduCmd: apduData, apduData.count, false)
                }
            }
            
            _ = alert.addButton("加密发送", action: {
                
                if let apdu = apduTextField.text {
                    let apduData = Data.init(hex: apdu)
                    
                    if let length = lengthTextField.text {
                        self.nfcDevice?.sendApdu(apduCmd: apduData, Int(length)!, true)
                    }
                }
            })
            
            _ = alert.showEdit("NFC", subTitle:"加密发送一定要填写长度")
        }
    }
    
    @objc func closeApdu() {
        nfcDevice?.nfcServiceDelegate = self
        nfcDevice?.closeApdu()
    }
}

extension DeviceViewController: HMBluetoothNFCServiceResponseProtocol {
    func nfcServiceOpenResult(error: HMBluetoothNFCServiceError?) {
        DispatchQueue.main.async {
            if let err = error {
                DeviceViewController.failTips(title: "打开通道失败", subTitle: "失败原因: \(err)")
            } else {
                DeviceViewController.successTips(title: "成功", subTitle: "打开通道成功")
            }
        }
    }
    
    func nfcServiceCloseApduResult(error: HMBluetoothNFCServiceError?) {
        DispatchQueue.main.async {
            if let err = error {
                DeviceViewController.failTips(title: "关闭通道失败", subTitle: "失败原因: \(err)")
            } else {
                DeviceViewController.successTips(title: "成功", subTitle: "关闭通道成功")
            }
        }
    }
    
    func nfcServiceSendApduResult(responseData: Data?, length: UInt8?, error: HMBluetoothNFCServiceError?) {
        DispatchQueue.main.async {
            if let resultData = responseData {
                let response = resultData.hexEncodedString()
                var msg: String = "Apdu结果: \(response)\n"
                msg.append("长度: \(length!)")
                
                _ = SCLAlertView().showInfo("Apdu结果", subTitle:  msg)
            }
        }
    }
    
    func nfcServiceGetATRResult(responseData: Data?, length: UInt8?, error: HMBluetoothNFCServiceError?) {
        
    }
    
    func nfcServiceSaveCommunicateKeyResult(error: HMBluetoothNFCServiceError?) {
        
    }
    
    
}
