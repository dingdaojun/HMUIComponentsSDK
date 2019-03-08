//
//  HMServiceAPI+Configuration.h
//  HuamiWatch
//
//  Created by 李宪 on 1/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


typedef NS_ENUM(NSInteger, HMServiceAPIConfigurationDistanceUnit) {
    HMServiceAPIConfigurationDistanceUnitUnknow         = -1,
    HMServiceAPIConfigurationDistanceUnitKilometer,      // 公里
    HMServiceAPIConfigurationDistanceUnitMile,           // 英里
};

typedef NS_ENUM(NSInteger, HMServiceAPIConfigurationWeightUnit) {
    HMServiceAPIConfigurationWeightUnitUnknow           = -1,
    HMServiceAPIConfigurationWeightUnitJin,              // 斤
    HMServiceAPIConfigurationWeightUnitKilogram,         // 公斤
    HMServiceAPIConfigurationWeightUnitPound,            // 磅
};

typedef NS_ENUM(NSInteger, HMServiceAPIConfigurationHeightUnit) {
    HMServiceAPIConfigurationHeightUnitUnkonw           = -1,
    HMServiceAPIConfigurationHeightUnitCentimeter,       // 厘米
    HMServiceAPIConfigurationHeightUnitFeet_Inch,        // 英尺、英寸
};

typedef NS_ENUM(NSInteger, HMServiceAPIConfigurationWeatherTemperatureUnit) {
    HMServiceAPIConfigurationWeatherTemperatureUnitUnkonw   = -1,
    HMServiceAPIConfigurationWeatherTemperatureUnitCelsius,
    HMServiceAPIConfigurationWeatherTemperatureUnitFahrenheit
};


// 提醒方式
typedef NS_ENUM(NSInteger, HMServiceAPIConfigurationIntervalRunLengthType) {
    HMServiceAPIConfigurationIntervalRunLengthTypeUnknown      = -1,        // 未知
    HMServiceAPIConfigurationIntervalRunLengthTypeMileage      = 0,         // 按里程
    HMServiceAPIConfigurationIntervalRunLengthTypeTime         = 1,         // 按用时
    HMServiceAPIConfigurationIntervalRunLengthTypeTouch        = 2          // 单击下键
};

// 提醒类型
typedef NS_ENUM(NSInteger, HMServiceAPIConfigurationIntervalRunReminderType) {
    HMServiceAPIConfigurationIntervalRunReminderTypeUnknown    = -1,        // 未知
    HMServiceAPIConfigurationIntervalRunReminderTypePace       = 3,         // 配速
    HMServiceAPIConfigurationIntervalRunReminderTypeHeartRate  = 4,         // 心率区间提醒
    HMServiceAPIConfigurationIntervalRunReminderTypeNone       = 5          // 不提醒
};

// 运动的类型
typedef NS_ENUM(NSUInteger, HMServiceAPIConfigurationSportDisplayOrderType) {
    HMServiceAPIConfigurationSportDisplayOrderRunning                   = 1,        // 跑步
    HMServiceAPIConfigurationSportDisplayOrderWalking                   = 6,        // 健走
    HMServiceAPIConfigurationSportDisplayOrderCrossCountryRace          = 7,        // 越野跑
    HMServiceAPIConfigurationSportDisplayOrderIndoorRunning             = 8,        // 室内跑
    HMServiceAPIConfigurationSportDisplayOrderOutdoorRiding             = 9,        // 户外骑行
    HMServiceAPIConfigurationSportDisplayOrderIndoorRiding              = 10,       // 室内骑行
    HMServiceAPIConfigurationSportDisplayOrderEllipticalMachine         = 12,       // 椭圆机
    HMServiceAPIConfigurationSportDisplayOrderClimbMountain             = 13,       // 登山
    HMServiceAPIConfigurationSportDisplayOrderIndoorSwimming            = 14,       // 泳池游泳
    HMServiceAPIConfigurationSportDisplayOrderOpenwaterSwimming         = 15,       // 公开水域游泳
    HMServiceAPIConfigurationSportDisplayOrderSkiing                    = 16,       // 滑雪
    HMServiceAPIConfigurationSportDisplayOrderTennis                    = 17,       // 网球
    HMServiceAPIConfigurationSportDisplayOrderSoccer                    = 18,       // 足球
    HMServiceAPIConfigurationSportDisplayOrderJumpRope                  = 21        // 跳绳
};

