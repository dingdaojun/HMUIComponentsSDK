//  HMStatisticAnonymousMigratior.m
//  Created on 2018/6/25
//  Description 数据库版本迁移器

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMStatisticAnonymousMigratior.h"
#import "HMStatisticAnonymousMigrationStep_2.h"

@implementation HMStatisticAnonymousMigratior

- (NSArray *)migrationVersionList {
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary {
    return @{@"2":[HMStatisticAnonymousMigrationStep_2 class]};
}

@end
