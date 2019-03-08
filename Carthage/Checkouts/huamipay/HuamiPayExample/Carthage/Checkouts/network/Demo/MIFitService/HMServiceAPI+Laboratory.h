//
//  HMServiceAPI+Laboratory.h
//  HMNetworkLayer
//
//  Created by 李宪 on 16/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

/**
 传感器类型
 */
typedef NS_OPTIONS(NSUInteger, HMServiceAPILaboratorySensorOptions) {
    HMServiceAPILaboratorySensorAccelerometer           = 1 << 0,       // 加速度传感器
    HMServiceAPILaboratorySensorGyrometer               = 1 << 1,       // 陀螺仪
    HMServiceAPILaboratorySensorMagnetometer            = 1 << 2,       // 磁力计
    HMServiceAPILaboratorySensorPhotoplethysmography    = 1 << 3,       // PPG光体积描记器，一种心率计，参考http://www.ifanr.com/513969
    HMServiceAPILaboratorySensorElectrocardiograph      = 1 << 4,       // 心电图
    HMServiceAPILaboratorySensorGPS                     = 1 << 5,       // GPS
    HMServiceAPILaboratorySensorBarometer               = 1 << 6        // 气压计
};

/**
 活动类型
 */
typedef NS_ENUM(NSUInteger, HMServiceAPILaboratoryBehaviourType) {
    HMServiceAPILaboratoryBehaviourSleep,                  // 睡眠
    HMServiceAPILaboratoryBehaviourBath,                   // 洗澡
    HMServiceAPILaboratoryBehaviourBrushTeeth,             // 刷牙
    HMServiceAPILaboratoryBehaviourRun,                    // 跑步
    HMServiceAPILaboratoryBehaviourStand,                  // 站立
    HMServiceAPILaboratoryBehaviourWalk,                   // 走路
    HMServiceAPILaboratoryBehaviourBadminton,              // 羽毛球
    HMServiceAPILaboratoryBehaviourBasketball,             // 篮球
    HMServiceAPILaboratoryBehaviourPingpang,               // 乒乓球
    HMServiceAPILaboratoryBehaviourSit,                    // 静坐
    HMServiceAPILaboratoryBehaviourBus,                    // 公交
    HMServiceAPILaboratoryBehaviourCustomize,              // 自定义
    HMServiceAPILaboratoryBehaviourRopeSkipping,           // 跳绳
    HMServiceAPILaboratoryBehaviourSitUp,                  // 仰卧起坐
    HMServiceAPILaboratoryBehaviourCycling,                // 骑行
    HMServiceAPILaboratoryBehaviourDrive,                  // 开车
    HMServiceAPILaboratoryBehaviourClimbStairs,            // 爬楼梯
    HMServiceAPILaboratoryBehaviourDining,                 // 吃饭
};


/**
 行为数据数量
 */
@protocol HMServiceAPILaboratoryBehaviourCount <NSObject>

@property (nonatomic, assign, readonly) HMServiceAPILaboratoryBehaviourType api_laboratoryBehaviourCountType;
@property (nonatomic, assign, readonly) NSUInteger api_laboratoryBehaviourCountValue;

@end


/**
 行为标记文件
 */
@protocol HMServiceAPILaboratoryBehaviourTagFile <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_laboratoryBehaviourTagFileBeginTime;                                    // 开始时间
@property (nonatomic, strong, readonly) NSDate *api_laboratoryBehaviourTagFileEndTime;                                      // 结束时间
@property (nonatomic, copy, readonly) NSString *api_laboratoryBehaviourTagFileName;                                         // 文件名
@property (nonatomic, assign, readonly) HMServiceAPILaboratorySensorOptions api_laboratoryBehaviourTagFileSensorType;       // 传感器类型
@property (nonatomic, assign, readonly) NSUInteger api_laboratoryBehaviourTagFileSensitivity;                               // 敏感度、精度
@property (nonatomic, assign, readonly) NSUInteger api_laboratoryBehaviourTagFileSampleRate;                                // 采样率

@end

/**
 行为数据
 */
@protocol HMServiceAPILaboratoryBehaviour <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_laboratoryDataBeginTime;                                    // 开始时间
@property (nonatomic, strong, readonly) NSDate *api_laboratoryDataEndTime;                                      // 结束时间
@property (nonatomic, strong, readonly) NSTimeZone *api_laboratoryDataTimeZone;                                 // 时区

@property (nonatomic, assign, readonly) HMServiceAPILaboratoryBehaviourType api_laboratoryDataBehaviourType;    // 行为类型
@property (nonatomic, copy, readonly) NSString *api_laboratoryDataCustomBehaviorName;                           // 自定义行为名称

@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_laboratoryDataDeviceSource;                // 设备Source
@property (nonatomic, assign, readonly) HMServiceAPIProductVersion api_laboratoryDataProductVersion;            // 产品版本
@property (nonatomic, copy, readonly) NSString *api_laboratoryDataDeviceID;                                     // 设备ID
@property (nonatomic, assign, readonly) HMServiceAPILaboratorySensorOptions api_laboratoryDataSensors;          // 传感器种类集合

@end


@protocol HMServiceLaboratoryAPI <NSObject>

/**
 获取实验室行为数据个数
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/user-properties-controller/getUsingGET_40
 */
- (id<HMCancelableAPI>)laboratory_behaviourCountsWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPILaboratoryBehaviourCount>> *behaviourCounts))completionBlock;

/**
 更新实验室行为数据个数
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/user-properties-controller/postUsingPOST_32
 */
- (id<HMCancelableAPI>)laboratory_updateBehaviourCounts:(NSArray<id<HMServiceAPILaboratoryBehaviourCount>> *)behaviourCounts
                                                         completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取实验室行为数据历史记录
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/sensor-data-controller/listUsingGET_8
 @param lastBehaviour App持有的最早的数据项，分页用。如果App当前无数据传nil，有N条数据传最后一条。
 */
- (id<HMCancelableAPI>)laboratory_historyBehavioursWithLastOne:(id<HMServiceAPILaboratoryBehaviour>)lastBehaviour
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPILaboratoryBehaviour>> *historyBehaviours))completionBlock;

/**
 上传实验室行为数据
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/file-access-uri-controller/postUsingPOST_5
 */
- (id<HMCancelableAPI>)laboratory_uploadBehaviour:(id<HMServiceAPILaboratoryBehaviour>)behaviour
                                         tagFiles:(NSArray<id<HMServiceAPILaboratoryBehaviourTagFile>> *)tagFiles
                                      zipFilePath:(NSString *)zipFilePath
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;


@end

@interface HMServiceAPI (Laboratory) <HMServiceLaboratoryAPI>
@end
