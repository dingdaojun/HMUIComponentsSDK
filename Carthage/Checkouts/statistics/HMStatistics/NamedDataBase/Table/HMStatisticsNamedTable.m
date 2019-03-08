//  HMStatisticsNamedTable.m
//  Created on 2018/4/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsNamedTable.h"
#import "HMStatisticsNamedConfig.h"
#import "HMStatisticsNamedRecord.h"

@implementation HMStatisticsNamedTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"named_event";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMStatisticsNamedConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"eventID":@"TEXT NOT NULL",
             @"huamiID":@"TEXT NOT NULL",
             @"eventTimestamp":@"INTEGER",
             @"eventTimeZone":@"TEXT NOT NULL",
             @"stringValue":@"TEXT",
             @"doubleValue":@"REAL",
             @"eventType":@"TEXT NOT NULL",
             @"eventParams":@"TEXT",
             @"contextID":@"INTEGER"
             };
}

- (Class)recordClass {
    return [HMStatisticsNamedRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
