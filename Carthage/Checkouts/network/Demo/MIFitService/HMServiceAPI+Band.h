//
//  HMServiceAPI+Band.h
//  HMNetworkLayer
//
//  Created by 李宪 on 28/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HMService/HMService.h>

NS_ASSUME_NONNULL_BEGIN

/**
 数据格式定义
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=328
 PS: 由于现在的接口实际上在使用的时候都是将一天的数据一齐上传，因此对于接口定义的数组的格式全部扁平化到上层model中。
 */

@protocol HMServiceAPIBandStepData <NSObject>

@property (nonatomic, assign, readonly) NSUInteger api_bandStepDataStepCountGoal;               // 步数目标
@property (nonatomic, assign, readonly) NSUInteger api_bandStepDataStepCount;                   // 步数
@property (nonatomic, assign, readonly) double api_bandStepDataDistanceInMeters;                // 距离米数
@property (nonatomic, assign, readonly) double api_bandStepDataCalorie;                         // 卡路里
@property (nonatomic, assign, readonly) NSUInteger api_bandStepDataWalkingMinutes;              // 步行分钟数
@property (nonatomic, assign, readonly) NSUInteger api_bandStepDataRunningMinutes;              // 跑步分钟数
@property (nonatomic, assign, readonly) double api_bandStepDataRunningDistance;                 // 跑步距离米数
@property (nonatomic, assign, readonly) double api_bandStepDataRunningCalorie;                  // 跑步卡路里

@end

@protocol HMServiceAPIBandSleepData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_bandSleepDataDate;                          // 日期
@property (nonatomic, strong, readonly) NSDate *api_bandSleepDataStartTime;                     // 开始时间
@property (nonatomic, strong, readonly) NSDate *api_bandSleepDataEndTime;                       // 结束时间
@property (nonatomic, assign, readonly) NSUInteger api_bandSleepDataDeepSleepMinutes;           // 深睡眠分钟数
@property (nonatomic, assign, readonly) NSUInteger api_bandSleepDataLightSleepMinutes;          // 浅睡眠分钟数
@property (nonatomic, assign, readonly) NSUInteger api_bandSleepDataAwakeMinutes;               // 清醒分钟数
@property (nonatomic, assign, readonly) NSUInteger api_bandSleepDataWakeUpCount;                // 清醒次数

@end

@protocol HMServiceAPIBandRawData <NSObject>

@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_bandRawDataDeviceSource;   // 设备Source
@property (nonatomic, copy, readonly, nullable) NSString *api_bandRawDataDeviceID;              // 设备ID
@property (nonatomic, strong, readonly, nullable) NSTimeZone *api_bandRawDataTimeZone;          // 时区

@property (nonatomic, strong, readonly) NSData *api_bandRawDataStepAndSleepRawData;             // 步数+睡眠的原始数据
@property (nonatomic, strong, readonly) NSData *api_bandRawDataHeartRateRawData;                // 心率原始数据

@end

@protocol HMServiceAPIBandData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_bandDataDate;                                   // 日期
@property (nonatomic, strong, readonly) id<HMServiceAPIBandStepData>api_bandDataStepData;           // 步数数据
@property (nonatomic, strong, readonly) id<HMServiceAPIBandSleepData>api_bandDataSleepData;         // 睡眠数据
@property (nonatomic, strong, readonly) id<HMServiceAPIBandRawData>api_bandDataRawData;             // 原始数据

@end


@protocol HMServiceBandAPI <HMServiceAPI>

/**
 上传用户运动数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=42
 @param lastDeviceType 最后一次同步的设备类型
 @param lastDeviceSource 最后一次同步的设备Source
 @param lastDeviceID 最后一次同步的设备ID。如果是手机则为nil。这个地方目前小米运动iOS代码是写@“-1”的。现在接口API内部会判断如果是nil则写@“-1”。如果App继续传@“-1”也可以，但是建议对于这种接口定义的magic number统一用nil，由接口API内部做处理。
 @param lastSyncTime 最后一次同步数据时间
 @param uuid iOS设备的UUID
 */
- (id<HMCancelableAPI>)band_uploadBandData:(id<HMServiceAPIBandData>)data
                            lastDeviceType:(HMServiceAPIDeviceType)lastDeviceType
                          lastDeviceSource:(HMServiceAPIDeviceSource)lastDeviceSource
                              lastDeviceID:(nullable NSString *)lastDeviceID
                              lastSyncTime:(NSDate *)lastSyncTime
                             iOSDeviceUUID:(NSString *)uuid
                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取用户运动数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=43
 @param beginDate 开始日期。传nil则为从最早数据记录开始
 @param endDate 结束日期。传nil则为到最新数据记录
 @param skipRawData 是否略过原始数据。YES返回数据中不包含原始数据，NO返回数据包含原始数据
 */
- (id<HMCancelableAPI>)band_bandDatasFromDate:(nullable NSDate *)beginDate
                                       toDate:(nullable NSDate *)endDate
                                  skipRawData:(BOOL)skipRawData
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBandData>> *bandDatas))completionBlock;

/**
 上传手动编辑睡眠数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=200
 */
- (id<HMCancelableAPI>)band_uploadManullySleepData:(id<HMServiceAPIBandSleepData>)sleepData
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取手动编辑睡眠数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=202
 */
- (id<HMCancelableAPI>)band_manullySleepDataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBandSleepData>> *sleepDatas))completionBlock;


@end

@interface HMServiceAPI (Band) <HMServiceBandAPI>
@end

NS_ASSUME_NONNULL_END
