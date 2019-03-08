//
//  HMServiceApiRunProtocol.h
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/6/21.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#ifndef HMServiceApiRunProtocol_h
#define HMServiceApiRunProtocol_h


typedef NS_ENUM(NSUInteger, HMServiceAPIRunUnit) {
    HMServiceAPIRunMetricUnit               = 0,    // 公制单位
    HMServiceAPIRunBritishUnit              = 1,    // 英制单位
};

typedef NS_ENUM(NSUInteger, HMServiceAPIRunSourceType) {
    HMServiceAPIRunSourceTypeMifit,             // 小米运动
    HMServiceAPIRunSourceTypeMiDong,            // 米动
    HMServiceAPIRunSourceTypeChaohu,            // 巢湖手表
    HMServiceAPIRunSourceTypeTempo,             // tempo手表
    HMServiceAPIRunSourceTypeWatchHuanghe,      // 黄河手表
    HMServiceAPIRunSourceTypeWatchEverest,      // 珠峰手表
    HMServiceAPIRunSourceTypeWatchEverest2S,    // 珠峰手表2S
    HMServiceAPIRunSourceTypeWuhan,             // Wuhan手环
    HMServiceAPIRunSourceTypeBeats,             // Beats手环
    HMServiceAPIRunSourceTypeBeatsp,            // Beatsp手环
    HMServiceAPIRunSourceTypeChongqing,         // 重庆手环
    HMServiceAPIRunSourceTypeWatchQogir,        // Qogir手表
    HMServiceAPIRunSourceTypeDongtinghu,        // 洞庭湖
};

/**运动类型*/
typedef NS_ENUM(NSUInteger, HMServiceAPIRunType) {
    HMServiceAPIRunTypeAll                  = 0,    // 所有跑步不区分类型
    HMServiceAPIRunTypeOutdoor              = 1,    // 户外跑
    HMServiceAPIRunTypeDistance             = 2,    // 距离跑
    HMServiceAPIRunTypeCalories             = 3,    // 卡路里
    HMServiceAPIRunTypeTime                 = 4,    // 时间跑
    HMServiceAPIRunTypeIntermittent         = 5,    // 间歇跑
    HMServiceAPIRunTypeVigorous             = 6,    // 健步跑
    HMServiceAPIRunTypeCrossCountryRun      = 7,    // 越野跑
    HMServiceAPIRunTypeCrossIndoorRun       = 8,    // 室内跑
    HMServiceAPIRunTypeCrossRiding          = 9,    // 骑行
    HMServiceAPIRunTypeCrossIndoorRiding    = 10,   // 骑行(室内)
    HMServiceAPIRunTypeCrossSkiing          = 11,   // 滑雪
    HMServiceAPIRunTypeElliptical           = 12,   // 椭圆机
    HMServiceAPIRunTypeMountaineering       = 13,   // 登山
    HMServiceAPIRunTypeIndoorSwim           = 14,   // 室内游泳
    HMServiceAPIRunTypeOutdoorSwim          = 15,   // 室外游泳
    HMServiceAPIRunTypeWorkOut              = 16,   // 锻炼
    HMServiceAPIRunTypeTennis               = 17,   // 网球
    HMServiceAPIRunTypeFootball             = 18,   // 足球
    HMServiceAPIRunTypeRopeSkipping         = 21,   // 跳绳 (枚举21为了与算法定义类型保持一致)
    HMServiceAPIRunTypeIronThree            = 2001, // 铁三
    HMServiceAPIRunTypeComposite            = 2002, // 复合运动 (类似铁三)

};

/**运动模式*/
typedef NS_ENUM(NSUInteger, HMServiceAPIRunSportMode) {
    HMServiceAPIRunSportModeNormal,                 // 普通跑步模式  0为默认值
    HMServiceAPIRunSportModeIntervalRun,            // 间歇跑步模式
};

typedef NS_ENUM(NSInteger, HMServiceAPIRunSwimStyleType) {
    HMServiceAPIRunSwimStyleTypeDefault     = -1,   // 默认值
    HMServiceAPIRunSwimStyleTypeInitial     = 0,    // 初始状态
    HMServiceAPIRunSwimStyleTypeBreaststroke = 1,   // 蛙泳
    HMServiceAPIRunSwimStyleTypeFreeStyle   = 2,    // 自由泳
    HMServiceAPIRunSwimStyleTypeBackstroke  = 3,    // 仰泳
    HMServiceAPIRunSwimStyleTypeMedleyRelay = 4,    // 混合泳
    HMServiceAPIRunSwimStyleTypeUnknow      = 5,    // 未识别
};

