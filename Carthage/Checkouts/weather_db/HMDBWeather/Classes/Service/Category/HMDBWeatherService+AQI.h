//  HMDBWeatherService+AQI.h
//  Created on 19/12/2017
//  Description 空气质量接口，数据库中只保存一条记录

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService.h"
#import "HMDBWeatherAQIProtocol.h"

/*======================================================
 空气质量模块

 修改记录：
 版本 1: 数据库中只保存一条记录
 版本 2: 新增 locationKey 用于标示城市，一个 location 对应唯一一条记录
 =====================================================*/
NS_ASSUME_NONNULL_BEGIN

@interface HMDBWeatherService (AQI)

#pragma mark - 查询操作
/**
 获取所有 AQI 记录

 @return 所有 AQI 记录
 */
- (NSArray<id<HMDBWeatherAQIProtocol> > *)allAQI;

/**
 获取某地的 AQI 记录

 @param locationKey 城市标识
 @return 某城市当前的 AQI 记录
 */
- (id<HMDBWeatherAQIProtocol> _Nullable)currentAQIAt:(NSString *)locationKey;

#pragma mark - 更新操作

/**
 新增或者更新空气质量信息  数据库中只保存一条记录

 @param weatherAQI 待新增数据
 @return 是否操作成功，为 nil 表示成功
 */
- (NSError * _Nullable)addOrUpdateAQIRecord:(id<HMDBWeatherAQIProtocol>)weatherAQI;


#pragma mark - 删除操作

/**
 删除某地的 AQI 记录

 @param locationKey 城市标识
 @return 是否操作成功，为 nil 表示成功
 */
- (NSError * _Nullable)removeAQIAt:(NSString *)locationKey;

/**
 删除所有空气质量信息

 @return 是否操作成功
 */
- (BOOL)removeAllAQI;

@end

NS_ASSUME_NONNULL_END
