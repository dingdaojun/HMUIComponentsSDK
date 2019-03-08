//
//  NSObject+Async.m
//  MiFit
//
//  Created by JateXu on 9/23/16.
//  Copyright © 2016 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//


#import "NSObject+Async.h"


@implementation NSObject(Async)


#pragma mark 等待执行
- (void)waitPerfomBlock:(HM_AsyncCallBody)body {
    [self waitTime:DISPATCH_TIME_FOREVER ToPerfomBlock:body];
}

#pragma mark 等待执行，时间
- (void)waitTime:(unsigned long long)seconds ToPerfomBlock:(HM_AsyncCallBody)body {
    if (!body) {
        return ;
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);

    HM_AsyncCallLeave leave = ^(void) {
        dispatch_group_leave(group);
    };

    body(leave);
    dispatch_group_wait(group, seconds);
}

@end
