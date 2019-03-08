//  HMDBWeatherService+EarlyWarning.h
//  Created on 19/12/2017
//  Description 天气预警接口，数据库中只保存一条记录

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService.h"
#import "HMDBWeatherEarlyWarningProtocol.h"

/*======================================================
 天气预警模块

 修改记录：
 版本 1: 数据库中只保存一条记录
 版本 2: 新增 locationKey 用于标示城市，一个 location 对应唯一一条记录
 =====================================================*/
NS_ASSUME_NONNULL_BEGIN

@interface HMDBWeatherService (EarlyWarning)

#pragma mark - 查询操作

/**
 所有天气预警信息

 @return 预警信息
 */
- (NSArray<id<HMDBWeatherEarlyWarningProtocol> > *)allEarlyWarning;

/**
 获取某地区的天气预警信息

 @return 天气预警
 */
- (id<HMDBWeatherEarlyWarningProtocol> _Nullable)earlyWarningAt:(NSString *)locationKey;

#pragma mark - 更新操作

/**
 新增或者更新预警信息 数据库中只保存一条记录

 @param earlyWarning 待新增数据
 @return 是否操作成功
 */
- (NSError * _Nullable)addOrUpdateEarlyWarning:(id<HMDBWeatherEarlyWarningProtocol>)earlyWarning;

#pragma mark - 删除操作

/**
 移除某地区的天气预警记录

 @param locationKey 地区标识
 @return 是否删除成功
 */
- (NSError * _Nullable)removeEarlyWarningAt:(NSString *)locationKey;

/**
 删除所有空气质量信息

 @return 是否删除成功
 */
- (BOOL)removeAllEarlyWarning;


@end

NS_ASSUME_NONNULL_END
