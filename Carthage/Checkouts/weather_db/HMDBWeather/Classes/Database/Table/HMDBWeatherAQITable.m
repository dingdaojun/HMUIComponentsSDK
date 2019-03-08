//  HMDBWeatherAQITable.m
//  Created on 19/12/2017
//  Description 空气质量数据表

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherAQITable.h"
#import "HMDBWeatherBaseConfig.h"
#import "HMDBWeatherAQIRecord.h"

@implementation HMDBWeatherAQITable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"weather_aqi";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMDBWeatherBaseConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"weatherAQIPublishTime":@"TEXT",
             @"valueOfAQI":@"INTEGER",
             @"recordUpdateTimeInterval":@"INTEGER",
             @"locationKey": @"TEXT"
             };
}

- (Class)recordClass {
    return [HMDBWeatherAQIRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
