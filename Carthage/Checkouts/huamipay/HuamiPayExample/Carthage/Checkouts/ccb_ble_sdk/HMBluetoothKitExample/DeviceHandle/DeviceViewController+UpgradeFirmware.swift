//
//  DeviceViewController+UpgradeFirmware.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/12/12.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation
import UIKit
import HMBluetoothKit

extension DeviceViewController {
    @objc func upgradeFirmware() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            
            // Creat the subview
            let width = CGFloat(appearance.kWindowWidth) - CGFloat(12 * 2.0)
            let subview = UIView()
            // Add button
            let distance: CGFloat = 5.0
            let buttonWidth = width / 2.0 - 10.0
            let leftXPos: CGFloat = 0.0
            let rightXPos: CGFloat = width / 2.0 + 10.0
            var yPos: CGFloat = distance
            var lastMaxY: CGFloat = 0.0
            let typeLists: [UpgradeFirmwareType] = [.system,
                                               .resource,
                                               .font,
                                               .tempoResource,
                                               .gps,
                                               .agpsCEP,
                                               .agpsALM,
                                               .agpsNMEA,
                                               .taipingHuAS7000,
                                               .dialPlate,
                                               .packResource]
            let buttonNames = ["系统","资源", "字体", "tempoResource", "gps", "agpsCEP", "agpsALM", "agpsNMEA", "taipingHuAS7000", "dialPlate", "压缩包资源"]
            
            for (index, name) in buttonNames.enumerated() {
                var x: CGFloat = rightXPos
                
                if index % 2 == 0 {
                    x = leftXPos
                    yPos = (lastMaxY + distance)
                }
                
                let button = self.createButton(title: name, xPos: x, yPos: yPos, width: buttonWidth)
                lastMaxY = button.frame.maxY
                subview.addSubview(button)
                
                button.tag = Int(typeLists[index].rawValue)
            }
            
            subview.frame = CGRect(x: 0, y: 0, width: width, height: lastMaxY)
            alert.customSubview = subview
            self.upgradeTypeAlert = alert.showEdit("请选择固件升级类型", subTitle:"")
        }
    }
    
    private func firmwareList(type: UpgradeFirmwareType) {
        DispatchQueue.main.async {
            let firmwareFolder = DeviceViewController.firmwareFolder()
            let fileListViewController = FileListViewController(folderPath: firmwareFolder.path, title: "固件列表")
            self.navigationController?.pushViewController(fileListViewController, animated: true)
            fileListViewController.selectedFileCallBack = { (fileInfomation) in
                self.startUpgradeFirmware(filePath: fileInfomation.filePath, type: type)
            }
        }
    }
    
    private func startUpgradeFirmware(filePath: String, type: UpgradeFirmwareType) {
        guard let profile = ProfileManager.sharedInstance.getProfile(peripheralInfomation: peripheralInfomation) else { return }
        
        let alert = waitAlert("升级", content: "固件升级中...")
        let operation = BlockOperation {
            do {
                let firmwareFileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
                try (profile as! FirmwareUpdateProtocol).firmwareUpdate(firmwareFileData, type: type, callback: { (progress) in
                    DispatchQueue.main.async { alert.setSubTitle("固件升级中: \(progress)%") }
                })
                DispatchQueue.main.async {
                    alert.setSubTitle("固件升级成功!")
                    DispatchQueue.main.asyncAfter(deadline: 2, execute: { alert.close() })
                }
            } catch LEPeripheralError.invailedResponse(let data) {
                print("errpr: \(data.toHexString())")
                DispatchQueue.main.async {
                    alert.setSubTitle("固件升级失败: \(data.toHexString)")
                    DispatchQueue.main.asyncAfter(deadline: 5, execute: { alert.close() })
                }
            } catch {
                print("errpr: \(error)")
                DispatchQueue.main.async {
                    alert.setSubTitle("固件升级失败: \(error)")
                    DispatchQueue.main.asyncAfter(deadline: 5, execute: { alert.close() })
                }
            }
        }
        OperationQueueManager.sharedInstance.addOperation(operation, for: profile.peripheral.identifier)
    }
    
    @objc public func upgradeTypeSelect(button: UIButton) {
        DispatchQueue.main.async {
            let type: UInt8 = button.tag.toU8
            
            if let upgradeType = UpgradeFirmwareType(rawValue: type) {
                self.upgradeTypeAlert?.close()
                self.firmwareList(type: upgradeType)
            }
        }
    }
}

extension DeviceViewController {
    static func firmwareFolder() -> (path: String, folderName: String) {
        let folderName = "firmwareFile"
        var filePath: String = NSHomeDirectory()
        filePath += "/Documents/"
        filePath += "\(folderName)"
        return (filePath, folderName)
    }
}

extension DeviceViewController {
    private func createButton(title: String, xPos: CGFloat, yPos: CGFloat, width: CGFloat) -> UIButton {
        // Add button
        let btn = SCLButton(frame: CGRect(x: xPos, y: yPos, width: width, height: 30.0))
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColorFromRGB(0xA429FF)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(self.upgradeTypeSelect(button:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }
}
