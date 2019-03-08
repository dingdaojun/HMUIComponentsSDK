//  HMDBWeatherService+Forecast.m
//  Created on 19/12/2017
//  Description 天气预报接口

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService+Forecast.h"
#import "HMDBWeatherForecastRecord+Protocol.h"
#import "HMDBWeatherForecastTable.h"

@implementation HMDBWeatherService (Forecast)

#pragma mark - 查询操作
/**
 查询所有天气预报信息

 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)allWeatherForecast {
    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    NSArray *allInfos = [table findAllWithError:&error];

    if (error) {
        return @[];
    }

    return allInfos;
}

/**
 查询某地区所有天气预报信息

 @param locationKey 地区标识
 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)weatherForecastAt:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE  locationKey = '%@' ",table.tableName,locationKey];

    NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];

    if (error) {
        return @[];
    }

    return results;
}

/**
 查询某地区某时间之前的 N 条预报信息，不包括 beforeAtTime 所对应记录

 @param count 需要的记录条数
 @param beforeAtTime 查询时间条件
 @param locationKey 地区标识
 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)lastNWeatherForecast:(NSInteger)count
                                                          beforeAt:(NSDate *)beforeAtTime
                                                      withLocation:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    long long milliSeconds = [beforeAtTime timeIntervalSince1970] * 1000;

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE forecastDateTimeInterval < %lld AND locationKey = '%@' LIMIT %ld",table.tableName,milliSeconds,locationKey,count];

    NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];

    if (error) {
        return @[];
    }

    return results;
}

/**
 查询某地区某时间之后的 N 条预报信息， 不包括 afterAtTime 所对应记录

 @param count 需要的记录条数
 @param afterAtTime 查询时间条件
 @param locationKey 地区标识
 @return 查询结果
 */
- (NSArray<id<HMDBWeatherForecastProtocol>> *)lastNWeatherForecast:(NSInteger)count
                                                           afterAt:(NSDate *)afterAtTime
                                                      withLocation:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    long long milliSeconds = [afterAtTime timeIntervalSince1970] * 1000;

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE forecastDateTimeInterval > %lld AND locationKey = '%@' LIMIT %ld",table.tableName,milliSeconds,locationKey,count];

    NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];

    if (error) {
        return @[];
    }

    return results;
}

#pragma mark - 更新操作

/**
 更新天气预报信息

 @param forecasts 待更新数据
 @return 是否操作成功
 */

- (NSError * _Nullable)addWeatherForecasts:(NSArray<id<HMDBWeatherForecastProtocol>> *)forecasts {

    NSMutableArray *forecastModels = [NSMutableArray array];

    for (id<HMDBWeatherForecastProtocol> protocol in forecasts) {
        HMDBWeatherForecastRecord *record = [[HMDBWeatherForecastRecord alloc] initWithProtocol:protocol];
        record.identifier  = nil;
        [forecastModels addObject:record];
    }

    if (forecastModels.count < 1) {
        return nil;
    }

    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    [table insertRecordList:forecastModels error:&error];

    return error;
}

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
                  withLocation:(NSString *)locationKey {

    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    long long milliSeconds = [beforeAtTime timeIntervalSince1970] * 1000;

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE forecastDateTimeInterval < %lld AND locationKey = '%@' LIMIT %ld",table.tableName,milliSeconds,locationKey,count];

    NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];


    [table deleteRecordList:results error:&error];

    return error;
}

/**
 删除某地区某时间之后的 N 条预报信息， 不包括 afterAtTime 所对应记录

 @param count 需要的记录条数
 @param afterAtTime 查询时间条件
 @param locationKey 地区标识
 @return 是否操作成功
 */
- (NSError * _Nullable)deleteNWeatherForecast:(NSInteger)count
                       afterAt:(NSDate *)afterAtTime
                  withLocation:(NSString *)locationKey {

    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    long long milliSeconds = [afterAtTime timeIntervalSince1970] * 1000;

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE forecastDateTimeInterval > %lld AND locationKey = '%@' LIMIT %ld",table.tableName,milliSeconds,locationKey,count];

    NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];


    [table deleteRecordList:results error:&error];

    return error;
}

/**
 删除某地区所有预报信息

 @param locationKey 地区标识
 @return 是否操作成功
 */
- (NSError * _Nullable)deleteWeatherForecastAt:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE locationKey = '%@'",table.tableName,locationKey];

    [table executeSQL:sql error:&error];

    return error;
}

/**
 删除所有天气预报信息

 @return 是否操作成功
 */
- (BOOL)removeAllWeatherForecast {
    HMDBWeatherForecastTable *table = [[HMDBWeatherForecastTable alloc] init];
    [table truncate];

    return YES;
}

@end