typedef NS_ENUM(NSUInteger, HMServiceAPIRunLapType) {
    HMServiceAPIRunLapTypeManually,                 // 手动分段
    HMServiceAPIRunLapTypeAuto,                     // 自动分段
    HMServiceAPIRunLapTypeInterval,                 // 间歇分段
    HMServiceAPIRunLapTypeDownhill,                 // 滑降分段
    HMServiceAPIRunLapTypeRopeSkipping,             // 跳绳分段
};


@protocol HMServiceAPIRunData <NSObject>
/**
 *  @brief  跑步记录唯一ID
 */
@property (nonatomic, copy, readonly) NSString *api_runDataTrackID;
/**
 *  @brief  数据来源,线下在跑步服务申请的 eg. run.****
 */
@property (nonatomic, assign, readonly) HMServiceAPIRunSourceType api_runDataSourceType;
/**
 *  @brief 数据版本信息,由新SDK产生的数据>=11
 */
@property (nonatomic, assign, readonly) NSUInteger api_runDataVersion;

/**
 *  @brief 开始时刻
 */
@property (nonatomic, strong, readonly) NSDate *api_runStartTime;

@end


@protocol HMServiceAPIRunGPSData <NSObject>

/**
 *  @brief  跑步中的gps点
 */
@property (nonatomic, strong, readonly) CLLocation              *api_runGPSDataLoction;

/**
 *  @brief  跑步中第几秒的数据 (单位秒)
 */
@property (nonatomic, assign, readonly) NSTimeInterval          api_runGPSRunTime;

/**
 *  @brief  跑步中校准海拔 (单位米)
 */
@property (nonatomic, assign, readonly) CLLocationDistance      api_runGPSAltitude;

/**
 *  @brief 跑步中gps的配速
 */
@property (nonatomic, assign, readonly) double                  api_runGPSPace;

/**
 *  @brief 跑步中gps点的状态
 */
@property (nonatomic, assign, readonly) NSInteger               api_runGPSFlag;

@end


@protocol HMServiceAPIRunHeartRateData <NSObject>

/**
 *  @brief  心率的时间戳
 */
@property (nonatomic, strong, readonly) NSDate              *api_runHeartRateDate;

/**
 *  @brief  心率值
 */
@property (nonatomic, assign, readonly) NSUInteger           api_runHeartRate;

@end


@protocol HMServiceAPIRunDistanceData <NSObject>

/**
 *  @brief  距离的时间戳
 */
@property (nonatomic, strong, readonly) NSDate              *api_runDistanceDate;

/**
 *  @brief  距离值
 */
@property (nonatomic, assign, readonly) NSUInteger          api_runDistance;

@end


@protocol HMServiceAPIRunPauseData <NSObject>

/**
 *  @brief  暂停的时间戳
 */
@property (nonatomic, strong, readonly) NSDate              *api_runPauseDate;

/**
 *  @brief  暂停的类型(自动暂停，手动暂停)
 */
@property (nonatomic, assign, readonly) NSUInteger          api_runPauseType;

/**
 *  @brief  暂停的时间
 */
@property (nonatomic, assign, readonly) NSTimeInterval      api_runPauseDuration;

/**
 *  @brief  暂停前的gps点索引值
 */
@property (nonatomic, assign, readonly) NSUInteger          api_runPauseStartGpsIndex;

/**
 *  @brief  暂停恢复后的gps点索引值
 */
@property (nonatomic, assign, readonly) NSUInteger          api_runPauseEndGpsIndex;

@end


@protocol HMServiceAPIRunGaitData <NSObject>

/**
 *  @brief  步态的时间戳
 */
@property (nonatomic, strong, readonly) NSDate              *api_runGaitDate;

/**
 *  @brief  步态的步数
 */
@property (nonatomic, assign, readonly) NSInteger          api_runGaitStep;

/**
 *  @brief  步态的平均步长（步幅）
 */
@property (nonatomic, assign, readonly) NSInteger          api_runGaitStepLength;

/**
 *  @brief  步态的平均步频
 */
@property (nonatomic, assign, readonly) NSInteger          api_runGaitStepCadence;

