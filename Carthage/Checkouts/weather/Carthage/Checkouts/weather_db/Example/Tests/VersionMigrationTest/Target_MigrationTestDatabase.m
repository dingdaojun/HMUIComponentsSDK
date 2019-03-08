//
//  Target_MigrationTestDatabase.m
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import "Target_MigrationTestDatabase.h"
#import "HMDBTestWeatherMiagrator.h"

@implementation Target_MigrationTestDatabase

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params{
    BOOL isMig = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMig"];
    if (!isMig) {
        return nil;
    }
    
    return [[HMDBTestWeatherMiagrator alloc] init];
}

@end
