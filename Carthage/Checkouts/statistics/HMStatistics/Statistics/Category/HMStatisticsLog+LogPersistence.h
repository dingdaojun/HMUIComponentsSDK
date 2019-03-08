//  HMStatisticsLog+LogPersistence.h
//  Created on 2018/4/13
//  Description 统计数据持久化

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMStatisticsLog.h"

@class HMStatisticsAnonymousRecord,HMStatisticsNamedRecord;

@interface HMStatisticsLog (LogPersistence)

/**
 匿名统计数据持久化

 @param record 匿名统计数据
 */
+ (void)anonymousEventPersistence:(HMStatisticsAnonymousRecord *)record;

/**
 实名统计数据持久化

 @param record 实名统计数据
 */
+ (void)namedEventPersistence:(HMStatisticsNamedRecord *)record;

@end
