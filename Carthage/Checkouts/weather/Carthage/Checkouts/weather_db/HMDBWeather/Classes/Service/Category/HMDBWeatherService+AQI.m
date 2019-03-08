//  HMDBWeatherService+AQI.m
//  Created on 19/12/2017
//  Description 空气质量接口

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherService+AQI.h"
#import "HMDBWeatherAQIRecord+Protocol.h"
#import "HMDBWeatherAQITable.h"

@implementation HMDBWeatherService (AQI)

#pragma mark - 查询操作

/**
 获取所有 AQI 记录

 @return 所有 AQI 记录
 */
- (NSArray<id<HMDBWeatherAQIProtocol> > *)allAQI {
    NSError *error = nil;

    HMDBWeatherAQITable *table = [[HMDBWeatherAQITable alloc] init];

    NSArray *allAQIRecords = [table findAllWithError:&error];

    if (error) {
        return  @[];
    }

    return allAQIRecords;

}

- (id<HMDBWeatherAQIProtocol> _Nullable)currentAQIAt:(NSString *)locationKey {

    NSError *error = nil;

    HMDBWeatherAQITable *table = [[HMDBWeatherAQITable alloc] init];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE locationKey = '%@' ",table.tableName,locationKey];

    NSArray *allAQIRecords = [table findAllWithSQL:sqlString params:nil error:&error];

    if (error) {
        return  nil;
    }

    if (allAQIRecords.count < 1) {
        return nil;
    }

    return [allAQIRecords firstObject];
}

#pragma mark - 更新操作

/**
 新增或者更新空气质量信息

 @param weatherAQI 待新增数据
 @return 是否操作成功
 */
- (NSError * _Nullable)addOrUpdateAQIRecord:(id<HMDBWeatherAQIProtocol>)weatherAQI {

    // 移除已有记录
    NSError *error = [self removeAQIAt:weatherAQI.dbLocationKey];

    if (error) {
        return error;
    }

    HMDBWeatherAQIRecord *record = [[HMDBWeatherAQIRecord alloc] initWithProtocol:weatherAQI];

    HMDBWeatherAQITable *table = [[HMDBWeatherAQITable alloc] init];

    record.identifier = nil;
    [table insertRecord:record error:&error];

    return error;
}


#pragma mark - 删除操作

/**
 删除某地的 AQI 记录

 @param locationKey 城市标识
 @return 是否操作成功
 */
- (NSError * _Nullable)removeAQIAt:(NSString *)locationKey {
    NSError *error = nil;

    HMDBWeatherAQITable *table = [[HMDBWeatherAQITable alloc] init];

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE locationKey = '%@'",table.tableName,locationKey];

    [table executeSQL:sql error:&error];

    return error;
}

/**
 删除所有空气质量信息

 @return 是否操作成功
 */
- (BOOL)removeAllAQI {
    HMDBWeatherAQITable *table = [[HMDBWeatherAQITable alloc] init];
    [table truncate];

    return YES;
}

@end
