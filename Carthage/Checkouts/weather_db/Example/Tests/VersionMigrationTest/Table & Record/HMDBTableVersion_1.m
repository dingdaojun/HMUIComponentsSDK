//
//  HMDBTableVersion_1.m
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import "HMDBTableVersion_1.h"
#import "HMDBRecordVersion_1.h"

@implementation HMDBTableVersion_1

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
             @"recordUpdateTimeInterval":@"INTEGER"
             };
}

- (Class)recordClass {
    return [HMDBRecordVersion_1 class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}
@end