@end


@protocol HMServiceAPIRunPaceData <NSObject>

/**
 *  @brief  每公里（英里）第几公里(从0开始)
 */
@property (nonatomic, assign, readonly) NSUInteger          api_runPaceKilometer;

/**
 *  @brief  每公里用时
 */
@property (nonatomic, assign, readonly) NSTimeInterval      api_runPaceTime;

/**
 *  @brief  到这个公里总用时
 */
@property (nonatomic, assign, readonly) NSTimeInterval      api_runPaceTotalTime;

/**
 *  @brief  每公里gps信息
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D api_runPaceLocation;

/**
 *  @brief  每公里心率信息
 */
@property (nonatomic, assign, readonly) NSUInteger          api_runPaceHeartRate;

@end


@protocol HMServiceAPIRunPressureData <NSObject>

/**
 *  @brief  气压的时间戳
 */
@property (nonatomic, strong, readonly) NSDate      *api_runPressureDate;

/**
 *  @brief  气压 (单位 pa)
 */
@property (nonatomic, assign, readonly) double      api_runPressure;

@end

@protocol HMServiceAPIRunSpeedData <NSObject>

/**
 *  @brief  速度的时间戳
 */
@property (nonatomic, strong, readonly) NSDate      *api_runSpeedDate;

/**
 *  @brief  速度 (单位 米／秒)
 */
@property (nonatomic, assign, readonly) double      api_runSpeed;

@end

@protocol HMServiceAPIRunRopeSkippingFrequencyData <NSObject>

/**
 *  @brief  跳绳的时间戳
 */
@property (nonatomic, strong, readonly) NSDate      *api_runRopeSkippingFrequencyDate;

/**
 *  @brief  次/分 (int类型。默认0)
 */
@property (nonatomic, assign, readonly) NSInteger   api_runRopeSkippingFrequency;

@end

@protocol HMServiceAPIRunLapData <NSObject>

/**
 *  @brief  计圈索引从０开始
 */
@property (nonatomic, assign, readonly) int      api_runLapIndex;
/**
 *  @brief  打卡每圈结束的时间戳，默认nil
 */
@property (nonatomic, strong, readonly) NSDate      *api_runLapDate;
/**
 *  @brief  距离单位米，默认-1
 */
@property (nonatomic, assign, readonly) CLLocationDistance   api_runLapDistance;
/**
 *  @brief  每圈gps信息
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D api_runLapLocation;
/**
 *  @brief  平均心率默认-1
 */
@property (nonatomic, assign, readonly) int   api_runLapAverageHeartRate;
/**
 *  @brief  用时（不包含暂停，单位秒，默认-1）
 */
@property (nonatomic, assign, readonly) NSTimeInterval   api_runLapRunTime;
/**
 *  @brief  绝对海拔单位
 */
@property (nonatomic, assign, readonly) CLLocationDistance   api_runLapAltitude;
/**
 *  @brief  海拔累计上升(米)
 */
@property (nonatomic, assign, readonly) CLLocationDistance   api_runLapAltitudeAscend;
/**
 *  @brief  海拔累计下降(米)
 */
@property (nonatomic, assign, readonly) CLLocationDistance   api_runLapAltitudeDescend;
/**
 *  @brief  平均配速单位秒/米(默认为0)
 */
@property (nonatomic, assign, readonly) double   api_runLapAveragePace;
/**
 *  @brief  最大配速单位秒/米(默认为0)
 */
@property (nonatomic, assign, readonly) double   api_runLapMaxPace;
/**
 *  @brief 累计爬升单位米,int默认值-1
*/
@property (nonatomic, assign, readonly) CLLocationDistance api_runLapAscendDistance;
/**
 *  @brief  平均划水速率单位次/秒(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runLapAverageStrokeSpeed;
/**
 *  @brief  划水次数(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runLapStrokeTime;
/**
 *  @brief  划水效率值(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runLapStrokeEfficiency;
/**
 *  @brief  消耗单位千卡(默认值0)
 */
@property (nonatomic, assign, readonly) NSInteger api_runLapCalorie;
/**
 *  @brief  平均步频(步/分)
 */
@property (nonatomic, assign, readonly) NSInteger  api_runLapAverageFrequency;
/**
 *  @brief  平均踏频(步/分)
 */
