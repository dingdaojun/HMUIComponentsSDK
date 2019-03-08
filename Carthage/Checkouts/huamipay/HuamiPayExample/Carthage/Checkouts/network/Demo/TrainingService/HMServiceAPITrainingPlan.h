//
//  HMServiceAPITrainingPlan.h
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingTypeDefine.h"
#import "HMServiceAPITrainingData.h"

/**
 训练中心数据类型定义
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 类型定义
 */


// 训练计划每日项
@protocol HMServiceAPITrainingPlanDayItem <NSObject>

@property (nonatomic, assign, readonly) NSUInteger api_trainingPlanDayItemIndex;                                        // 索引
@property (nonatomic, assign, readonly) BOOL api_trainingPlanDayItemFinished;                                           // 是否已完成

@property (nonatomic, copy, readonly) NSString *api_trainingPlanDayItemTrainingID;                                      // 训练ID
@property (nonatomic, copy, readonly) NSString *api_trainingPlanDayItemTrainingName;                                    // 训练名称
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingPlanDayItemDuration;                                 // 训练时长
@property (nonatomic, assign, readonly) double api_trainingPlanDayItemPlanEnergyBurnedInCalorie;                        // 训练消耗的卡路里

@property (nonatomic, strong, readonly) id<HMServiceAPITrainingData> api_trainingPlanDayItemTrainingData;               // 训练数据

@property (nonatomic, copy, readonly) NSString *api_trainingPlanDayItemArticleTitle;                                    // 文章标题
@property (nonatomic, copy, readonly) NSString *api_trainingPlanDayItemArticleURL;                                      // 文章链接
@property (nonatomic, copy, readonly) NSString *api_trainingPlanDayItemArticleImageURL;                                 // 文章图片链接

@end



@protocol HMServiceAPITrainingPlan <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingPlanID;                                                     // 课程ID
@property (nonatomic, copy, readonly) NSString *api_trainingPlanName;                                                   // 课程名称
@property (nonatomic, copy, readonly) NSString *api_trainingPlanIntroduction;                                           // 课程介绍
@property (nonatomic, copy, readonly) NSString *api_trainingPlanDetailURL;                                              // 课程详情页URL

@property (nonatomic, assign, readonly) double api_trainingPlanEnergyBurnedInCalorie;                                   // 课程消耗的卡路里
@property (nonatomic, assign, readonly) HMServiceAPITrainingDifficulty api_trainingPlanDifficulty;                      // 课程难度

@property (nonatomic, strong, readonly) NSDate *api_trainingPlanDate;                                                   // 课程课程日期
@property (nonatomic, assign, readonly) NSUInteger api_trainingPlanTotalDays;                                           // 课程总天数，包括休息日
@property (nonatomic, assign, readonly) NSUInteger api_trainingPlanTrainingDays;                                        // 训练天数
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingPlanDuration;                                        // 课程时长

@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPITrainingPlanDayItem>> *api_trainingPlanDayItems;         // 每日训练数据列表

@end


