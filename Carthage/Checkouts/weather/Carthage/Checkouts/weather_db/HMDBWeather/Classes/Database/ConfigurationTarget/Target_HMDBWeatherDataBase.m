//  Target_HMDBWeatherDataBase.m
//  Created on 18/12/2017
//  Description CTPersistance 配置信息

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "Target_HMDBWeatherDataBase.h"
#import "HMDBWeatherBaseConfig.h"
#import "HMDBWeatherMiagratorVersion_1_To_2.h"

@implementation Target_HMDBWeatherDataBase

- (NSString *)Action_filePath:(NSDictionary *)params {
    NSString *dataBaseName = [params objectForKey:kCTPersistanceConfigurationParamsKeyDatabaseName];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:dataBaseName];
    
    
    NSString *userID = [HMDBWeatherBaseConfig userID];
    
    if (userID && ![userID isEqualToString:@""]) {
        NSString *dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]stringByAppendingPathComponent:userID];
        filePath = [dir stringByAppendingPathComponent:dataBaseName];
        
    }
    
    return filePath;
}

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params{
    return [[HMDBWeatherMiagratorVersion_1_To_2 alloc] init];
}

@end