@property (nonatomic, assign, readonly) NSInteger  api_runLapAverageCadence;
/**
 *  @brief  分段类型
 */
@property (nonatomic, assign, readonly) HMServiceAPIRunLapType  api_runLapType;
/**
 *  @brief  跳绳计数
 */
@property (nonatomic, assign, readonly) NSInteger  api_runLapRopeSkippingCount;

@end

@protocol HMServiceAPIRunCorrectAltitudeData <NSObject>
/**
 *  @brief  校准后的海报时间戳
 */
@property (nonatomic, strong, readonly) NSDate      *api_runCorrectAltitudeDate;

/**
 *  @brief  校准后的海报 (单位 米)
 */
@property (nonatomic, assign, readonly) double      api_runCorrectAltitude;

@end

@protocol HMServiceAPIRunStrokeSpeedData <NSObject>
/**
 *  @brief  划水速率信息时间戳
 */
@property (nonatomic, strong, readonly) NSDate      *api_runStrokeSpeedDate;

/**
 *  @brief  划水速率信息 (单位次/秒)
 */
@property (nonatomic, assign, readonly) double      api_runStrokeSpeed;

@end

@protocol HMServiceAPIRunCadenceData <NSObject>
/**
 *  @brief  踏频信息时间戳
 */
@property (nonatomic, strong, readonly) NSDate      *api_runCadenceDate;

/**
 *  @brief  踏频信息 (转/分,double型,默认0.0)
 */
@property (nonatomic, assign, readonly) double      api_runCadence;

@end

@protocol HMServiceAPIRunDailyPerformanceInfoData <NSObject>
/**
 *  @brief  体能状态信息第几公里
 */
@property (nonatomic, assign, readonly) double api_runDailyPerformanceInfoKilometer;

/**
 *  @brief  体能状态信息 (有效区间[-20,20])
 */
@property (nonatomic, assign, readonly) double api_runDailyPerformanceInfo;

@end


@protocol HMServiceAPIRunDetailData <HMServiceAPIRunData>

/**
 *  @brief  跑步详细GPS信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunGPSData>>         *api_runDetailDataGps;

/**
 *  @brief  跑步详细心率信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunHeartRateData>>   *api_runDetailDataHeartRate;

/**
 *  @brief  跑步详细距离信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunDistanceData>>    *api_runDetailDataDistance;

/**
 *  @brief  跑步详细暂停信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunPauseData>>       *api_runDetailDataPause;

/**
 *  @brief  跑步详细步态信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunGaitData>>       *api_runDetailDataGait;


/**
 *  @brief  跑步详细气压计信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunPressureData>>    *api_runDetailDataPressure;

/**
 *  @brief  跑步每公里信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunPaceData>>        *api_runDetailDataKiloPace;

/**
 *  @brief  跑步每英里里信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunPaceData>>        *api_runDetailDataMilePace;

/**
 *  @brief  打卡统计信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunLapData>>        *api_runDetailDataLap;

/**
 *  @brief  修正的海拔信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunCorrectAltitudeData>>     *api_runDetailDataCorrectAltitude;

/**
 *  @brief  划水速率信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunStrokeSpeedData>>         *api_runDetailDataStrokeSpeed;

/**
 *  @brief  踏频信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunCadenceData>>             *api_runDetailDataCadence;

/**
 *  @brief  体能状态信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunDailyPerformanceInfoData>>    *api_runDetailDataDailyPerformanceInfo;

/**
 *  @brief  速度信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunSpeedData>>    *api_runDetailDataSpeed;

/**
 *  @brief  跳绳实时频率信息
 */
@property (nonatomic, copy, readonly)   NSArray<id<HMServiceAPIRunRopeSkippingFrequencyData>>   *api_runDetailDataRopeSkippingFrequency;


@end


@protocol HMServiceAPIRunSummaryData <HMServiceAPIRunData>

/**
 *  @brief  父运动的trackID
 */
@property (nonatomic, copy, readonly) NSString *api_runSummaryDataParentTrackID;

/**
 *  @brief  子运动的trackID数组
 */
@property (nonatomic, strong, readonly) NSArray *api_runSummaryDataChildList;

/**
 *  @brief  跑步类型  HMSportRunType
 */
@property (nonatomic, assign, readonly) HMServiceAPIRunType api_runSummaryDataType;

/**
 *  @brief  运动模式  HMServiceAPIRunSportMode
 */
