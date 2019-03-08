//  Target_HMDBFirmwareUpgrade.m
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "Target_HMDBFirmwareUpgrade.h"
#import "HMDBFirmwareUpgradeBaseConfig.h"
#import "HMDBFirmwareUpgradeMigrators.h"

@implementation Target_HMDBFirmwareUpgrade

- (NSString *)Action_filePath:(NSDictionary *)params {
    NSString *dataBaseName = [params objectForKey:kCTPersistanceConfigurationParamsKeyDatabaseName];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:dataBaseName];
    
    
    NSString *userID = [HMDBFirmwareUpgradeBaseConfig userID];
    
    if (userID && ![userID isEqualToString:@""]) {
        NSString *dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ] stringByAppendingPathComponent:userID];
        filePath = [dir stringByAppendingPathComponent:dataBaseName];
    }
    
    return filePath;
}

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params {
    return [[HMDBFirmwareUpgradeMigrators alloc] init];
}

@end
