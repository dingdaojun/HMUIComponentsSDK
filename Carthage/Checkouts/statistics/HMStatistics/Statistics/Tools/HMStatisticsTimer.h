//  HMStatisticsTimer.h
//  Created on 2018/5/11
//  Description 定时器

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HMStatisticsTimerStatus) {
    HMStatisticsTimerStatusResume,       //执行中
    HMStatisticsTimerStatusSuspend,      //暂停
    HMStatisticsTimerStatusStop,         //关闭
};


@interface HMStatisticsTimer : NSObject

@property(nonatomic, readonly) HMStatisticsTimerStatus timerStatus; // 定时器状态

+ (HMStatisticsTimer *)timerRepeatintWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block;

/**
 恢复
 */
- (void)resumeTask;

/**
 暂停
 */
- (void)suspendTask;

/**
 关闭
 */
- (void)stopTask;

@end
