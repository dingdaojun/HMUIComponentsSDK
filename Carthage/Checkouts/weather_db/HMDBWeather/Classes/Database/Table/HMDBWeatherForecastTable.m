//  HMDBWeatherForecastTable.m
//  Created on 19/12/2017
//  Description 天气预报数据表

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherForecastTable.h"
#import "HMDBWeatherBaseConfig.h"
#import "HMDBWeatherForecastRecord.h"

@implementation HMDBWeatherForecastTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"weather_forcast";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMDBWeatherBaseConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"forecastPublishTime":@"TEXT",
             @"weatherFromValue":@"INTEGER",
             @"weatherToValue":@"INTEGER",
             @"temperatureFromValue":@"INTEGER",
             @"temperatureToValue":@"INTEGER",
             @"temperatureUnit":@"TEXT",
             @"recordUpdateTimeInterval":@"INTEGER",
             @"forecastDateTimeInterval":@"INTEGER NOT NULL UNIQUE",
             @"sunriseDateString":@"TEXT",
             @"sunsetDateString":@"TEXT",
             @"locationKey": @"TEXT"
             };
}

- (Class)recordClass {
    return [HMDBWeatherForecastRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
