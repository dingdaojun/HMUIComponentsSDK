//  HMDBFirmwareUpgradeInfoRecord.h
//  Created on 14/12/2017
//  Description 设计缺陷，已废弃

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMDBFirmwareUpgradeInfoRecord : CTPersistanceRecord

@property (nonatomic, copy) NSNumber *identifier;  // 数据库记录主键，新增记录时设置为 nil
@property (nonatomic, assign) NSInteger productVersion; // 硬件设备版本
@property (nonatomic, assign) NSInteger deviceSource;   // 硬件设备类型
@property (nonatomic, copy) NSString *firmwareVersion;  // 固件版本
@property (nonatomic, copy) NSString *firmwareName; // 固件名称
@property (nonatomic, copy) NSString *firmwareURL; // 固件服务器资源 URL
@property (nonatomic, copy) NSString *firmwareLocalPath; // 固件所在路径
@property (nonatomic, copy) NSString *firmwareMD5; // 固件 MD5 值
@property (nonatomic, assign) NSInteger firmwareUpgradeType; // 固件更新类型，普通升级、强制升级等
@property (nonatomic, copy) NSString *latestAbandonUpdateVersion; // 点击暂不升级时的版本
@property (nonatomic, assign) BOOL isCompressionFile; // 是否为压缩文件
@property (nonatomic, assign) BOOL isShowDeviceRedPoint; // 我的设备入口小红点
@property (nonatomic, assign) BOOL isShowTabRedPoint; // Tabbar小红点
@property (nonatomic, assign) long long     latestAbandonUpdateTimeInterval; // 点击暂不升级的时间，时间戳毫秒数取整
@property (nonatomic, assign) NSInteger firmwareFileType; // 固件文件类型，默认值 0
@property (nonatomic, assign) NSInteger firmwareLanguangeFamily; // 固件语言，默认值 0
@property (nonatomic, copy) NSString *extensionValue; // 拓展非结构化数据

@end
