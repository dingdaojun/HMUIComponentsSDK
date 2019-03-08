//
//  HMServiceAPI+Scale.h
//  HMNetworkLayer
//
//  Created by 李宪 on 17/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

typedef NS_ENUM(NSUInteger, HMServiceScaleUsageMode) {
    HMServiceScaleUsageNormally         = 0,    // 正常使用
    HMServiceScaleUsageHodingInfant,            // 抱婴称重
    HMServiceScaleUsageManully,                 // 手动添加
    HMServiceScaleUsageOneFootEyeClosed         // 单脚闭目
};

typedef NS_ENUM(NSUInteger, HMServiceScaleBodyStyleType) {
    HMServiceScaleBodyStyleNoStyle            = 0,
    HMServiceScaleBodyStyleRecessiveObesity   = 1,
    HMServiceScaleBodyStylePartialFat         = 2,
    HMServiceScaleBodyStyleStrongFat          = 3,
    HMServiceScaleBodyStyleLackOfExercise     = 4,
    HMServiceScaleBodyStyleNormal             = 5,
    HMServiceScaleBodyStyleMuscle             = 6,
    HMServiceScaleBodyStyleThin               = 7,
    HMServiceScaleBodyStyleLeanMuscle         = 8,
    HMServiceScaleBodyStyleBodybuildingMuscle = 9,
};


@protocol HMServiceAPIScaleData <NSObject>

@property (readonly) NSString *api_scaleDataUserID;
@property (readonly) NSString *api_scaleDataFamilyMemberID; // nil即本人体重
@property (readonly) NSDate *api_scaleDataTime;

@property (readonly) NSString *api_scaleDataDeviceID;
@property (readonly) HMServiceAPIDeviceSource api_scaleDataDeviceSource;

@property (readonly) HMServiceScaleUsageMode api_scaleDataUsageMode;

@property (readonly) double api_scaleDataWeight;
@property (readonly) double api_scaleDataHeight;
@property (readonly) double api_scaleDataBodyFatRate;
@property (readonly) double api_scaleDataBodyMuscleRate;
@property (readonly) double api_scaleDataBoneWeight;
@property (readonly) double api_scaleDataMetabolism; // 基础代谢
@property (readonly) double api_scaleDataVisceralFat; // 内脏脂肪
@property (readonly) double api_scaleDataBodyWaterRate;
@property (readonly) NSUInteger api_scaleDataImpedance; // 阻抗系数
@property (readonly) double api_scaleDataBMI;

@property (readonly) double api_scaleDataBodyScore;
@property (readonly) HMServiceScaleBodyStyleType api_scaleDataBodyStyle;

@property (readonly) double api_scaleDataOfmt;  //单脚闭目

@end


typedef NS_ENUM(NSUInteger, HMServiceAPIScaleFamilyMemberGender) {
    HMServiceAPIScaleFamilyMemberGenderMale     = 1,
    HMServiceAPIScaleFamilyMemberGenderFemale
};


/**
 说明：除了ID以外其余参数均为可选。但是必须至少有一项为非nil或者>0
 */
@protocol HMServiceAPIScaleFamilyMember <NSObject>

@property (readonly) NSString *api_scaleFamilyMemberID;
@property (readonly) NSString *api_scaleFamilyMemberNickname;
@property (readonly) NSDate *api_scaleFamilyMemberBirthday;
@property (readonly) HMServiceAPIScaleFamilyMemberGender api_scaleFamilyMemberGender;
@property (readonly) NSString *api_scaleFamilyMemberCity;
@property (readonly) id api_scaleFamilyMemberAvatar; // file URL represented by NSString, NSURL or binary represented by UIImage, NSData

@property (readonly) double api_scaleFamilyMemberHeight;
@property (readonly) double api_scaleFamilyMemberWeight;
@property (readonly) double api_scaleFamilyMemberGoalWeight;

@end


@protocol HMServiceAPIScaleWeightGoal <NSObject>

@property (readonly) NSString *api_scaleWeightGoalFamilyMemberID;
@property (readonly) double api_scaleWeightGoalValue;
@property (readonly) double api_scaleWeightGoalWeight;
@property (readonly) double api_scaleWeightGoalHeight;
@property (readonly) NSDate *api_scaleWeightGoalCreateTime;

@end


@protocol HMServiceScaleAPI <HMServiceAPI>

/**
 同步体重秤数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=155
 */
- (id<HMCancelableAPI>)scale_uploadData:(NSArray<id<HMServiceAPIScaleData>> *)dataItems
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取体重秤数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=158
 */
- (id<HMCancelableAPI>)scale_dataWithFamilyMemberID:(NSString *)familyMemberID
                                               date:(NSDate *)date
                                              count:(NSInteger)count
                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIScaleData>> *scaleDatas, NSDate *nextDataDate))completionBlock;

/**
 删除体重秤数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=162
 */
- (id<HMCancelableAPI>)scale_deleteDatas:(NSArray<id<HMServiceAPIScaleData>> *)dataItems
                         completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 添加、更新体重秤家庭成员
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=165
 */
- (id<HMCancelableAPI>)scale_updateFamilyMember:(id<HMServiceAPIScaleFamilyMember>)familyMember
                                completionBlock:(void (^)(BOOL success, NSString *message, NSString *avatarURL))completionBlock;

/**
 获取体重秤家庭成员列表
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=166
 */
- (id<HMCancelableAPI>)scale_familyMembersWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIScaleFamilyMember>> *familyMembers))completionBlock;

/**
 删除家庭成员
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=167
 */
- (id<HMCancelableAPI>)scale_deleteFamilyMembers:(NSArray<id<HMServiceAPIScaleFamilyMember>> *)familyMembers
                                 completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 添加、同步体重目标
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=171
 */
- (id<HMCancelableAPI>)scale_updateWeightGoal:(id<HMServiceAPIScaleWeightGoal>)weightGoal
                              completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取体重目标
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=170
 */
- (id<HMCancelableAPI>)scale_weightGoalsWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIScaleWeightGoal>> *goals))completionBlock;

/**
 删除体重目标
 @see huami.health.scale.usergoal.deleteusergoal.json
 */
- (id<HMCancelableAPI>)scale_deleteWeightGoal:(id<HMServiceAPIScaleWeightGoal>)weightGoal
                              completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end


@interface HMServiceAPI (Scale) <HMServiceScaleAPI>
@end

