//  HMDBWeatherBaseConfig.m
//  Created on 18/12/2017
//  Description 天气数据库基本配置

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherBaseConfig.h"
#import <CTPersistance/CTPersistanceDatabasePool.h>

NSString *const kHMDBWeatherErrorDomain = @"kHMDBWeatherErrorDomain";

NSString *const weatherDataBaseName = @"HMDBWeatherDataBase";

NSString *weatherDBConfigUserID = @"";

@implementation HMDBWeatherBaseConfig

/**
 获取数据库名称
 
 @return 数据库名称
 */
+ (NSString * _Nonnull)dataBaseName {
    return weatherDataBaseName;
}


/**
 配置用户 ID
 */
+ (void)configUserID:(NSString *)userID {
    weatherDBConfigUserID = userID;
}

/**
 获取用户 ID
 
 @return 获取用户 iD
 */
+ (NSString *)userID {
    return weatherDBConfigUserID;
}

/**
 清空数据库
 
 @return 错误
 */
+ (NSError * _Nullable)clearDatabase {
    NSString *databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", weatherDataBaseName]];
    
    
    if (weatherDBConfigUserID && ![weatherDBConfigUserID isEqualToString:@""]) {
        NSString* dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]stringByAppendingPathComponent:weatherDBConfigUserID];
        databaseFilePath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", weatherDataBaseName]];
    }
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 关闭数据库连接
    [[CTPersistanceDatabasePool sharedInstance] closeDatabaseWithName:weatherDataBaseName];
    
    if ([fileManager fileExistsAtPath:databaseFilePath]) {
        [fileManager removeItemAtPath:databaseFilePath error:&error];
    } else {
        error = [NSError errorWithDomain:kHMDBWeatherErrorDomain code:HMDBWeatherErrorFileNotFound userInfo:nil];
    }

    if (!error) {
        weatherDBConfigUserID = @"";
    }
    
    return error;
}

@end
