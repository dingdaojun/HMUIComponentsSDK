//  HMDBAdvertisementConfig.h
//  Created on 2018/5/30
//  Description

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

extern NSString* const kHMDBAdvertisementErrorDomain;
typedef NS_ENUM(NSInteger, HMDBAdvertisementError) {
    HMDBAdvertisementErrorUnknown      = 1000,   // 未知错误
    HMDBAdvertisementErrorFileNotFound,          // 数据库文件不存在
    HMDBAdvertisementErrorInfoInvalid            // 待操作数据无效
};

NS_ASSUME_NONNULL_BEGIN

@interface HMDBAdvertisementConfig : NSObject

/**
 获取数据库路径

 @return 数据库路径
 */
+ (NSString *)dataBasePath;

/**
 配置用户 ID
 */
+ (void)configUserID:(NSString *)userID;

/**
 清空数据库

 @return 错误
 */
+ (NSError * _Nullable)clearDatabase;

@end

NS_ASSUME_NONNULL_END
