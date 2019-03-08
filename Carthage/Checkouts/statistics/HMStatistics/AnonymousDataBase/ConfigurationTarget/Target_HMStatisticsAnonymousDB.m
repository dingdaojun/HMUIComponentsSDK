//  Target_HMStatisticsAnonymousDB.m
//  Created on 2018/4/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "Target_HMStatisticsAnonymousDB.h"
#import "HMStatisticsAnonymousConfig.h"
#import "HMStatisticAnonymousMigratior.h"

@implementation Target_HMStatisticsAnonymousDB

/**
 数据库路径配置接口

 @param params 参数，详见 CTPersistanceConfigurationTarget
 @return 数据库路径
 */
- (NSString *)Action_filePath:(NSDictionary *)params {
    NSString *dataBaseName = [params objectForKey:kCTPersistanceConfigurationParamsKeyDatabaseName];

    if(!dataBaseName) {
        dataBaseName = [HMStatisticsAnonymousConfig dataBaseName];
    }

    NSString *dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]stringByAppendingPathComponent:@"HMStatistics"];

    return [dir stringByAppendingPathComponent:dataBaseName];
}

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params {
    return [[HMStatisticAnonymousMigratior alloc] init];
}

@end
