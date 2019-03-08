//  HMStatisticsLog.m
//  Created on 12/01/2018
//  Description 统计信息的主入口

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsLog.h"
#import "HMStatisticsTools.h"
#import "HMStatisticsAnonymousRecord.h"
#import "HMStatisticsNamedRecord.h"
#import "HMStatisticsAnonymousTask.h"
#import "HMStatisticsNamedTask.h"
#import "HMStatisticsLog+LogPersistence.h"
#import "HMStatisticsDefine.h"

@implementation HMStatisticsLog

#pragma mark - Main Interface

/* ==========================================
 统计模块服务主入口函数：

 startWithConfig: 主要在 APP 启动时启动统计服务
 restartWithConfig: 主要用于在用户账号切换时重启统计服务
 stopLogServiceWithTypes: 暂停服务
 ===========================================*/

/**
启动统计服务，一般在应用启动时调用

@param config 配置信息
@param types 服务类型
*/
+ (void)startWithConfig:(HMStatisticsConfig *)config andTypes:(HMStatisticsServiceType)types {
    // 匿名服务开启
    if ( (types & HMStatisticsServiceTypeAnonymous) == HMStatisticsServiceTypeAnonymous) {
        [[HMStatisticsAnonymousTask sharedInstance] startOperationWithConfig:config];
    }

    // 实名服务开启
    if ((types & HMStatisticsServiceTypeNamed) == HMStatisticsServiceTypeNamed) {
        [[HMStatisticsNamedTask sharedInstance] startOperationWithConfig:config];
    }
}

/**
 停止打点服务

 @param types 服务类型
 */
+ (void)stopLogServiceWithTypes:(HMStatisticsServiceType)types {

    // 匿名服务
    if ( (types & HMStatisticsServiceTypeAnonymous) == HMStatisticsServiceTypeAnonymous) {
        [[HMStatisticsAnonymousTask sharedInstance] stopOperation];
    }

    // 实名服务
    if ((types & HMStatisticsServiceTypeNamed) == HMStatisticsServiceTypeNamed) {
        [[HMStatisticsNamedTask sharedInstance] stopOperation];
    }
}

#pragma mark -  Counting Interface
/* ==========================================
 计数模块：主要用于统计事件次数相关内容。

 涉及三种情形：无参、单字符串参、非结构化多参

 ===========================================*/

/**
 计数模块无参模式统计接口

 @param eventID 事件 ID
 @param isAnonymous 是否为匿名：YES - 匿名， NO - 实名
 */
+ (void)logEvent:(NSString *)eventID
     isAnonymous:(BOOL)isAnonymous {
    [HMStatisticsLog logEvent:eventID stringValue:@"" isAnonymous:isAnonymous];
}

/**
 计数模块单参模式统计接口

 @param eventID 事件 ID
 @param stringValue 标记参数
 @param isAnonymous 是否为匿名：YES - 匿名， NO - 实名
 */
+ (void)logEvent:(NSString *)eventID
     stringValue:(NSString *)stringValue
     isAnonymous:(BOOL)isAnonymous {

    // 匿名事件持久化
    if (isAnonymous) {
        HMStatisticsAnonymousRecord *record = [[HMStatisticsAnonymousRecord alloc] init];
        record.eventID = eventID;
        record.stringValue = stringValue;
        record.doubleValue = nil;
        record.eventType = kHMStatisticsCountingModule;
        [HMStatisticsLog anonymousEventPersistence:record];
        return;
    }

    // 具名事件持久化
    HMStatisticsNamedRecord *record = [[HMStatisticsNamedRecord alloc] init];
    record.eventID = eventID;
    record.stringValue = stringValue;
    record.doubleValue = nil;
    record.eventType = kHMStatisticsCountingModule;
    record.huamiID = [[HMStatisticsNamedTask sharedInstance] configUserID];

    [HMStatisticsLog namedEventPersistence:record];

    return;
}

/**
 计数模块多参数模式统计接口

 @param eventID 事件 ID
 @param extendParameters 非结构化多参数
 @param isAnonymous 是否为匿名：YES - 匿名， NO - 实名
 */
