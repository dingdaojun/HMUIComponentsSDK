//
//  HMLogger.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogger.h"

@implementation HMLogger

#pragma mark - HMLogger

- (void)recordLogItem:(HMLogItem *)item {
    NSAssert(NO, @"subclass must implement this method");
}

#pragma mark - Factory

+ (instancetype)loggerWithConfiguration:(HMLogConfiguration *)configuration {
    HMLogger *logger = [[[self class] alloc] init];
    logger.configuration = configuration;
    return logger;
}

@end
