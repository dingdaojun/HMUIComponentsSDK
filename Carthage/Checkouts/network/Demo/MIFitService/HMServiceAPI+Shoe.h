//
//  HMServiceAPI+Shoe.h
//  HMNetworkLayer
//
//  Created by 李宪 on 15/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>
/**
 跑鞋步伐数据
 */
@protocol HMServiceAPIShoeStepData <NSObject>

@property (nonatomic, assign, readonly) NSUInteger api_shoeStepDataStepCountGoal;               // 步数目标
@property (nonatomic, assign, readonly) NSUInteger api_shoeStepDataStepCount;                   // 步数
@property (nonatomic, assign, readonly) double api_shoeStepDataDistanceInMeters;                // 距离米数
@property (nonatomic, assign, readonly) double api_shoeStepDataCalorie;                         // 卡路里
@property (nonatomic, assign, readonly) NSUInteger api_shoeStepDataWalkingMinutes;              // 步行分钟数
@property (nonatomic, assign, readonly) NSUInteger api_shoeStepDataRunningStepCount;            // 跑步步数
@property (nonatomic, assign, readonly) NSUInteger api_shoeStepDataFrontFootStepCount;          // 跑步前脚掌着地数（标准跑步姿势）
@property (nonatomic, assign, readonly) NSUInteger api_shoeStepDataRunningMinutes;              // 跑步分钟数
@property (nonatomic, assign, readonly) double api_shoeStepDataRunningDistance;                 // 跑步距离米数
@property (nonatomic, assign, readonly) double api_shoeStepDataRunningCalorie;                  // 跑步卡路里

@end

/**
 跑鞋数据
 */
@protocol HMServiceAPIShoeData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_shoeDataDate;                                       // 日期
@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_shoeDataDeviceSource;              // 跑鞋的source
@property (nonatomic, copy, readonly) NSString *api_shoeDataDeviceID;                                   // 跑鞋的设备ID
@property (nonatomic, copy, readonly) NSString *api_shoeDataSerialNumber;                               // 跑鞋的序列号

@property (nonatomic, strong, readonly) id<HMServiceAPIShoeStepData>api_shoeDataStepData;               // 步伐数据
@property (nonatomic, strong, readonly) NSData *api_shoeDataRawData;                                    // 原始数据

@end


@protocol HMServiceShoeAPI <HMServiceAPI>

/**
 上传跑鞋运动数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=77
 @param lastSyncTime 最后一次同步数据时间
 @param uuid iOS设备的UUID
 */
- (id<HMCancelableAPI>)shoe_uploadShoeData:(id<HMServiceAPIShoeData>)data
                              lastSyncTime:(NSDate *)lastSyncTime
                             iOSDeviceUUID:(NSString *)uuid
                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取跑鞋运动数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=76
 @param beginDate 开始日期。传nil则为从最早数据记录开始
 @param endDate 结束日期。传nil则为到最新数据记录
 @param skipRawData 是否略过原始数据。YES返回数据中不包含原始数据，NO返回数据包含原始数据
 */
- (id<HMCancelableAPI>)shoe_shoeDatasFromDate:(NSDate *)beginDate
                                       toDate:(NSDate *)endDate
                                  skipRawData:(BOOL)skipRawData
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIShoeData>> *shoeDatas))completionBlock;
@end

@interface HMServiceAPI (Shoe) <HMServiceShoeAPI>
@end
