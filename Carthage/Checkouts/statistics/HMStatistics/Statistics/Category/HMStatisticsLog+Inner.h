//  HMStatisticsLog+Inner.h
//  Created on 2018/4/13
//  Description SDK 内部事件处理

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMStatisticsLog.h"

@interface HMStatisticsLog (PageDuration)

/**
 页面时长自动匿名统计

 @param duration 时长
 @param pageName 页面名称
 */
+ (void)logPageDuration:(double)duration
               pageName:(NSString *)pageName;

@end
