//
//  DeviceDetailProfile.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2017/11/29.
//  Copyright © 2017年 葱泥. All rights reserved.
//

import Foundation

struct Feature {
    var featureName: String
    var featureAction: Selector
}

struct DeviceDataSource {
    static func feature(peripheralName: String) -> (featureList: Dictionary<String, Array<Feature>>, typeList: Array<String>)? {
        if peripheralName == ProfileName.huaShan.rawValue ||
           peripheralName == ProfileName.beatsL.rawValue ||
           peripheralName == ProfileName.chongqing.rawValue ||
           peripheralName == ProfileName.beatsH.rawValue ||
           peripheralName == ProfileName.miBand3.rawValue  ||
           peripheralName == ProfileName.dth.rawValue {
            return (["基础": self.baseFeature() + proBaseFeature(),
                     "NFC": self.nfcFeature()],
                    ["基础", "NFC"])
        } else if peripheralName == ProfileName.healthBand.rawValue ||
                  peripheralName == ProfileName.miBand2.rawValue ||
                  peripheralName == ProfileName.arc.rawValue ||
                  peripheralName == ProfileName.mars.rawValue ||
                  peripheralName == ProfileName.chaohu.rawValue {
            var baseFeature: Array<Feature> = []
            baseFeature += self.baseFeature()
            baseFeature += self.proBaseFeature()
            
            return (["基础": baseFeature], ["基础"])
        }
        
        return nil
    }
    
    private static func nfcFeature() -> Array<Feature> {
        return [Feature(featureName: "打开通道", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "发送Apdu数据", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "打开主通道(雪球)", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "打开逻辑通道(雪球)", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "发送transmit数据(雪球)", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "关闭通道(雪球)", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "关闭通道", featureAction: #selector(DeviceViewController.findPeripheralAction)),]
    }
    
    private static func huashanBase() -> Array<Feature> {
        var baseFeature = self.baseFeature()
        baseFeature.append(Feature(featureName: "固件升级", featureAction: #selector(DeviceViewController.findPeripheralAction)))
        return baseFeature
    }
    
    private static func proBaseFeature() -> Array<Feature> {
        return [Feature(featureName: "实时心率", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "固件升级", featureAction: #selector(DeviceViewController.upgradeFirmware)),]
    }
    
    private static func baseFeature() -> Array<Feature> {
        return [Feature(featureName: "同步", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "电池", featureAction: #selector(DeviceViewController.readBattery)),
                Feature(featureName: "查找设备", featureAction: #selector(DeviceViewController.findDevice)),
                Feature(featureName: "设置时间", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "设备信息", featureAction: #selector(DeviceViewController.readDeviceInfomation)),
                Feature(featureName: "ANCS", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "实时步数", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "传感器", featureAction: #selector(DeviceViewController.findPeripheralAction)),
                Feature(featureName: "左右手", featureAction: #selector(DeviceViewController.wearLocationForHand)),
                Feature(featureName: "ECF", featureAction: #selector(DeviceViewController.ecfService)),]
    }
}
