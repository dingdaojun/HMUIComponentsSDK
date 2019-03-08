//  HMStatisticsLog+Inner.m
//  Created on 2018/4/13
//  Description 文件描述

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMStatisticsLog+Inner.h"
#import "HMStatisticsLog+LogPersistence.h"
#import "HMStatisticsAnonymousRecord.h"
#import "HMStatisticsTools.h"
#import "HMStatisticsDefine.h"

@implementation HMStatisticsLog (PageDuration)

/**
 页面时长自动匿名统计

 @param duration 时长
 @param pageName 页面名称
 */
+ (void)logPageDuration:(double)duration
               pageName:(NSString *)pageName {

    NSAssert(pageName != nil, @"pageName can't be nil");

    HMStatisticsAnonymousRecord *record = [[HMStatisticsAnonymousRecord alloc] init];
    record.eventID = kHMStatisticsInnerPageDuration;
    record.stringValue = nil;
    record.doubleValue = @(duration);
    record.eventType = kHMStatisticsInnerModule;
    record.eventParams = [HMStatisticsTools convertDicToJSONStr:@{@"PageName":pageName}];
    
    [HMStatisticsLog anonymousEventPersistence:record];
    return;
}

@end