typedef NS_ENUM(NSUInteger, HMServiceAPIConfigurationSportDisplayItemType) {
    HMServiceAPIConfigurationSportDisplayItemDuration                   = 1,                // 耗时
    HMServiceAPIConfigurationSportDisplayItemMileage,                                       // 里程
    HMServiceAPIConfigurationSportDisplayItemPace,                                          // 配速
    HMServiceAPIConfigurationSportDisplayItemAveragePace,                                   // 平均配速
    HMServiceAPIConfigurationSportDisplayItemHeartRate,                                     // 心率
    HMServiceAPIConfigurationSportDisplayItemCalories,                                      // 消耗
    HMServiceAPIConfigurationSportDisplayItemAltitude,                                      // 海拔
    HMServiceAPIConfigurationSportDisplayItemCumulativeClimb,                               // 累计爬升
    HMServiceAPIConfigurationSportDisplayItemCumulativeDecline,                             // 累计下降
    HMServiceAPIConfigurationSportDisplayItemSpeed,                                         // 速度
    HMServiceAPIConfigurationSportDisplayItemAverageSpeed,                                  // 平均速度
    HMServiceAPIConfigurationSportDisplayItemStepFrequency,                                 // 步频
    HMServiceAPIConfigurationSportDisplayItemClimbDistance,                                 // 累计爬坡
    HMServiceAPIConfigurationSportDisplayItemStepCount,                                     // 步数
    HMServiceAPIConfigurationSportDisplayItemCadence,                                       // 踏频
    HMServiceAPIConfigurationSportDisplayItemTrips,                                         // 趟数
    HMServiceAPIConfigurationSportDisplayItemDPS,                                           // DPS(单次划水距离)
    HMServiceAPIConfigurationSportDisplayItemWaterSpeed,                                    // 实时划水速率
    HMServiceAPIConfigurationSportDisplayItemAverageWaterSpeed,                             // 平均划水速率
    HMServiceAPIConfigurationSportDisplayItemSwimPace,                                      // 游泳百米实时配速
    HMServiceAPIConfigurationSportDisplayItemAverageSwimPace,                               // 游泳百米平均配速
    HMServiceAPIConfigurationSportDisplayItemSwimDistance,                                  // 游泳距离
    HMServiceAPIConfigurationSportDisplayItemTE,                                            // 实时TE
    HMServiceAPIConfigurationSportDisplayItemVerticalSpeed,                                 // 垂直速度 24
    HMServiceAPIConfigurationSportDisplayItemSkiAveragePace,                                // 平均速度(滑降)
    HMServiceAPIConfigurationSportDisplayItemSkiMaxPace,                                    // 最大速度(滑降)
    HMServiceAPIConfigurationSportDisplayItemDownhillRaceTimes,                             // 滑降次数
    HMServiceAPIConfigurationSportDisplayItemDownhillRaceOnceMileage,                       // 本次滑降距离
    HMServiceAPIConfigurationSportDisplayItemDownhillRaceTotalMileage,                      // 累计滑降里程
    HMServiceAPIConfigurationSportDisplayItemOnceFall,                                      // 落差(单次) 30
    HMServiceAPIConfigurationSportDisplayItemTennisSwing,                                   // 挥拍次数
    
    HMServiceAPIConfigurationSportDisplayItemLastLapTime,                                   // 分段用时
    HMServiceAPIConfigurationSportDisplayItemLastLapPace,                                   // 分段配速
    HMServiceAPIConfigurationSportDisplayItemLastLapSpeed,                                  // 分段速度
    HMServiceAPIConfigurationSportDisplayItemLastLapAverageHeartRate,                       // 分段心率
    HMServiceAPIConfigurationSportDisplayItemLastLapAverageStepFrequency,                   // 分段步频
    HMServiceAPIConfigurationSportDisplayItemLastLapSwimPace,                               // 分段游泳配速(37)
    
    HMServiceAPIConfigurationSportDisplayItemCurrentFrequency,                              // 当前频率(跳绳)
    HMServiceAPIConfigurationSportDisplayItemTotalCount,                                    // 当前频率(跳绳)
    HMServiceAPIConfigurationSportDisplayItemAverageCurrentFrequency,                       // 平均频率(跳绳)
    HMServiceAPIConfigurationSportDisplayItemCurrentGroupCount,                             // 当前组数(跳绳)
    HMServiceAPIConfigurationSportDisplayItemThisGroupCount,                                // 本组计数(跳绳)
    HMServiceAPIConfigurationSportDisplayItemThisGroupCostTime,                             // 本组用时(跳绳)
    HMServiceAPIConfigurationSportDisplayItemThisGroupAverageFrequency                      // 本组平均频率(跳绳)
};

