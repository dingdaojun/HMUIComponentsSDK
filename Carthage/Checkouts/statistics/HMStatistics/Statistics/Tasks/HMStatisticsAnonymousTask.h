//  HMStatisticsAnonymousTask.h
//  Created on 2018/4/13
//  Description 匿名统计上传任务管理

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@class HMStatisticsAnonymousRecord,HMStatisticsConfig,HMStatisticsAnonymousContextRecord;

@interface HMStatisticsAnonymousTask : NSObject

@property(assign, nonatomic, readonly) BOOL  isServiceStart;    // 标记服务开启状态

/**
 匿名统计任务单例

 @return 单例对象
 */
+ (instancetype)sharedInstance;

/**
 获取配置渠道 ID
 
 @return 返回配置 ChannelID
 */
- (NSString *)configChannelID;

/**
 启动匿名统计任务操作

 @param config 配置项
 */
- (void)startOperationWithConfig:(HMStatisticsConfig *)config;

/**
 关闭操作
 */
- (void)stopOperation;

/**
 处理实时事件统计

 @param events 实时事件
 @param context 上下文
 */
- (void)processRealTimeEventLog:(NSArray<HMStatisticsAnonymousRecord *> *)events withContext:(HMStatisticsAnonymousContextRecord *)context;

/**
 匿名流量消耗

 @return 匿名流量消耗，单位 MB
 */
- (double)totalTraffic;

@end
