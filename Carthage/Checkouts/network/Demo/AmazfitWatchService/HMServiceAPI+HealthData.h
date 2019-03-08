//
//  HMServiceAPI+HealthData.h
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIHealthData <NSObject>

@property (readonly) NSDate *api_healthDataDate;                                     // 日期
@property (readonly) NSData *api_healthDataHeartRateData;                            // 心率原始数据
@property (readonly) NSData *api_healthDataMergedRawData;                            // 步伐、睡眠原始数据

@property (readonly) NSUInteger api_healthDataStepGoal;                              // 步数目标
@property (readonly) NSUInteger api_healthDataStepCount;                             // 步数
@property (readonly) NSUInteger api_healthDataDistanceInMeters;                      // 距离
@property (readonly) NSUInteger api_healthDataEnergyBurnedInKilocalorie;             // 能量消耗
@property (readonly) NSUInteger api_healthDataActiveMinutes;                         // 活动时长
@property (readonly) NSUInteger api_healthDataClimbedFloors;                         // 爬楼层数

@property (readonly) NSInteger api_healthDataSleepStartMinute;                       // 睡眠开始分钟数（相对今天开始）
@property (readonly) NSInteger api_healthDataSleepEndMinute;                         // 睡眠结束分钟数（相对今天开始）
@property (readonly) NSUInteger api_healthDataDeepSleepMinutes;                      // 深睡眠分钟数
@property (readonly) NSUInteger api_healthDataLightSleepMinutes;                     // 浅睡眠分钟数
@property (readonly) NSUInteger api_healthDataAwakeMinutes;                          // 清醒分钟数
@property (readonly) NSUInteger api_healthDataWakeUpCount;                           // 醒来次数

@end


@protocol HMHealthDataServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)healthData_retrieveWithStartDate:(NSDate *)date
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHealthData>> *healthDatas))completionBlock;

- (void)healthData_retrieveAllDataFromDate:(NSDate *)date
                           completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHealthData>> *healthDatas))completionBlock;

- (id<HMCancelableAPI>)healthData_retrieveUpdateTimeWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSDate *updateTime))completionBlock;

@end


@interface HMServiceAPI (HealthData) <HMHealthDataServiceAPI>
@end
