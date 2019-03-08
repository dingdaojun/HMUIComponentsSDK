//
//  HMServiceAPI+Watch.h
//  HMNetworkLayer
//
//  Created by 李宪 on 11/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

/**
 手表步数数据
 */
@protocol HMServiceAPIWatchStepData <NSObject>

@property (nonatomic, assign, readonly) NSUInteger api_watchStepDataStepCountGoal;               // 步数目标
@property (nonatomic, assign, readonly) NSUInteger api_watchStepDataStepCount;                   // 步数
@property (nonatomic, assign, readonly) double api_watchStepDataDistanceInMeters;                // 距离米数
@property (nonatomic, assign, readonly) double api_watchStepDataCalorie;                         // 卡路里
@property (nonatomic, assign, readonly) NSUInteger api_watchStepDataWalkingMinutes;              // 步行分钟数
@property (nonatomic, assign, readonly) NSUInteger api_watchStepDataRunningMinutes;              // 跑步分钟数
@property (nonatomic, assign, readonly) double api_watchStepDataRunningDistance;                 // 跑步距离米数
@property (nonatomic, assign, readonly) double api_watchStepDataRunningCalorie;                  // 跑步卡路里

@end


/**
 手表睡眠数据
 */
@protocol HMServiceAPIWatchSleepData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_watchSleepDataStartTime;                     // 开始时间
@property (nonatomic, strong, readonly) NSDate *api_watchSleepDataEndTime;                       // 结束时间
@property (nonatomic, assign, readonly) NSUInteger api_watchSleepDataDeepSleepMinutes;           // 深睡眠分钟数
@property (nonatomic, assign, readonly) NSUInteger api_watchSleepDataLightSleepMinutes;          // 浅睡眠分钟数
@property (nonatomic, assign, readonly) NSUInteger api_watchSleepDataAwakeMinutes;               // 清醒分钟数
@property (nonatomic, assign, readonly) NSUInteger api_watchSleepDataWakeUpCount;                // 清醒次数

@end

/**
 手表数据
 */
@protocol HMServiceAPIWatchData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_watchDataDate;                              // 日期
@property (nonatomic, strong, readonly) NSDate *api_watchDataLastSyncTime;                      // 最后一次同步时间

@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_watchDataDeviceSource;     // 设备source

@property (nonatomic, strong, readonly) id<HMServiceAPIWatchStepData>api_watchDataStepData;     // 步伐数据
@property (nonatomic, strong, readonly) id<HMServiceAPIWatchSleepData>api_watchDataSleepData;   // 睡眠数据

@property (nonatomic, strong, readonly) NSData *api_watchDataMergedRawData;                     // 融合原始数据
@property (nonatomic, strong, readonly) NSData *api_watchDataHeartRateRawData;                  // 心率原始数据

@end


@protocol HMServiceWatchAPI <HMServiceAPI>

/**
 获取手表数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=319
 @param beginDate 开始日期，如果是nil则自动取2014-1-1
 @param endDate 开始日期，如果是nil则自动取当前时间（[NSDate date]）
 @param skipRawData 是否过滤原始数据。如果为YES，则返回数据中的api_watchDataMergedRawData和api_watchDataHeartRateRawData都为nil
 */
- (id<HMCancelableAPI>)watch_dataFromDate:(NSDate *)beginDate
                                   toDate:(NSDate *)endDate
                              skipRawData:(BOOL)skipRawData
                          completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIWatchData>> *watchDatas))completionBlock;

@end

@interface HMServiceAPI (Watch) <HMServiceWatchAPI>
@end
