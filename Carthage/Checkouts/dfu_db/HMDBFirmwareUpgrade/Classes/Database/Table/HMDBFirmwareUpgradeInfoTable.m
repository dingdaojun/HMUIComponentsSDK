//  HMDBFirmwareUpgradeInfoTable.m
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com


#import "HMDBFirmwareUpgradeInfoTable.h"
#import "HMDBFirmwareUpgradeInfoRecord.h"
#import "HMDBFirmwareUpgradeBaseConfig.h"

@implementation HMDBFirmwareUpgradeInfoTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName {
    return @"firmware_infoV2";
}

- (NSString *)databaseName {
    return [NSString stringWithFormat:@"%@.sqlite", [HMDBFirmwareUpgradeBaseConfig dataBaseName]];
}

- (NSDictionary *)columnInfo {
    return @{
             @"identifier": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"productVersion":@"INTEGER",
             @"deviceSource":@"INTEGER NOT NULL",
             @"firmwareVersion":@"TEXT NOT NULL",
             @"firmwareName":@"TEXT",
             @"firmwareURL":@"TEXT",
             @"firmwareLocalPath":@"TEXT",
             @"firmwareMD5":@"TEXT",
             @"firmwareUpgradeType":@"INTEGER",
             @"latestAbandonUpdateVersion":@"TEXT",
             @"isCompressionFile":@"INTEGER",
             @"isShowDeviceRedPoint":@"INTEGER",
             @"isShowTabRedPoint":@"INTEGER",
             @"latestAbandonUpdateTimeInterval":@"INTEGER",
             @"firmwareFileType":@"INTEGER",
             @"firmwareLanguangeFamily":@"INTEGER",
             @"extensionValue":@"TEXT"
             };
}

- (Class)recordClass {
    return [HMDBFirmwareUpgradeInfoRecord class];
}

- (NSString *)primaryKeyName {
    return @"identifier";
}

@end
