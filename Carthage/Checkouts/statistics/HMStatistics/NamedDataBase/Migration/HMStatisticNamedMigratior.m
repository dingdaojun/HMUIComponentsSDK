//  HMStatisticNamedMigratior.m
//  Created on 2018/6/25
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMStatisticNamedMigratior.h"
#import "HMStatisticNamedMigrationStep_2.h"

@implementation HMStatisticNamedMigratior

- (NSArray *)migrationVersionList {
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary {
    return @{@"2":[HMStatisticNamedMigrationStep_2 class]};
}

@end