@property (nonatomic, assign, readonly) HMServiceAPIRunSportMode api_runSummaryDataSportMode;

/**
 *  @brief  跑步距离(m)
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataDistance;
/**
 *  @brief  跑步消耗卡路里(卡)
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataCalorie;
/**
 *  @brief  跑步结束时间
 */
@property (nonatomic, strong, readonly) NSDate *api_runSummaryDataEndTime;
/**
 *  @brief  有效跑步时长(s)
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryDataRunTime;
/**
 *  @brief  平均配速(s)(配速,即每公里需要的时间)
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataAvgPace;
/**
 *  @brief  平均步频(步/分)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataAvgFrequency;
/**
 *  @brief  平均心率 默认-1
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataAvgHeareRate;
/**
 *  @brief  前脚掌比率,0-100
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataForefootRatio;
/**
 *  @brief 最快的配速(s)
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryDataMaxPace;
/**
 *  @brief 最慢的配速(s)
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryDataMinPace;
/**
 *  @brief 海拔上升(米)
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataAltitudeAscend;
/**
 *  @brief 海拔下降(米)
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataAltitudeDescend;
/**
 *  @brief 步幅(厘米)
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataStepLength;
/**
 *  @brief 总步数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataTotalStep;
/**
 *  @brief 骑行-上坡距离
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataClimbAscendDistance;
/**
 *  @brief 骑行-下坡距离
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataClimbDescendDis;
/**
 *  @brief 骑行-上坡总时间
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryDataClimbAscendTime;
/**
 *  @brief 骑行-下坡总时间
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryDataClimbDescendTime;
/**
 *  @brief 骑行-最大踏频
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataMaxCadence;
/**
 *  @brief 骑行-平均踏频
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataAvgCadence;

/**
 *  @brief 绑定的设备类型格式（设备类型:品牌:子类型）
 *  @note 业务端自己协商,都是固定死的协议，eg 1:LN:0  1-跑鞋，LN-李宁，0-烈骏
 */
@property (nonatomic, copy, readonly) NSString *api_runSummaryDataBindDevice;
/**
 *  @brief  详细GPS信息
 */
@property (nonatomic, copy, readonly) NSString *api_runSummaryDataLocation;
/**
 *  @brief  详细位置信息
 */
@property (nonatomic, copy, readonly) NSString *api_runSummaryDataCity;
/**
 *  @brief  腾空比例（针对米家跑鞋）
 */
@property (nonatomic, assign, readonly) double api_runSummaryDataFlightRatio;
/**
 *  @brief  触地时长（针对米家跑鞋）
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryDataLandingTime;
/**
 *  @brief  最大海拔（默认值为：Summary的version <=11，为0；Summary的version升至12，为-20000）
 */
@property (nonatomic, assign, readonly) CLLocationDistance api_runSummaryDataMaxAltitude;
/**
 *  @brief  最小海拔（默认值为；Summary的version <=11，为0；Summary的version升至12，为-20000）
 */
@property (nonatomic, assign, readonly) CLLocationDistance api_runSummaryDataMinAltitude;
/**
 *  @brief  单圈距离（单位是米；默认值是-1）
 */
@property (nonatomic, assign, readonly) CLLocationDistance api_runSummaryDataLapDistance;
/**
 *  @brief  最大心率(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataMaxHeartRate;
/**
 *  @brief  最小心率(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataMinHeartRate;
/**
 *  @brief  划水效率值(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataStrokeEfficiency;
/**
 *  @brief  划水总次数(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataStrokeTime;
/**
 *  @brief  划水总圈数(默认值-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataStrokeTrips;
/**
 *  @brief  平均划水速率(单位:次/秒,默认值-1)
 */
@property (nonatomic, assign, readonly) float api_runSummaryDataAverageStrokeSpeed;
/**
 *  @brief  最大划水速率(单位:次/秒,默认值-1)
 */
@property (nonatomic, assign, readonly) float api_runSummaryDataMaxStrokeSpeed;
/**
 *  @brief  单次划动距离(单位:米/次,默认值-1)
 */
@property (nonatomic, assign, readonly) CLLocationDistance api_runSummaryDataStrokeDistance;
/**
 *  @brief  泳道长度(单位:米,默认值-1)
 */
