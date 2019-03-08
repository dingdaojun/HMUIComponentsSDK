//  HMDBFirmwareUpgradeBaseConfig.m
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBFirmwareUpgradeBaseConfig.h"
#import <CTPersistance/CTPersistanceDatabasePool.h>

NSString *const kHMDBFirmwareUpgradeErrorDomain = @"HMDBFirmwareUpgradeErrorDomain";
static NSString *const firmwareUpgradeDataBaseName = @"HMDBFirmwareUpgrade";
static NSString *firmwareUpgradeDBConfigUserID = @"";

@implementation HMDBFirmwareUpgradeBaseConfig

/**
 获取数据库名称
 
 @return 数据库名称
 */
+ (NSString *)dataBaseName {
    return firmwareUpgradeDataBaseName;
}

/**
 配置用户 ID
 */
+ (void)configUserID:(NSString *)userID {
    firmwareUpgradeDBConfigUserID = userID;
}

/**
 获取用户 ID
 
 @return 获取用户 iD
 */
+ (NSString *)userID {
    return firmwareUpgradeDBConfigUserID;
}

/**
 清空数据库
 
 @return 错误
 */
+ (NSError * _Nullable)clearDatabase {
    NSString *databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", firmwareUpgradeDataBaseName]];
    
    if (firmwareUpgradeDBConfigUserID && ![firmwareUpgradeDBConfigUserID isEqualToString:@""]) {
        NSString* dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]stringByAppendingPathComponent:firmwareUpgradeDBConfigUserID];
        databaseFilePath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", firmwareUpgradeDataBaseName]];
    }
    
    NSError *error = nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    // 关闭数据库连接
    [[CTPersistanceDatabasePool sharedInstance] closeDatabaseWithName:firmwareUpgradeDataBaseName];
    
    if ([fileManager fileExistsAtPath:databaseFilePath]) {
        [fileManager removeItemAtPath:databaseFilePath error:&error];
    } else {
        error = [NSError errorWithDomain:kHMDBFirmwareUpgradeErrorDomain code:HMDBFirmwareUpgradeErrorFileNotFound userInfo:nil];
    }

    if (!error) {
        firmwareUpgradeDBConfigUserID = @"";
    }
    
    return error;
}


@end
