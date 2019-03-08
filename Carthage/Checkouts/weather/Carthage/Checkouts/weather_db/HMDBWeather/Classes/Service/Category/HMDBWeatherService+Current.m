//  HMDBWeatherService+Current.m
//  Created on 18/12/2017
//  Description 当前天气接口

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService+Current.h"
#import "HMDBCurrentWeatherRecord+Protocol.h"
#import "HMDBCurrentWeatherTable.h"

@implementation HMDBWeatherService (Current)

#pragma mark - 查询操作

/**
 获取所有实时天气记录

 @return 当前所有实时天气
 */
- (NSArray<id<HMDBCurrentWeatherProtocol>> *)allCurrentWeather {
    NSError *error = nil;

    HMDBCurrentWeatherTable *table = [[HMDBCurrentWeatherTable alloc] init];

    NSArray *allRecords = [table findAllWithError:&error];

    if (error) {
        return  @[];
    }

    return allRecords;
}

/**
 获取某地的实时天气

 @param locationKey 地区标识
 @return 实时天气记录
 */
- (id<HMDBCurrentWeatherProtocol> _Nullable)currentWeatherAt:(NSString *)locationKey {

    NSError *error = nil;

    HMDBCurrentWeatherTable *table = [[HMDBCurrentWeatherTable alloc] init];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE locationKey = '%@' ",table.tableName,locationKey];

    NSArray *allRecords = [table findAllWithSQL:sqlString params:nil error:&error];

    if (error) {
        return nil;
    }

    if (allRecords.count < 1) {
        return nil;
    }

    return [allRecords firstObject];
}

#pragma mark - 更新操作

/**
 新增或者更新实时天气信息

 @param currenWeather 待新增数据
 @return 是否操作成功
 */
- (NSError * _Nullable)addOrUpdateCurrenWeather:(id<HMDBCurrentWeatherProtocol>)currentWeather {

    // 移除已有记录
    NSError *error = [self removeCurrrentAt:currentWeather.dbLocationKey];

    if (error) {
        return  error;
    }

    HMDBCurrentWeatherRecord *record = [[HMDBCurrentWeatherRecord alloc] initWithProtocol:currentWeather];

    HMDBCurrentWeatherTable *table = [[HMDBCurrentWeatherTable alloc] init];

    record.identifier = nil;
    [table insertRecord:record error:&error];

    return error;
}


#pragma mark - 删除操作
/**
 移除某地区的实时天气记录

 @param locationKey 地区标识
 @return 实时天气记录
 */
- (NSError * _Nullable)removeCurrrentAt:(NSString *)locationKey {
    NSError *error = nil;

    HMDBCurrentWeatherTable *table = [[HMDBCurrentWeatherTable alloc] init];

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE locationKey = '%@'",table.tableName,locationKey];

    [table executeSQL:sql error:&error];

    return error;
}

/**
 删除所有空气质量信息

 @return 是否删除成功
 */
- (BOOL)removeAllCurrentWeather {
    HMDBCurrentWeatherTable *table = [[HMDBCurrentWeatherTable alloc] init];
    [table truncate];

    return YES;
}
@end
