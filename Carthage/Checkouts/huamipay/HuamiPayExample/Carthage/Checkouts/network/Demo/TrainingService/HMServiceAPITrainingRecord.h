//
//  HMServiceAPITrainingRecord.h
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMServiceAPITrainingAction;

// 心率
@protocol HMServiceAPITrainingRecordHeartRate <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_trainingRecordHeartRateTime;
@property (nonatomic, assign, readonly) NSUInteger api_trainingRecordHeartRateValue;

@end

// 训练记录
@protocol HMServiceAPITrainingRecord <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingRecordID;                                   // ID，实际上是创建时间的时间戳
@property (nonatomic, strong, readonly) NSDate *api_trainingRecordBeginTime;                            // 开始时间
@property (nonatomic, strong, readonly) NSDate *api_trainingRecordEndTime;                              // 结束时间
@property (nonatomic, assign, readonly) NSUInteger api_trainingRecordFinishTrainingTime;                // 此记录对应的是第几次完成训练
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingRecordSpendTime;                     // 用户消耗训练时长
@property (nonatomic, assign, readonly) double api_trainingRecordEnergyBurnedInCalorie;                 // 训练消耗卡路里

@property (nonatomic, copy, readonly) NSString *api_trainingRecordTrainingID;                           // 训练ID
@property (nonatomic, copy, readonly) NSString *api_trainingRecordTrainingName;                         // 训练名称

@property (nonatomic, copy, readonly) NSString *api_trainingRecordTrainingPlanID;                       // 训练课程ID，如果本记录属于某课程时有值

@property (nonatomic, copy, readonly) NSString *api_trainingRecordDetailImageURL;                       // 详情页图片链接

@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPITrainingRecordHeartRate>> *api_trainingRecordHeartRates; // 心率

@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPITrainingAction>> *api_trainingRecordActions; // 动作列表

@end


