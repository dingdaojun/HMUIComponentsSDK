//  THMDBFirmwareUpgradeMigrators.m
//  Created on 4/6/2017
//  Description 数据库迁移迁移

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBFirmwareUpgradeMigrators.h"
#import "HMDBFirmwareUpgradeMigrationStep_2.h"

@implementation HMDBFirmwareUpgradeMigrators

- (NSArray *)migrationVersionList
{
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary
{
    return @{@"2":[HMDBFirmwareUpgradeMigrationStep_2 class]};
}

@end
