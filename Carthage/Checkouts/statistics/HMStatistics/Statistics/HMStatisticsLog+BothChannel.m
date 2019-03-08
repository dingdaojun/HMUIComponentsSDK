//  HMStatisticsLog+BothChannel.m
//  Created on 2018/7/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMStatisticsLog+BothChannel.h"

@implementation HMStatisticsLog (BothChannel)

#pragma mark - Both Channel Counting Interface
/* ==========================================
 计数模块：主要用于统计事件次数相关内容。
 
 涉及三种情形：无参、单字符串参、非结构化多参
 
 ===========================================*/

/**
 计数模块无参模式统计接口
 
 @param eventID 事件 ID
 */
+ (void)logEventBothChannel:(NSString *)eventID {
    [HMStatisticsLog logEvent:eventID isAnonymous:YES];
    [HMStatisticsLog logEvent:eventID isAnonymous:NO];
}

/**
 计数模块单参模式统计接口
 
 @param eventID 事件 ID
 @param stringValue 标记参数
 */
+ (void)logEventBothChannel:(NSString *)eventID
                stringValue:(NSString *)stringValue {
    [HMStatisticsLog logEvent:eventID stringValue:stringValue isAnonymous:YES];
    [HMStatisticsLog logEvent:eventID stringValue:stringValue isAnonymous:NO];
}

/**
 计数模块多参数模式统计接口
 
 @param eventID 事件 ID
 @param extendParameters 非结构化多参数
 */
+ (void)logEventBothChannel:(NSString *)eventID
                extendValue:(NSDictionary *)extendParameters {
    [HMStatisticsLog logEvent:eventID extendValue:extendParameters isAnonymous:YES];
    [HMStatisticsLog logEvent:eventID extendValue:extendParameters isAnonymous:NO];
}

#pragma mark - Both Channel Calculation Interface
/* ==========================================
 计算模块：主要用于统计数值计算相关事件。
 
 涉及两种种情形：单数值型参、单数值型 + 非结构化多参
 
 ===========================================*/

/**
 计算模块单数值型接口
 
 @param eventID 事件 ID
 @param doubleValue 数值参数
 */
+ (void)logEventBothChannel:(NSString *)eventID
                doubleValue:(double)doubleValue {
    [HMStatisticsLog logEvent:eventID doubleValue:doubleValue isAnonymous:YES];
    [HMStatisticsLog logEvent:eventID doubleValue:doubleValue isAnonymous:NO];
}

/**
 计算模块
 
 @param eventID 事件 ID
 @param doubleValue 数值参数
 @param extendParameters 非结构化多参数
 */
+ (void)logEventBothChannel:(NSString *)eventID
                doubleValue:(double)doubleValue
                extendValue:(NSDictionary *)extendParameters {
    [HMStatisticsLog logEvent:eventID doubleValue:doubleValue extendValue:extendParameters isAnonymous:YES];
    [HMStatisticsLog logEvent:eventID doubleValue:doubleValue extendValue:extendParameters isAnonymous:NO];
}

@end
