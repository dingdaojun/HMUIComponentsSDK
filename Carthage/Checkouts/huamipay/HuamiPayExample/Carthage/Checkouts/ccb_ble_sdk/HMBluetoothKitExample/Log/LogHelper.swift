//
//  LogHelper.swift
//  HMBluetoothKitExample
//
//  Created by 余彪 on 2018/3/6.
//  Copyright © 2018年 葱泥. All rights reserved.
//

import Foundation
import HMLog

/// log 错误定义
public enum Tag: String {
    case auth = "认证"
    case buildProfile = "建立Profile"
    case disConnect = "断开连接"
    case readDeviceInfomation = "读取设备信息"
    case noInfomation = "没有设备信息"
    case reConnect = "重连"
    case sensorLose = "传感器数据丢失"
    case activityLose = "活动数据丢失"
}

public func log(level: HMLogLevel, tag: Tag, stackLevel: Int, function: String = #function, format: String...) {
    let manager = HMLogManager.sharedInstance()
    let content = format.reduce("", +)
    manager?.recordLog(with: level, tag: tag.rawValue, file: #file, line: UInt(#line), function: function, content: content, stackLevel: UInt(stackLevel))
}

public func logV(tag: Tag, format: String...) {
    let content = format.reduce("", +)
    log(level: .verbose, tag: tag, stackLevel: 0, format: content)
}

public func logI(tag: Tag, format: String...) {
    let content = format.reduce("", +)
    log(level: .info, tag: tag, stackLevel: 0, format: content)
}

public func logD(tag: Tag, format: String...) {
    let content = format.reduce("", +)
    log(level: .debug, tag: tag, stackLevel: 0, format: content)
}

public func logW(tag: Tag, format: String...) {
    let content = format.reduce("", +)
    log(level: .warning, tag: tag, stackLevel: 0, format: content)
}

public func logE(tag: Tag, format: String...) {
    let content = format.reduce("", +)
    log(level: .error, tag: tag, stackLevel: 0, format: content)
}

public func logF(tag: Tag, format: String...) {
    let content = format.reduce("", +)
    log(level: .fatal, tag: tag, stackLevel: 0, format: content)
}

struct LogHelper {
    static let logFloder = "/BLELog"
    static func logConfig() -> HMLogConfiguration {
        let configuration = HMLogConfiguration.default()
        configuration?.consoleTimeZone = 8
        configuration?.databaseMaximumLogItems = 10000
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let cacheDirectory = directories.first!;
        let root = cacheDirectory + logFloder
        HMLogConfiguration.rootDirectory = root
        return configuration!
    }
}
