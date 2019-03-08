//  HMStatisticsNamedContextTable.m
//  Created on 2018/6/25
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMStatisticsNamedContextTable.h"
#import "HMStatisticsNamedContextRecord.h"
#import "HMStatisticsNamedConfig.h"

@implementation HMStatisticsNamedContextTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"anonymous_contex";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMStatisticsNamedConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"bundleIdentifier":@"TEXT NOT NULL",
             @"deviceName":@"TEXT NOT NULL",
             @"hmID":@"TEXT NOT NULL",
             @"sysVersion":@"TEXT NOT NULL",
             @"appVersion":@"TEXT NOT NULL",
             @"localeIdentifier":@"TEXT NOT NULL",
             @"eventVersion":@"TEXT NOT NULL",
             @"sdkVersion":@"TEXT NOT NULL",
             @"networkStatus":@"TEXT NOT NULL",
             @"screenInfo":@"TEXT NOT NULL",
             @"appChannel":@"TEXT NOT NULL",
             @"platform":@"TEXT NOT NULL"
             };
}

- (Class)recordClass {
    return [HMStatisticsNamedContextRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
