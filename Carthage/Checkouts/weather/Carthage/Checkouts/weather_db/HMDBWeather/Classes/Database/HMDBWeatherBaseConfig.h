//  HMDBWeatherBaseConfig.h
//  Created on 18/12/2017
//  Description 天气数据库基本配置

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kHMDBWeatherErrorDomain;

typedef NS_ENUM(NSInteger, HMDBWeatherError) {
    HMDBWeatherErrorFileNotFound = 1001,   // 数据库文件不存在
    HMDBWeatherErrorObjectIsNil,           // 对象为空
};

@interface HMDBWeatherBaseConfig : NSObject

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
+ (NSString *)userID;

/**
 清空数据库
 
 @return 错误
 */
+ (NSError * _Nullable)clearDatabase;

@end

NS_ASSUME_NONNULL_END
