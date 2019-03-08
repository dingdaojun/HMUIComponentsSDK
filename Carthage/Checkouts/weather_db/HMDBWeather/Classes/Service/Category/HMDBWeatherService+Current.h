//  HMDBWeatherService+Current.h
//  Created on 18/12/2017
//  Description 当前天气接口，数据库中只保存一条记录

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService.h"
#import "HMDBCurrentWeatherProtocol.h"

/*======================================================
 实时模块

 修改记录：
 版本 1: 数据库中只保存一条记录
 版本 2: 新增 locationKey 用于标示城市，一个 location 对应唯一一条记录
 =====================================================*/

NS_ASSUME_NONNULL_BEGIN

@interface HMDBWeatherService (Current)

#pragma mark - 查询操作

/**
 获取所有实时天气记录

 @return 当前所有实时天气
 */
- (NSArray<id<HMDBCurrentWeatherProtocol>> *)allCurrentWeather;

/**
 获取某地的实时天气

 @param locationKey 地区标识
 @return 实时天气记录
 */
- (id<HMDBCurrentWeatherProtocol> _Nullable)currentWeatherAt:(NSString *)locationKey;
#pragma mark - 更新操作

/**
 新增或者更新实时天气信息，同一 LocationKey 只保存一条记录

 @param currentWeather 待新增数据
 @return 是否操作成功
 */
- (NSError * _Nullable)addOrUpdateCurrenWeather:(id<HMDBCurrentWeatherProtocol>)currentWeather;


#pragma mark - 删除操作

/**
 移除某地区的实时天气记录

 @param locationKey 地区标识
 @return 是否删除成功
 */
- (NSError * _Nullable)removeCurrrentAt:(NSString *)locationKey;

/**
 删除所有空气质量信息

 @return 是否删除成功
 */
- (BOOL)removeAllCurrentWeather;

@end

NS_ASSUME_NONNULL_END
