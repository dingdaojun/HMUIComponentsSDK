//  HMDBAdGeneralResourceTable.m
//  Created on 2018/5/30
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBAdGeneralResourceTable.h"
#import "HMDBAdvertisementConfig.h"
#import "HMDBAdGeneralResourceRecord.h"

@implementation HMDBAdGeneralResourceTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"adGeneralResource";
}

- (NSString *)databaseName {
    return [HMDBAdvertisementConfig dataBasePath];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"resourceType": @"INTEGER NOT NULL",
             @"resourceValue": @"TEXT",
             @"displayPosition": @"TEXT",
             @"generalID": @"INTEGER NOT NULL"
             };
}

- (Class)recordClass {
    return [HMDBAdGeneralResourceRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
