//  HMDBWeatherService+Forecast.h
//  Created on 19/12/2017
//  Description 天气预报接口

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService.h"
#import "HMDBWeatherForecastProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMDBWeatherService (Forecast)

#pragma mark - 查询操作

/**
 查询所有天气预报信息

 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)allWeatherForecast;

/**
 查询某地区所有天气预报信息

 @param locationKey 地区标识
 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)weatherForecastAt:(NSString *)locationKey;

/**
 查询某地区某时间之前的 N 条预报信息，不包括 beforeAtTime 所对应记录

 @param count 需要的记录条数
 @param beforeAtTime 查询时间条件
 @param locationKey 地区标识
 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)lastNWeatherForecast:(NSInteger)count
                                                          beforeAt:(NSDate *)beforeAtTime
                                                      withLocation:(NSString *)locationKey;

/**
 查询某地区某时间之后的 N 条预报信息， 不包括 afterAtTime 所对应记录

 @param count 需要的记录条数
 @param afterAtTime 查询时间条件
 @param locationKey 地区标识
 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)lastNWeatherForecast:(NSInteger)count
                                                           afterAt:(NSDate *)afterAtTime
                                                      withLocation:(NSString *)locationKey;

#pragma mark - 更新操作

/**
 更新天气预报信息

 @param forecasts 待更新数据
 @return 是否操作成功
 */

- (NSError * _Nullable)addWeatherForecasts:(NSArray<id<HMDBWeatherForecastProtocol>> *)forecasts;

#pragma mark - 删除操作

/**
 删除某地区某时间之前的 N 条预报信息，不包括 beforeAtTime 所对应记录

 @param count 需要的记录条数
 @param beforeAtTime 查询时间条件
 @param locationKey 地区标识
 @return 查询结果
 */
- (NSError * _Nullable)deleteNWeatherForecast:(NSInteger)count
                      beforeAt:(NSDate *)beforeAtTime
                  withLocation:(NSString *)locationKey;

/**
 删除某地区某时间之后的 N 条预报信息， 不包括 afterAtTime 所对应记录

 @param count 需要的记录条数
 @param afterAtTime 查询时间条件
 @param locationKey 地区标识
 @return 是否操作成功
 */
- (NSError * _Nullable)deleteNWeatherForecast:(NSInteger)count
                       afterAt:(NSDate *)afterAtTime
                  withLocation:(NSString *)locationKey;

/**
 删除某地区所有预报信息

 @param locationKey 地区标识
 @return 是否操作成功
 */
- (NSError * _Nullable)deleteWeatherForecastAt:(NSString *)locationKey;

/**
 删除所有天气预报信息

 @return 是否操作成功
 */
- (BOOL)removeAllWeatherForecast;

@end

NS_ASSUME_NONNULL_END
