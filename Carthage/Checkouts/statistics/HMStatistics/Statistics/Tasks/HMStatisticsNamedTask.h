//  HMStatisticsNamedTask.h
//  Created on 2018/4/13
//  Description 具名统计上传管理

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@class HMStatisticsNamedRecord,HMStatisticsConfig,HMStatisticsNamedContextRecord;

@interface HMStatisticsNamedTask : NSObject

@property(assign, nonatomic, readonly) BOOL  isServiceStart; // 标记服务开启状态
/**
 实名统计任务

 @return 单例对象
 */
+ (instancetype)sharedInstance;

/**
 获取配置 UID

 @return 返回配置 UID
 */
- (NSString *)configUserID;

/**
 获取配置渠道 ID
 
 @return 返回配置 ChannelID
 */
- (NSString *)configChannelID;

/**
 启动实名统计任务

 @param config 配置项
 */
- (void)startOperationWithConfig:(HMStatisticsConfig *)config;

/**
 关闭操作
 */
- (void)stopOperation;

/**
 实时统计处理

 @param events 事件
 @param context 上下文
 */
- (void)processRealTimeEventLog:(NSArray<HMStatisticsNamedRecord *> *)events withContext:(HMStatisticsNamedContextRecord *)context;

/**
 实名流量消耗

 @return 实名流量消耗，单位 MB
 */
- (double)totalTraffic;

@end
