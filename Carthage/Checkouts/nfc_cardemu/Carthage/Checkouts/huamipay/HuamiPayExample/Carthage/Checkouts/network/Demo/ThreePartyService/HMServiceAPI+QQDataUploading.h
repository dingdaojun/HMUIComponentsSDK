//  HMServiceAPI+QQDataUploading.h
//  Created on 2018/4/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>


typedef NS_ENUM(NSUInteger, HMServiceQQSleepDetailType) {
    HMServiceQQSleepDetailTypeAwake = 1,            // 清醒
    HMServiceQQSleepDetailTypeLights = 2,           // 浅睡
    HMServiceQQSleepDetailTypeDeep = 3,             // 深睡
};


NS_ASSUME_NONNULL_BEGIN

@protocol HMServiceAPIQQDataUploadingStepProtocol <NSObject>

@property (readonly) NSDate *api_qqDataUploadingStepDate;   // 时间
@property (readonly) int api_qqDataUploadingStepDistance;   // 距离
@property (readonly) int api_qqDataUploadingStep;           // 步数
@property (readonly) int api_qqDataUploadingStepDuration;   // 持续时间
@property (readonly) int api_qqDataUploadingStepCalories;   // 卡路里

@end

@protocol HMServiceAPIQQDataUploadingSleepDetailProtocol <NSObject>

@property (readonly) NSDate         *api_qqDataUploadingSleepDetailDate;            // 睡眠时间
@property (readonly) HMServiceQQSleepDetailType api_qqDataUploadingSleepDetailType; // 类型

@end

@protocol HMServiceAPIQQDataUploadingSleepProtocol <NSObject>

@property (readonly) NSDate *api_qqDataUploadingSleepStartDate;             // 起始时间
@property (readonly) NSDate *api_qqDataUploadingSleepEndDate;               // 结束时间
@property (readonly) NSTimeInterval api_qqDataUploadingSleepTotalTime;      // 总时间
@property (readonly) NSTimeInterval api_qqDataUploadingSleepLightsTime;     // 浅睡时间
@property (readonly) NSTimeInterval api_qqDataUploadingSleepDeepTime;       // 深睡时间
@property (readonly) NSTimeInterval api_qqDataUploadingSleepAwakeTime;      // 清醒时间

@property (readonly) NSArray<id<HMServiceAPIQQDataUploadingSleepDetailProtocol>> * _Nullable api_qqDataUploadingSleepDetails;  // 睡眠详情

@end

@protocol HMServiceAPIQQDataUploadingWeightProtocol <NSObject>

@property (readonly) NSDate *api_qqDataUploadingWeightDate; // 时间
@property (readonly) double api_qqDataUploadingWeight;      // 体重（单位公斤）
@property (readonly) double api_qqDataUploadingWeightBMI;   // bmi

@end


@protocol HMServiceAPIQQDataUploadingAuthorizationProtocol <NSObject>

@property (readonly) NSString *api_qqDataUploadingAuthorizationToken;       // 三方信息的授权token
@property (readonly) NSString *api_qqDataUploadingAuthorizationAppID;       // 三方信息的授权AppID
@property (readonly) NSString *api_qqDataUploadingAuthorizationOpenID;      // 三方信息的授权OpenID

@end


@protocol HMServiceQQDataUploadingAPI <HMServiceAPI>

/**
 *  @brief  上传步数到qq健康
 *
 *  @param  sleep           睡眠信息
 *
 *  @param  authorization   qq的授权信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)QQDataUploading_sleep:(id<HMServiceAPIQQDataUploadingSleepProtocol>)sleep
                                         authorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization
                                       completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  上传步数到qq健康
 *
 *  @param  step            步数信息
 *
 *  @param  authorization   qq的授权信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)QQDataUploading_step:(id<HMServiceAPIQQDataUploadingStepProtocol>)step
                                        authorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization
                                      completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  上传步数到qq健康
 *
 *  @param  weight          体重信息
 *
 *  @param  authorization   qq的授权信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)QQDataUploading_weight:(id<HMServiceAPIQQDataUploadingWeightProtocol>)weight
                                          authorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization
                                        completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

@end

NS_ASSUME_NONNULL_END

@interface HMServiceAPI (QQDataUploading) <HMServiceQQDataUploadingAPI>





@end
