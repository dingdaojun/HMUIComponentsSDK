//  HMStatisticsAnonymousConfig.m
//  Created on 2018/4/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsAnonymousConfig.h"
#import <CTPersistance/CTPersistance.h>

@implementation HMStatisticsAnonymousConfig

/**
 获取数据库名称

 @return 数据库名称
 */
+ (NSString *)dataBaseName {
    return @"HMStatisticsAnonymousDB";
}

/**
 清空数据库

 @return 是否操作成功
 */
+ (BOOL)clearDatabase {
    NSString* dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ] stringByAppendingPathComponent:@"HMStatistics"];

    NSString *databaseFilePath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", [HMStatisticsAnonymousConfig dataBaseName]]];

    NSError *error = nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];

    // 关闭数据库连接
    [[CTPersistanceDatabasePool sharedInstance] closeDatabaseWithName:[HMStatisticsAnonymousConfig dataBaseName]];

    if ([fileManager fileExistsAtPath:databaseFilePath]) {
        [fileManager removeItemAtPath:databaseFilePath error:&error];
    } else {
        return NO;
    }

    if (error) {
        return NO;
    }

    return YES;
}

@end
