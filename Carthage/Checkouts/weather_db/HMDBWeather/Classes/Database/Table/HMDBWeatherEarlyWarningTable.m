//  HMDBWeatherEarlyWarningTable.m
//  Created on 19/12/2017
//  Description 预警信息数据表

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherEarlyWarningTable.h"
#import "HMDBWeatherBaseConfig.h"
#import "HMDBWeatherEarlyWarningRecord.h"

@implementation HMDBWeatherEarlyWarningTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"weather_earlyWarning";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMDBWeatherBaseConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"earlyWarningPublishTime":@"TEXT",
             @"warningID":@"TEXT",
             @"title":@"TEXT",
             @"detail":@"TEXT",
             @"recordUpdateTimeInterval":@"INTEGER",
             @"locationKey": @"TEXT"
             };
}

- (Class)recordClass {
    return [HMDBWeatherEarlyWarningRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
