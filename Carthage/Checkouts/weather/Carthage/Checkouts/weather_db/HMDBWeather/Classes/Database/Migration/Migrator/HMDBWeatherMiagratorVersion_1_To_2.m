//  HMDBWeatherMiagratorVersion_1_To_2.m
//  Created on 2018/5/14
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherMiagratorVersion_1_To_2.h"
#import "HMDBWeatherMigrationStep_2.h"

@implementation HMDBWeatherMiagratorVersion_1_To_2

- (NSArray *)migrationVersionList {
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary {
    return @{@"2":[HMDBWeatherMigrationStep_2 class]};
}

@end
