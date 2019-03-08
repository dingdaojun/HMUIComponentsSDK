//
//  HMServiceAPITrainingData.h
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingTypeDefine.h"

/**
 训练中心数据类型定义
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 类型定义
 */


// 训练计算方式
typedef NS_ENUM(NSUInteger, HMServiceAPITrainingCalculateType) {
    HMServiceAPITrainingCalculateByTime,            // 计时
    HMServiceAPITrainingCalculateByCount            // 计数
};

// 训练目的
typedef NS_ENUM(NSUInteger, HMServiceAPITrainingFunctionType) {
    HMServiceAPITrainingFunctionShaping,            // 塑形
    HMServiceAPITrainingFunctionLoseFat,            // 减脂
    HMServiceAPITrainingFunctionBuildMuscle         // 增肌
};

// 困难度
typedef NS_ENUM(NSInteger, HMServiceAPITrainingDifficulty) {
    HMServiceAPITrainingDifficultyJunior    = 1,    // 初级
    HMServiceAPITrainingDifficultyMiddle,           // 中级
    HMServiceAPITrainingDifficultyHigh,             // 高级
    HMServiceAPITrainingDifficultyAny       = -1,
};

// 教练
@protocol HMServiceAPITrainingCoach <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingCoachID;                                // 教练ID
@property (nonatomic, copy, readonly) NSString *api_trainingCoachHuamiID;                           // 教练华米账号ID
@property (nonatomic, copy, readonly) NSString *api_trainingCoachName;                              // 教练名
@property (nonatomic, assign, readonly) HMServiceAPITrainingUserGender api_trainingCoachGender;     // 教练性别
@property (nonatomic, copy, readonly) NSString *api_trainingCoachAvatarURL;                         // 教练头像图片链接
@property (nonatomic, copy, readonly) NSString *api_trainingCoachIntroduction;                      // 教练介绍
@property (nonatomic, copy, readonly) NSString *api_trainingCoachHomePageURL;                       // 教练主页链接

@end

// 训练器械
@protocol HMServiceAPITrainingInstrument <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingInstrumentID;                           // 器械ID
@property (nonatomic, copy, readonly) NSString *api_trainingInstrumentName;                         // 器械名称

@end

// 训练功能
@protocol HMServiceAPITrainingFunction <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingFunctionID;                             // 功能ID
@property (nonatomic, copy, readonly) NSString *api_trainingFunctionName;                           // 功能名称

@end

// 训练部位
@protocol HMServiceAPITrainingBodyPart <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingBodyPartID;                             // 部位ID
@property (nonatomic, copy, readonly) NSString *api_trainingBodyPartName;                           // 部位名称

@end

// 音频
@protocol HMServiceAPITrainingAudio <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingAudioName;                              // 音频名称
@property (nonatomic, copy, readonly) NSString *api_trainingAudioContent;                           // 音频内容
@property (nonatomic, copy, readonly) NSString *api_trainingAudioFileURL;                           // 文件链接
@property (nonatomic, assign, readonly) NSUInteger api_trainingAudioSize;                           // 文件大小

@end

// 视频
@protocol HMServiceAPITrainingVideo <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingVideoName;                                          // 视频名称
@property (nonatomic, copy, readonly) NSString *api_trainingVideoThumbnailImageURL;                             // 缩略图链接

@property (nonatomic, assign, readonly) HMServiceAPITrainingDifficulty api_trainingVideoDifficulty;             // 难度等级
@property (nonatomic, assign, readonly) HMServiceAPITrainingCalculateType api_trainingVideoCalculateType;       // 计算类型
@property (nonatomic, strong, readonly) id<HMServiceAPITrainingInstrument> api_trainingVideoInstrument;         // 器械
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingVideoDuration;                               // 视频时长
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingVideoSingleActionDuration;                   // 单个动作时长


@property (nonatomic, strong, readonly) id<HMServiceAPITrainingFunction> api_trainingVideoFunction;             // 视频功能
@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPITrainingBodyPart>> *api_trainingVideoBodyParts;  // 视频包含身体部位

