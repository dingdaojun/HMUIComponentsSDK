//  HMStatisticsNamedContextRecord.h
//  Created on 2018/6/25
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMStatisticsNamedContextRecord : CTPersistanceRecord

@property (copy, nonatomic) NSNumber    *identifier;            // 数据库自生成主键
@property (copy, nonatomic) NSString    *bundleIdentifier;      // 安装包名
@property (copy, nonatomic) NSString    *deviceName;            // 设备名
@property (copy, nonatomic) NSString    *hmID;                  // 华米 ID
@property (copy, nonatomic) NSString    *sysVersion;            // 系统版本;
@property (copy, nonatomic) NSString    *appVersion;            // App 版本
@property (copy, nonatomic) NSString    *localeIdentifier;      // 本地化信息
@property (copy, nonatomic) NSString    *eventVersion;          // 事件版本
@property (copy, nonatomic) NSString    *sdkVersion;            // sdk 版本
@property (copy, nonatomic) NSString    *networkStatus;         // 网络状态
@property (copy, nonatomic) NSString    *screenInfo;            // 屏幕分辨率信息
@property (copy, nonatomic) NSString    *appChannel;            // 产品渠道
@property (copy, nonatomic) NSString    *platform;              // 平台

@end
