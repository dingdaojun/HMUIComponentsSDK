//  HMStatisticsAnonymousAutoCal.h
//  Created on 2018/4/13
//  Description 

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@interface HMStatisticsAnonymousAutoCal : NSObject

+ (instancetype)sharedInstance;

/**
 开始自动统计

 @param pageName 页面名称
 */
- (void)beginPage:(NSString *)pageName;

/**
 结束自动统计

 @param pageName 页面名称
 */
- (void)endPage:(NSString *)pageName;

#pragma mark - APP 后台事件处理，提高自动统计时间准确性

/**
 进入前台
 */
- (void)foregroundBeginAutoCal;

/**
 进入后台
 */
- (void)backgroundEndAutoCal;

@end
