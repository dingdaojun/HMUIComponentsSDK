//  HMDBWeatherService+EarlyWarning.m
//  Created on 19/12/2017
//  Description 天气预警接口

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService+EarlyWarning.h"
#import "HMDBWeatherEarlyWarningRecord+Protocol.h"
#import "HMDBWeatherEarlyWarningTable.h"

@implementation HMDBWeatherService (EarlyWarning)

#pragma mark - 查询操作

/**
 所有天气预警信息

 @return 预警信息
 */
- (NSArray<id<HMDBWeatherEarlyWarningProtocol> > *)allEarlyWarning {
    NSError *error = nil;

    HMDBWeatherEarlyWarningTable *table = [[HMDBWeatherEarlyWarningTable alloc] init];

    NSArray *allRecords = [table findAllWithError:&error];

    if (error) {
        return  @[];
    }

    return allRecords;
}

/**
 获取某地区的天气预警信息

 @return 天气预警
 */
- (id<HMDBWeatherEarlyWarningProtocol> _Nullable)earlyWarningAt:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherEarlyWarningTable *table = [[HMDBWeatherEarlyWarningTable alloc] init];

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
 新增或者更新预警信息

 @param earlyWarning 待新增数据
 @return 是否操作成功
 */
- (NSError * _Nullable)addOrUpdateEarlyWarning:(id<HMDBWeatherEarlyWarningProtocol>)earlyWarning {

    // 移除已有记录
    NSError *error = [self removeEarlyWarningAt:earlyWarning.dbLocationKey];

    if (error) {
        return  error;
    }

    HMDBWeatherEarlyWarningRecord *record = [[HMDBWeatherEarlyWarningRecord alloc] initWithProtocol:earlyWarning];
    record.identifier = nil;

    HMDBWeatherEarlyWarningTable *table = [[HMDBWeatherEarlyWarningTable alloc] init];
    [table insertRecord:record error:&error];

    return error;
}

#pragma mark - 删除操作

/**
 移除某地区的天气预警记录

 @param locationKey 地区标识
 @return 是否删除成功
 */
- (NSError * _Nullable)removeEarlyWarningAt:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherEarlyWarningTable *table = [[HMDBWeatherEarlyWarningTable alloc] init];

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE locationKey = '%@'",table.tableName,locationKey];

    [table executeSQL:sql error:&error];

    return error;
}

/**
 删除所有空气质量信息

 @return 是否删除成功
 */
- (BOOL)removeAllEarlyWarning {
    HMDBWeatherEarlyWarningTable *table = [[HMDBWeatherEarlyWarningTable alloc] init];
    [table truncate];

    return YES;
}

@end
