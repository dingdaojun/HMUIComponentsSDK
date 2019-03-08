//  HMDBFirmwareUpgradeBaseConfig.h
//  Created on 14/12/2017
//  Description CTPersistance 配置信息  类名为 Target_*数据库名*

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kHMDBFirmwareUpgradeErrorDomain;
typedef NS_ENUM(NSInteger, HMDBFirmwareUpgradeError) {
    HMDBFirmwareUpgradeErrorUnknown      = 1000,   // 未知错误
    HMDBFirmwareUpgradeErrorFileNotFound,          // 数据库文件不存在
    HMDBFirmwareUpgradeErrorInfoInvalid            // 待操作数据无效
};

@interface HMDBFirmwareUpgradeBaseConfig : NSObject

/**
 获取数据库名称
 
 @return 数据库名称
 */
+ (NSString *)dataBaseName;

/**
 配置用户 ID
 */
+ (void)configUserID:(NSString *)userID;

/**
 获取用户 ID
 
 @return 获取用户 iD
 */
+ (NSString*)userID;

/**
 清空数据库
 
 @return 错误
 */
+ (NSError * _Nullable)clearDatabase;

@end


NS_ASSUME_NONNULL_END
