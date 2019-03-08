//  HMDBCurrentWeatherTable.m
//  Created on 18/12/2017
//  Description 当前天气 Table

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBCurrentWeatherTable.h"
#import "HMDBWeatherBaseConfig.h"
#import "HMDBCurrentWeatherRecord.h"

@implementation HMDBCurrentWeatherTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"current_weather";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMDBWeatherBaseConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"weatherPublishTime":@"TEXT",
             @"weatherType":@"INTEGER",
             @"temperature":@"INTEGER",
             @"temperatureUnit":@"TEXT",
             @"recordUpdateTimeInterval":@"INTEGER",
             @"locationKey": @"TEXT"
             };
}

- (Class)recordClass {
    return [HMDBCurrentWeatherRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
