//  HMDBFirmwareUpgradeInfoProtocol.h
//  Created on 2018/6/27
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>

@protocol HMDBFirmwareUpgradeInfoProtocol <NSObject>

// 硬件设备版本
@property (nonatomic, readonly)    NSInteger     dbProductVersion;
// 硬件设备类型
@property (nonatomic, readonly)    NSInteger     dbDeviceSource;
// 固件版本
@property (nonatomic, readonly)    NSString      *dbFirmwareVersion;
// 固件名称
@property (nonatomic, readonly)    NSString      *dbFirmwareName;
// 固件服务器资源 URL
@property (nonatomic, readonly)    NSString      *dbFirmwareURL;
// 固件所在路径
@property (nonatomic, readonly)    NSString      *dbFirmwareLocalPath;
// 固件 MD5 值
@property (nonatomic, readonly)    NSString      *dbFirmwareMD5;
// 固件更新类型
@property (nonatomic, readonly)    NSInteger     dbFirmwareUpgradeType;
// 点击暂不升级时的版本
@property (nonatomic, readonly)    NSString      *dbLatestAbandonUpdateVersion;
// 是否为压缩文件
@property (nonatomic, readonly)    BOOL          dbIsCompressionFile;
// 我的设备入口小红点
@property (nonatomic, readonly)    BOOL          dbIsShowDeviceRedPoint;
// Tabbar小红点
@property (nonatomic, readonly)    BOOL          dbIsShowTabRedPoint;
// 点击暂不升级的时间
@property (nonatomic, readonly)    NSDate       *dbLatestAbandonUpdateTime;
// 固件文件类型
@property (nonatomic, readonly)    NSInteger    dbFirmwareFileType;
// 固件语言
@property (nonatomic, readonly)    NSInteger    dbFirmwareLanguangeFamily;
// 点击暂不升级时的版本
@property (nonatomic, readonly)    NSString     *dbExtensionValue;

@end
