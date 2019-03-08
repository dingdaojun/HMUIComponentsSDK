//  HMAdSleepDetailTable.m
//  Created on 2018/5/30
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMAdSleepDetailTable.h"
#import "HMAdSleepDetailRecord.h"
#import "HMDBAdvertisementConfig.h"

@implementation HMAdSleepDetailTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"sleepDetail";
}

- (NSString *)databaseName {
    return [HMDBAdvertisementConfig dataBasePath];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"advertisementID":@"TEXT NOT NULL UNIQUE",
             @"logoImageURL":@"TEXT",
             @"topImageURL":@"TEXT",
             @"analysisImageURL":@"TEXT",
             @"bannerImageURL":@"TEXT",
             @"title":@"TEXT",
             @"subTitle":@"TEXT",
             @"backgroundColorHex":@"TEXT",
             @"homeColorHex":@"TEXT",
             @"themeColorHex":@"TEXT",
             @"webviewLinkURL":@"TEXT",
             @"logoLinkURL":@"TEXT",
             @"endMilliseconds":@"INTEGER"
             };
}

- (Class)recordClass {
    return [HMAdSleepDetailRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
