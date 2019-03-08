//
//  HMDBTableVersion_2.m
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import "HMDBTableVersion_2.h"
#import "HMDBRecordVersion_2.h"

@implementation HMDBTableVersion_2

- (NSString *)tableName {
    return @"current_weather";
}

- (NSString *)databaseName {
    return @"MigrationTestDatabase_version.sqlite";
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"weatherPublishTime":@"TEXT",
             @"weatherType":@"INTEGER",
             @"temperature":@"INTEGER",
             @"temperatureUnit":@"TEXT",
             @"recordUpdateTimeInterval":@"INTEGER",
             @"locationKey":@"TEXT"
             };
}

- (Class)recordClass {
    return [HMDBRecordVersion_2 class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
