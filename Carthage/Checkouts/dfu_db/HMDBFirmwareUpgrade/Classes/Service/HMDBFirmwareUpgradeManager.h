//  HMDBFirmwareUpgradeManager.h
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import <Foundation/Foundation.h>
#import "HMDBFirmwareUpgradeInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMDBFirmwareUpgradeManager : NSObject

#pragma mark - 查询操作

/**
 查询所有数据库记录信息

 @return 所有数据库记录信息
 */
- (NSArray<id <HMDBFirmwareUpgradeInfoProtocol> > *)allInfos;

/**
 查询某台硬件所有对应所有固件信息

 @param deviceSource 硬件设备类型
 @param productVersion 硬件设备版本
 @return 某台硬件所有对应所有固件信息
 */
- (NSArray<id <HMDBFirmwareUpgradeInfoProtocol> > *)fetchInfoWithDeviceSource:(NSInteger)deviceSource
                                                               productVersion:(NSInteger)productVersion;
/**
 查询特定设备特定文件类型信息

 @param deviceSource 设备类型
 @param fileType 文件类型
 @return 查询结果
 */
- (id <HMDBFirmwareUpgradeInfoProtocol> _Nullable)fetchInfoWithDeviceSource:(NSInteger)deviceSource fwFileType:(NSInteger)fileType;

#pragma mark - 更新操作

/**
 新增或更新一条固件信息

 @param info 待操作数据
 @return 操作所附带的错误信息，若返回 nil 则表示操作成功，否则表示为空
 */
- (NSError * _Nullable)addOrUpdateFirmwareUpgradeInfo:(id<HMDBFirmwareUpgradeInfoProtocol>)info;

#pragma mark - 删除操作

/**
 删除数据库中所有固件信息
 */
- (void)removeAllInfos;


/**
 删除某台硬件所有对应所有固件信息

 @param deviceSource 硬件设备类型
 @param productVersion 硬件设备版本
 @return 操作所附带的错误信息，若返回 nil 则表示操作成功，否则表示为空
 */
- (NSError * _Nullable)removeInfoWithDeviceSource:(NSInteger)deviceSource
                                   productVersion:(NSInteger)productVersion;

/**
 删除特定设备特定文件类型信息

 @param deviceSource 设备类型
 @param fileType 文件类型
 @return 操作所附带的错误信息，若返回 nil 则表示操作成功，否则表示为空
 */
- (NSError * _Nullable)removeInfoWithDeviceSource:(NSInteger)deviceSource
                                       fwFileType:(NSInteger)fileType;

@end

NS_ASSUME_NONNULL_END