@property (nonatomic, copy, readonly) NSString *api_trainingVideoPlainTextDocument;                             // 纯文本文案
@property (nonatomic, copy, readonly) NSString *api_trainingVideoHTMLDocument;                                  // HTML文案

@property (nonatomic, copy, readonly) NSString *api_trainingVideoFileURL;                                       // 视频文件链接
@property (nonatomic, assign, readonly) NSUInteger api_trainingVideoFileSize;                                   // 视频文件大小

@end

// 训练动作
@protocol HMServiceAPITrainingAction <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingActionID;                           // 动作ID
@property (nonatomic, copy, readonly) NSString *api_trainingActionName;                         // 动作名称
@property (nonatomic, assign, readonly) NSUInteger api_trainingActionGroup;                     // 分组
@property (nonatomic, assign, readonly) NSUInteger api_trainingActionRound;                     // 第几轮
@property (nonatomic, assign, readonly) NSUInteger api_trainingActionRepeatNumber;              // 重复次数
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingActionDuration;              // 持续时间
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingActionBreakTime;             // 休息时间
@property (nonatomic, strong, readonly) id<HMServiceAPITrainingAudio> api_trainingActionAudio;  // 音频
@property (nonatomic, strong, readonly) id<HMServiceAPITrainingVideo> api_trainingActionVideo;  // 视频

@end



// 训练数据
@protocol HMServiceAPITrainingData <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingDataID;                                                 // 训练ID
@property (nonatomic, assign, readonly) NSUInteger api_trainingDataOrder;                                           // 排序号
@property (nonatomic, copy, readonly) NSString *api_trainingDataName;                                               // 训练名称
@property (nonatomic, copy, readonly) NSString *api_trainingDataIntroduction;                                       // 训练介绍

@property (nonatomic, copy, readonly) NSString *api_trainingDataDetailImageURL;                                     // 详情页图片URL
@property (nonatomic, copy, readonly) NSString *api_trainingDataListImageURL;                                       // 列表页图片URL

@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPITrainingAction>> *api_trainingDataActions;           // 动作列表

@property (nonatomic, assign, readonly) HMServiceAPITrainingDifficulty api_trainingDataDifficulty;                  // 难度等级
@property (nonatomic, assign, readonly) NSTimeInterval api_trainingDataDuration;                                    // 训练时间
@property (nonatomic, assign, readonly) double api_trainingDataEnergyBurnedInCalorie;                               // 消耗卡路里
@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPITrainingBodyPart>> *api_trainingDataBodyParts;       // 训练到的身体部位
@property (nonatomic, strong, readonly) id<HMServiceAPITrainingInstrument> api_trainingDataInstrument;              // 使用器械

@property (nonatomic, strong, readonly) id<HMServiceAPITrainingCoach> api_trainingDataCoach;                        // 教练
@property (nonatomic, assign, readonly) NSUInteger api_trainingDataParticipantNumber;                               // 参与者人数
@property (nonatomic, assign, readonly) NSUInteger api_trainingDataFinishedTimesCount;                              // 完成次数

@property (nonatomic, assign, readonly) BOOL api_trainingDataParticipated;                                          // 是否已参加

@end


@interface NSNumber (HMServiceAPITrainingFunction)
- (NSString *)hms_trainingFunctionTypeString;
@end

@interface NSNumber (HMServiceAPITrainingDifficulty)
- (NSString *)hms_trainingDifficultyString;
@end


// 由于接口没有对部分字段的Gender做判断，此处给所有Dictionary设置调用接口是的gender来做取值判断，App层请忽略
@interface NSDictionary (HMServiceAPITrainingUserGender)
@property (nonatomic, assign) HMServiceAPITrainingUserGender api_cachedTrainingUserGender;
@end

@interface NSArray (HMServiceAPITrainingUserGender)
@property (nonatomic, assign) HMServiceAPITrainingUserGender api_cachedTrainingUserGender;
@end
