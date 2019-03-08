//  HMCrashReportService.h
//  Created on 2018/6/15
//  Description 华米 Crash Report Service

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMCrashReportService : NSObject

+ (instancetype)sharedInstance;

/**
 Start crash report service

 @param appID appID
 @param appSecret appSecret
 @param isProduction isProduction
 */
- (void)startWith:(NSString *)appID secret:(NSString *)appSecret production:(BOOL)isProduction;

@end

NS_ASSUME_NONNULL_END
