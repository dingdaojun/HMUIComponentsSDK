//
//  HMServiceAPI+UserInfo.h
//  HMNetworkLayer
//
//  Created by 李宪 on 13/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

/**
 闹钟重复选项，从周一到周日
 */
typedef NS_OPTIONS(NSUInteger, HMServiceAPIUserInfoAlarmConfigRepeatOptions) {
    HMServiceAPIUserInfoAlarmConfigRepeatMonday             = 1 << 0,   // 星期一
    HMServiceAPIUserInfoAlarmConfigRepeatTuesday            = 1 << 1,   // 星期二
    HMServiceAPIUserInfoAlarmConfigRepeatWednesday          = 1 << 2,   // 星期三
    HMServiceAPIUserInfoAlarmConfigRepeatThursday           = 1 << 3,   // 星期四
    HMServiceAPIUserInfoAlarmConfigRepeatFriday             = 1 << 4,   // 星期五
    HMServiceAPIUserInfoAlarmConfigRepeatSaturday           = 1 << 5,   // 星期六
    HMServiceAPIUserInfoAlarmConfigRepeatSunday             = 1 << 6,   // 星期日
};

/**
 闹钟配置数据
 */
@protocol HMServiceAPIUserInfoAlarmClockConfig <NSObject>

@property (nonatomic, assign, readonly) BOOL api_userInfoAlarmClockConfigVisible;                                   // 是否可见的
@property (nonatomic, assign, readonly) BOOL api_userInfoAlarmClockConfigEnabled;                                   // 是否开启
@property (nonatomic, assign, readonly) NSUInteger api_userInfoAlarmClockConfigIndex;                               // 索引
@property (nonatomic, strong, readonly) NSDate *api_userInfoAlarmClockConfigTime;                                   // 时间

@property (nonatomic, assign, readonly) NSTimeInterval api_userInfoAlarmClockConfigSmartWakeUpDuration;             // 唤醒时长
@property (nonatomic, assign, readonly) BOOL api_userInfoAlarmClockConfigLazySleepEnabled;                          // 是否开启睡懒觉模式
@property (nonatomic, assign, readonly) HMServiceAPIUserInfoAlarmConfigRepeatOptions api_userInfoAlarmClockConfigRepeatOptions; // 重复选项
@property (nonatomic, assign, readonly) BOOL api_userInfoAlarmClockConfigIntelligenceWakeUpEnabled;                 // 是否开启睡懒觉模式

@end

/**
 性别定义
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIUserInfoDataGender) {
    HMServiceAPIUserInfoDataGenderUnknown       = 0,   // 使用非0值满足参数检查，API内部会转换成接口定义的值
    HMServiceAPIUserInfoDataGenderMale,
    HMServiceAPIUserInfoDataGenderFemale,
};

/**
 用户信息数据类型
 PS: api_userInfoDataConfigString这个是在太恶心了。另外根据单军龙和许根源的建议，后期可能整个解决方案会替换，所以暂时不改动仍然使用String作为参数
 */
@protocol HMServiceAPIUserInfoData <NSObject>

@property (nonatomic, copy, readonly) NSString *api_userInfoDataNickname;                                                       // 昵称
@property (nonatomic, copy, readonly) NSString *api_userInfoDataAvatarURL;                                                      // 头像URL
@property (nonatomic, strong, readonly) NSDate *api_userInfoDataBirthday;                                                       // 生日
@property (nonatomic, assign, readonly) HMServiceAPIUserInfoDataGender api_userInfoDataGender;                                  // 性别

@property (nonatomic, assign, readonly) double api_userInfoDataHeight;                                                          // 高度
@property (nonatomic, assign, readonly) double api_userInfoDataWeight;                                                          // 体重

@property (nonatomic, copy, readonly) NSString *api_userInfoDataConfigString;                                                   // 配置字符串
@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPIUserInfoAlarmClockConfig>> *api_userInfoDataAlarmClockConfigs;   // 闹钟配置

@end


@protocol HMServiceUserInfoAPI <HMServiceAPI>

/**
 获取个人信息
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=117
 */
- (id<HMCancelableAPI>)userInfo_dataWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIUserInfoData>userInfo))completionBlock;

/**
 更新个人信息
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=363
 @param data 用户信息，不需要所有字段都有值，但是至少要有一项非nil或0。例如修改闹钟的时候，api_userInfoDataAlarmClockConfigs.count必须大于零；修改昵称的时候，
 @param avatar file URL represented by NSString, NSURL or binary represented by UIImage, NSData
 api_userInfoDataNickname.length必须大于零。
 */
- (id<HMCancelableAPI>)userInfo_updateUserInfoData:(id<HMServiceAPIUserInfoData>)data
                                            avatar:(id)avatar
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSString *avatarURL))completionBlock;

@end


@interface HMServiceAPI (UserInfo) <HMServiceUserInfoAPI>
@end
