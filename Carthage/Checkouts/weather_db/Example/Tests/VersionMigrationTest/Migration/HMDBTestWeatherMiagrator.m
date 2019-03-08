//
//  HMDBTestWeatherMiagrator.m
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import "HMDBTestWeatherMiagrator.h"
#import "HMDBWeatherTestMigrationStep_2.h"

@implementation HMDBTestWeatherMiagrator

- (NSArray *)migrationVersionList {
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary {
    return @{@"2":[HMDBWeatherTestMigrationStep_2 class]};
}

@end