//// 设备类型
//typedef NS_ENUM(NSInteger,  HMServiceAPIConfigurationIntervalRunDeviceType) {
//    HMServiceAPIConfigurationIntervalRunDeviceTypeHuanghe       = 0,       // 黄河
//    HMServiceAPIConfigurationIntervalRunDeviceTypeEverest       = 1        // 珠峰
//};

@protocol HMServiceAPIConfigurationIntervalRunItem <NSObject>

@property (readonly) NSInteger api_configurationIntervalRunItemID;
@property (readonly) HMServiceAPIConfigurationIntervalRunLengthType api_configurationIntervalRunLengthType;
@property (readonly) NSInteger api_configurationIntervalRunLengthValue;              // 间歇长度的值
@property (readonly) HMServiceAPIConfigurationIntervalRunReminderType api_configurationIntervalRunReminderType;
@property (readonly) NSArray *api_configurationIntervalRunReminderValue;             // 训练提醒的区间值，是一个长度为2的数组

@end

@protocol HMServiceAPIConfigurationIntervalRunGroup <NSObject>

@property (readonly) NSInteger api_configurationIntervalRunGroupID;
@property (readonly) NSUInteger api_configurationIntervalRunRepeatCount;
@property (readonly) NSArray <id<HMServiceAPIConfigurationIntervalRunItem>>*api_configurationIntervalRunItems;

@end

@protocol HMServiceAPIConfigurationIntervalRun <NSObject>

@property (readonly) NSInteger api_configurationIntervalRunID;
@property (readonly) NSString *api_configurationIntervalRunTitle;
@property (readonly) NSArray <id<HMServiceAPIConfigurationIntervalRunGroup>>*api_configurationIntervalRunGroupList;

@end

//

typedef NS_ENUM(NSUInteger, HMServiceAPIConfigurationReserveHeartRateType) {
    HMServiceAPIConfigurationReserveHeartRateTypeReserveHeartRate    = 0,
    HMServiceAPIConfigurationReserveHeartRateTypeMaxHeartRate
};

@protocol HMServiceAPIConfigurationReserveHeartRate <NSObject>

@property (readonly) HMServiceAPIConfigurationReserveHeartRateType api_configurationReserveHeartRateType;
@property (readonly) NSInteger api_configurationReserveHeartRateRestingHeartRate;
@property (readonly) NSArray <NSNumber *>* api_configurationReserveHeartRateSection;
@property (readonly) NSArray <NSNumber *>* api_configurationReserveHeartRatePercent;

@end

@protocol HMServiceAPIConfigurationWatchFace <NSObject>

@property (readonly) NSString *api_watchFacePackageName;
@property (readonly) NSString *api_watchFaceServiceName;

@end

@protocol HMServiceAPIConfigurationNotificationApplication <NSObject>

@property (readonly) NSString *api_notificaitonApplicationBundleID;
@property (readonly) NSString *api_notificaitonApplicationTitle;

@end


// 运动项排序
@protocol HMServiceAPIConfigurationSportDisplayItem <NSObject>

// 是否处于隐藏
@property (readonly) BOOL api_configurationSportDisplayItemHidden;
// 代表具体运动项
@property (readonly) HMServiceAPIConfigurationSportDisplayItemType api_configurationSportDisplayItemType;

@end

@protocol HMServiceAPIConfigurationSportOrder <NSObject>

// 运动类型
@property (readonly) HMServiceAPIConfigurationSportDisplayOrderType api_configurationSportDisplayOrderType;
// 运动项排序
@property (readonly) NSOrderedSet<id<HMServiceAPIConfigurationSportDisplayItem>> *api_configurationSportDisplayOrderItems;

@end

/**
 用户协议类型

 - HMServiceAPIConfigurationAgreementTypeUsage: 使用协议
 - HMServiceAPIConfigurationAgreementTypePrivacy: 隐私协议
 - HMServiceAPIConfigurationAgreementTypeImprovement: 改善计划协议
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIConfigurationAgreementType) {
    HMServiceAPIConfigurationAgreementTypeUsage,
    HMServiceAPIConfigurationAgreementTypePrivacy,
    HMServiceAPIConfigurationAgreementTypeImprovement,
};

/**
 用户统一、拒绝过的协议记录
 */
