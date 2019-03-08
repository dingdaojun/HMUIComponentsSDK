//  HMStatisticsTimer.m
//  Created on 2018/5/11
//  Description 定时器

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsTimer.h"

@interface HMStatisticsTimer()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign, readwrite) HMStatisticsTimerStatus timerStatus;

@end

@implementation HMStatisticsTimer

#pragma mark - Public API
+ (HMStatisticsTimer *)timerRepeatintWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block {

    NSParameterAssert(seconds);
    NSParameterAssert(block);

    HMStatisticsTimer *statisticTimer = [[HMStatisticsTimer alloc] init];
    statisticTimer.timerStatus = HMStatisticsTimerStatusStop;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    statisticTimer.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    statisticTimer.lock = dispatch_semaphore_create(1);

    dispatch_time_t start = dispatch_walltime(NULL, (int64_t)(0.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(statisticTimer.timer, start, interval, 0);
    dispatch_source_set_event_handler(statisticTimer.timer, ^{
        block();
    });

    [statisticTimer resumeTimer];

    return statisticTimer;
}

- (void)resumeTask {
    if (_timerStatus != HMStatisticsTimerStatusSuspend) {
        return;
    }

    [self resumeTimer];
}

- (void)suspendTask {
    if (_timerStatus != HMStatisticsTimerStatusResume) {
        return;
    }

    [self suspendTimer];
}

- (void)stopTask {
    if (_timerStatus != HMStatisticsTimerStatusResume) {
        return;
    }

    [self stopTimer];
}

- (void)dealloc {
    [self stopTimer];
}

#pragma mark - Timer

- (void)resumeTimer {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_resume(self.timer);
        _timerStatus = HMStatisticsTimerStatusResume;
    }
    dispatch_semaphore_signal(self.lock);
}

- (void)suspendTimer {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_suspend(self.timer);
        _timerStatus = HMStatisticsTimerStatusSuspend;
    }
    dispatch_semaphore_signal(self.lock);
}

- (void)stopTimer {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        _timerStatus = HMStatisticsTimerStatusStop;
        self.timer = nil;
    }
    dispatch_semaphore_signal(self.lock);
}

@end
