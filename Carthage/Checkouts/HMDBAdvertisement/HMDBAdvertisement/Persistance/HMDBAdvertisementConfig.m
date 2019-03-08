//  HMDBAdvertisementConfig.m
//  Created on 2018/5/30
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBAdvertisementConfig.h"
#import <CTPersistance/CTPersistance.h>

NSString *const kHMDBAdvertisementErrorDomain = @"HMDBBAdvertisementErrorDomain";
static NSString *const kHMDBAdvertisementDataBaseName = @"HMDBAdvertisementDataBaseName";
static NSString *advertisementDBConfigUserID = @"";

@implementation HMDBAdvertisementConfig

/**
 获取数据库路径

 @return 数据库路径
 */
+ (NSString *)dataBasePath {

    NSString *databaseFilePath = [NSString stringWithFormat:@"%@.sqlite", kHMDBAdvertisementDataBaseName];

    if (advertisementDBConfigUserID && ![advertisementDBConfigUserID isEqualToString:@""]) {
        databaseFilePath = [advertisementDBConfigUserID stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kHMDBAdvertisementDataBaseName]];
    }

    return databaseFilePath;
}

/**
 配置用户 ID
 */
+ (void)configUserID:(NSString *)userID {
    advertisementDBConfigUserID = userID;
}

/**
 清空数据库

 @return 错误
 */
+ (NSError * _Nullable)clearDatabase {
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[HMDBAdvertisementConfig dataBasePath]];

    NSError *error = nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];

    // 关闭数据库连接
    [[CTPersistanceDatabasePool sharedInstance] closeDatabaseWithName:[HMDBAdvertisementConfig dataBasePath]];

    if ([fileManager fileExistsAtPath:dbPath]) {
        [fileManager removeItemAtPath:dbPath error:&error];
    } else {
        error = [NSError errorWithDomain:kHMDBAdvertisementErrorDomain code:HMDBAdvertisementErrorFileNotFound userInfo:nil];
    }

    if (!error) {
        advertisementDBConfigUserID = @"";
    }

    return error;
}

@end