@property (nonatomic, assign, readonly) CLLocationDistance api_runSummaryDataSwimPoolLength;
/**
 *  @brief  泳姿(默认值-1)
 */
@property (nonatomic, assign, readonly) HMServiceAPIRunSwimStyleType api_runSummaryDataSwimStyleType;
/**
 *  @brief  训练效果(默认值-1，范围(0-50))
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataTrainEffect;
/**
 *  @brief  最快步频（单位步/分；默认值-1）
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataMaxstepFrequency;
/**
 *  @brief  当次运动单位
 */
@property (nonatomic, assign, readonly) HMServiceAPIRunUnit api_runSummaryDataUnit;
/**
 *  @brief  滑降最大落差 (单位:米，默认值:-1)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataDownhillMaxAltitudeDesend;
/**
 *  @brief  滑降次数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryDataDownhill_num;
/**
 *  @brief  挥拍次数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryStrokes;
/**
 *  @brief  正手次数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryForeHand;
/**
 *  @brief  反手次数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryBackHand;
/**
 *  @brief  发球次数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryServe;
/**
 *  @brief  下半场开始时间.(距离开始的时刻,小于为上半场,大于为下半场)
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryHalfStartTime;
/**
 *  @brief  跳绳次数
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryRopeSkippingCount;
/**
 *  @brief  跳绳平均频率(int 次/分)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryRopeSkippingAvgFrequency;
/**
 *  @brief  最高频率(int 次/分)
 */
@property (nonatomic, assign, readonly) NSInteger api_runSummaryRopeSkippingMaxFrequency;
/**
 *  @brief  跳绳儿休息时间(int 次/分)
 */
@property (nonatomic, assign, readonly) NSTimeInterval api_runSummaryRopeSkippingRestTime;
/**
 *  @brief  是否校准过数据
 */
@property (nonatomic, assign, readonly) BOOL api_runSummaryIndoorRunCalibrated;

@end


@protocol HMServiceAPIRunConfigData <NSObject>

/**
 *  @brief  是否开启自动暂停
 */
@property (nonatomic, assign, readonly)   BOOL api_runConfigDataAutoPauseEnable;
/**
 *  @brief  是否开启语音播报
 */
@property (nonatomic, assign, readonly)   BOOL api_runConfigDataVoicePlayEnable;
/**
 *  @brief  是否开启跑步中心率
 */
@property (nonatomic, assign, readonly)   BOOL api_runConfigDataMeasureHREnable;
/**
 *  @brief  是否开启跑步中心率过高提醒
 */
@property (nonatomic, assign, readonly)   BOOL api_runConfigDataRemindHREnable;
/**
 *  @brief  跑步中心率达到多少后提醒
 */
@property (nonatomic, assign, readonly)   NSUInteger api_runConfigDataRemindHeartRate;
/**
 *  @brief  是否开启跑步中配速过低提醒
 */
@property (nonatomic, assign, readonly)   BOOL api_runConfigDataRemindPaceEnable;
/**
 *  @brief  跑步中配速低于多少后提醒
 */
@property (nonatomic, assign, readonly)   double api_runConfigDataRemindPace;
/**
 *  @brief  是否开启跑步中屏幕常亮功能
 */
@property (nonatomic, assign, readonly)   NSUInteger api_runConfigDataKeepScreenOnEnable;
/**
 *  @brief  室内跑的模型
 */
@property (nonatomic, copy, readonly)     NSString *api_runConfigDataIndoorLearnLength;
/**
 *  @brief  室内跑的步长模型
 */
@property (nonatomic, copy, readonly)     NSString *api_runConfigDataIndoorStepLength;

@end


@protocol HMServiceAPIRunStatData <NSObject>

/**@brief 用时(s)*/
@property (nonatomic, assign, readonly) NSTimeInterval api_runStatDataRunTime;
/**@brief 卡路里消耗(卡)*/
@property (nonatomic, assign, readonly) double api_runStatDataCalorie;
/**@brief 跑步距离(m)*/
@property (nonatomic, assign, readonly) NSUInteger api_runStatDistance;
/**@brief 记录数*/
@property (nonatomic, assign, readonly) NSUInteger api_runStatCount;
/**@brief 运动类型*/
@property (nonatomic, assign, readonly) HMServiceAPIRunType api_runStatRunType;

@end


#endif /* HMServiceApiRunProtocol_h */
