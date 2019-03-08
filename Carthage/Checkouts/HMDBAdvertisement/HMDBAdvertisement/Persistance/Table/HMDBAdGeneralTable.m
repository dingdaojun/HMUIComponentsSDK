//  HMDBAdGeneralTable.h
//  Created on 2018/5/30
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBAdGeneralTable.h"
#import "HMDBAdvertisementConfig.h"
#import "HMDBAdGeneralRecord.h"

@implementation HMDBAdGeneralTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"adGeneral";
}

- (NSString *)databaseName {
    return [HMDBAdvertisementConfig dataBasePath];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"adID":@"TEXT NOT NULL",
             @"adModuleType":@"INTEGER NOT NULL",
             @"adWebviewUrl":@"TEXT",
             @"adLogoWebviewUrl":@"TEXT",
             @"adGeneralImage":@"TEXT",
             @"adTitle":@"TEXT",
             @"adSubTitle":@"TEXT",
             @"adEndTime":@"INTEGER"
             };
}

- (Class)recordClass {
    return [HMDBAdGeneralRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