+ (void)logEvent:(NSString *)eventID
     extendValue:(NSDictionary *)extendParameters
     isAnonymous:(BOOL)isAnonymous {

    // 匿名事件持久化
    if (isAnonymous) {
        HMStatisticsAnonymousRecord *record = [[HMStatisticsAnonymousRecord alloc] init];
        record.eventID = eventID;
        record.stringValue = @"";
        record.doubleValue = nil;
        record.eventType = kHMStatisticsCountingModule;
        record.eventParams = [HMStatisticsTools convertDicToJSONStr:extendParameters];
        [HMStatisticsLog anonymousEventPersistence:record];
        return;
    }

    // 具名事件持久化
    HMStatisticsNamedRecord *record = [[HMStatisticsNamedRecord alloc] init];
    record.eventID = eventID;
    record.stringValue = @"";
    record.doubleValue = nil;
    record.eventType = kHMStatisticsCountingModule;
    record.eventParams = [HMStatisticsTools convertDicToJSONStr:extendParameters];
    record.huamiID = [[HMStatisticsNamedTask sharedInstance] configUserID];

    [HMStatisticsLog namedEventPersistence:record];

    return;
}

#pragma mark -  Calculation Interface
/* ==========================================
 计算模块：主要用于统计数值计算相关事件。

 涉及两种种情形：单数值型参、单数值型 + 非结构化多参

 ===========================================*/

/**
 计算模块单数值型接口

 @param eventID 事件 ID
 @param doubleValue 数值参数
 @param isAnonymous 是否为匿名：YES - 匿名， NO - 实名
 */
+ (void)logEvent:(NSString *)eventID
     doubleValue:(double)doubleValue
     isAnonymous:(BOOL)isAnonymous {

    // 匿名事件持久化
    if (isAnonymous) {
        HMStatisticsAnonymousRecord *record = [[HMStatisticsAnonymousRecord alloc] init];
        record.eventID = eventID;
        record.stringValue = nil;
        record.eventType = kHMStatisticsCalculationModule;
        record.doubleValue = @(doubleValue);
        [HMStatisticsLog anonymousEventPersistence:record];
        return;
    }

    // 具名事件持久化
    HMStatisticsNamedRecord *record = [[HMStatisticsNamedRecord alloc] init];
    record.eventID = eventID;
    record.stringValue = nil;
    record.doubleValue = @(doubleValue);
    record.eventType = kHMStatisticsCalculationModule;
    record.huamiID = [[HMStatisticsNamedTask sharedInstance] configUserID];

    [HMStatisticsLog namedEventPersistence:record];

    return;
}

/**
 计算模块

 @param eventID 事件 ID
 @param doubleValue 数值参数
 @param extendParameters 非结构化多参数
 @param isAnonymous 是否为匿名：YES - 匿名， NO - 实名
 */
+ (void)logEvent:(NSString *)eventID
     doubleValue:(double)doubleValue
     extendValue:(NSDictionary *)extendParameters
     isAnonymous:(BOOL)isAnonymous {

    // 匿名事件持久化
    if (isAnonymous) {
        HMStatisticsAnonymousRecord *record = [[HMStatisticsAnonymousRecord alloc] init];
        record.eventID = eventID;
        record.stringValue = nil;
        record.doubleValue = @(doubleValue);
        record.eventType = kHMStatisticsCalculationModule;
        record.eventParams = [HMStatisticsTools convertDicToJSONStr:extendParameters];
        [HMStatisticsLog anonymousEventPersistence:record];
        return;
    }

    // 具名事件持久化
    HMStatisticsNamedRecord *record = [[HMStatisticsNamedRecord alloc] init];
    record.eventID = eventID;
    record.stringValue = nil;
    record.doubleValue = @(doubleValue);
    record.eventType = kHMStatisticsCalculationModule;
    record.eventParams = [HMStatisticsTools convertDicToJSONStr:extendParameters];
    record.huamiID = [[HMStatisticsNamedTask sharedInstance] configUserID];

    [HMStatisticsLog namedEventPersistence:record];

    return;
}


#pragma mark -  DevInfo Interface
/* ==========================================
 开发模块：主要用于 Dev 测试时获取 SDK 信息

 ===========================================*/

/**
 特定模式下的流量统计

 @param types 模式类型
 @return 流量消耗单位 MB
 */
+ (double)totalTrafficUnderTypes:(HMStatisticsServiceType)types {
    double total = 0.0;

    // 匿名服务
    if ( (types & HMStatisticsServiceTypeAnonymous) == HMStatisticsServiceTypeAnonymous) {
        total += [[HMStatisticsAnonymousTask sharedInstance] totalTraffic];
    }

    // 实名服务
    if ((types & HMStatisticsServiceTypeNamed) == HMStatisticsServiceTypeNamed) {
        total += [[HMStatisticsNamedTask sharedInstance] totalTraffic];
    }

    return total;
}

@end
