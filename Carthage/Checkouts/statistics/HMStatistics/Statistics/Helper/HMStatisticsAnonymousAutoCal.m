//  HMStatisticsAnonymousAutoCal.m
//  Created on 2018/4/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsAnonymousAutoCal.h"
#import "HMStatisticsLog+Inner.h"
#import "HMStatisticsSafeCache.h"

@interface HMStatisticsAnonymousAutoCal()

@property(strong, nonatomic) HMStatisticsSafeCache *safeCache;
@property(strong, nonatomic) NSMutableArray *allBackupPages;

@end

@implementation HMStatisticsAnonymousAutoCal

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HMStatisticsAnonymousAutoCal *shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HMStatisticsAnonymousAutoCal alloc] init];
        shareInstance.safeCache = [[HMStatisticsSafeCache alloc] init];
        shareInstance.allBackupPages = [[NSMutableArray alloc] initWithCapacity:3];
    });

    return shareInstance;
}

/**
 开始自动统计

 @param pageName 页面名称
 */
- (void)beginPage:(NSString *)pageName {
    
    NSAssert(pageName != nil, @"pageName can't be nil");

    if (!pageName) {
        return;
    }

    NSDate *beginDate = [_safeCache getCacheForKey:pageName];

    NSAssert(beginDate == nil, @"don't recall beginPage with same page before endPage is finished");
    
    // 不能重复调用
    if (beginDate) {
        return;
    }

    NSDate *date = [NSDate date];

    [_safeCache cacheObject:date forKey:pageName];

    NSLog(@"hmStatisticsSwizzling_viewWillAppear: %@", pageName);
}

/**
 结束自动统计

 @param pageName 页面名称
 */
- (void)endPage:(NSString *)pageName {
    NSAssert(pageName != nil, @"pageName can't be nil");

    if (!pageName) {
        return;
    }
    
    NSDate *beginDate = [_safeCache getCacheForKey:pageName];

    // 不能先调用 endPage
    if (!beginDate) {
        return;
    }

    NSDate *endDate = [NSDate date];

    // 毫秒数计算
    double durationSeconds = endDate.timeIntervalSince1970 - beginDate.timeIntervalSince1970;

    long long milSeconds = durationSeconds * 1000;

    double doubleMilSeconds = milSeconds;

    [HMStatisticsLog logPageDuration:doubleMilSeconds pageName:pageName];

    [_safeCache removeCacheObjectForKey:pageName];

    NSLog(@"hmStatisticsSwizzling_viewWillDisappear: %@", pageName);
}

#pragma mark - APP 后台事件处理，提高自动统计时间准确性

/**
 进入前台
 */
- (void)foregroundBeginAutoCal {

    for (NSString *pageName in self.allBackupPages) {
        [self beginPage:pageName];
    }

    [self.allBackupPages removeAllObjects];
}

/**
 进入后台
 */
- (void)backgroundEndAutoCal {

    self.allBackupPages = [[_safeCache getAllCacheKeys] mutableCopy];

    for (NSString *pageName in self.allBackupPages) {
        [self endPage:pageName];
    }
}

@end