@protocol HMServiceAPIConfigurationAgreement <NSObject>

@property (readonly) HMServiceAPIConfigurationAgreementType api_configurationAgreementType;
@property (readonly) NSString *api_configurationAgreementCountryCode;
@property (readonly) NSString *api_configurationAgreementVersion;
@property (readonly) BOOL api_configurationAgreementGranted;

@end


@protocol HMServiceAPIConfiguration <NSObject>

// 黑名单
@property (readonly) NSArray<id<HMServiceAPIConfigurationNotificationApplication>> *api_configurationNotificationBlacklist;
// 白名单
@property (readonly) NSArray<id<HMServiceAPIConfigurationNotificationApplication>> *api_configurationNotificationWhitelist;

// 通知是否开启
@property (readonly) BOOL api_configurationNotificationOn;

// 微信分组
@property (readonly) BOOL api_configurationNotificationWechatGroupOn;

// 音乐控制
@property (readonly) BOOL api_configurationMusicControlOn;

// 黄河新的排序
@property (readonly) NSArray<id<HMServiceAPIConfigurationSportOrder>> *api_configurationHuangheSportDisplayOrders;

// 珠峰新的排序
@property (readonly) NSArray<id<HMServiceAPIConfigurationSportOrder>> *api_configurationEverestSportDisplayOrders;


// 天气
@property (readonly) BOOL api_configurationWeatherAlertOn;
@property (readonly) BOOL api_configurationWeatherNotificationOn;
@property (readonly) HMServiceAPIConfigurationWeatherTemperatureUnit api_configurationWeatherTemperatureUnit;
@property (readonly) NSString *api_configurationWeatherCityName;
@property (readonly) NSString *api_configurationWeatherCityLocationKey;

// 表盘
@property (readonly) id<HMServiceAPIConfigurationWatchFace> api_configurationHuangheWatchFace;
@property (readonly) id<HMServiceAPIConfigurationWatchFace> api_configurationEverestWatchFace;


// 主设备
@property (readonly) NSString *api_configurationMainDeviceID;

// 单位
@property (readonly) HMServiceAPIConfigurationDistanceUnit api_configurationDistanceUnit;
@property (readonly) HMServiceAPIConfigurationWeightUnit api_configurationWeightUnit;
@property (readonly) HMServiceAPIConfigurationHeightUnit api_configurationHeightUnit;

@property (readonly) HMServiceAPIConfigurationDistanceUnit api_configurationUSDistanceUnit;
@property (readonly) HMServiceAPIConfigurationWeightUnit api_configurationUSWeightUnit;
@property (readonly) HMServiceAPIConfigurationHeightUnit api_configurationUSHeightUnit;

// 间歇跑
@property (readonly) NSArray <id <HMServiceAPIConfigurationIntervalRun>> *api_configurationIntervalRun;

// 储备心率
@property (readonly) id<HMServiceAPIConfigurationReserveHeartRate> api_configurationReserveHeartRate;

// 用户协议
@property (readonly) id<HMServiceAPIConfigurationAgreement> api_configurationUsageAgreement;
@property (readonly) id<HMServiceAPIConfigurationAgreement> api_configurationPrivacyAgreement;
@property (readonly) id<HMServiceAPIConfigurationAgreement> api_configurationImprovementAgreement;

@end


@protocol HMConfigurationAPI <HMServiceAPI>

/**
 拉取用户设置
 */
- (id<HMCancelableAPI>)configuration_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfiguration>configuration))completionBlock;

/**
 更新用户设置
 */
- (id<HMCancelableAPI>)configuration_update:(id<HMServiceAPIConfiguration>)configuration
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 拉取智能屏蔽黑名单类别
 */
- (id<HMCancelableAPI>)configuration_retrieveIntelligentBlacklistWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIConfigurationNotificationApplication>> *blacklist))completionBlock;

/**
 拉取用户最新的协议版本号信息
 */
- (id<HMCancelableAPI>)configuration_retrieveUserAgreementWithType:(HMServiceAPIConfigurationAgreementType)type
                                                       countryCode:(NSString *)countryCode
                                                   completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfigurationAgreement>agreement))completionBlock;

@end


@interface HMServiceAPI (Configuration) <HMConfigurationAPI>
@end

