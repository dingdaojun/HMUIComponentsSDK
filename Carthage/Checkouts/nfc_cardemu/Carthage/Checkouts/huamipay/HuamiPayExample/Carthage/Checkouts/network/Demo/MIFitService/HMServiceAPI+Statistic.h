//
//  HMServiceAPI+Statistic.h
//  HMNetworkLayer
//
//  Created by 李宪 on 11/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

/**
 设备统计中的系统信息
 */
@protocol HMServiceAPIStatisticDeviceSystemInfo <NSObject>

@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoRunningSeconds;             // 运行时间
@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoWakeUpSeconds;              // 唤醒时间
@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoAlgorithmRunningSeconds;    // 算法运行
@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceSystemInfoRebootCount;                    // 重启次数

@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoBLEConnectionSeconds;       // 蓝牙连接时长
@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceSystemInfoBLEDisconnectCount;             // 蓝牙断开连接次数
@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoVibrateSeconds;             // 震动时长
@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoLCDOnSeconds;               // LCD点亮时长
@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoFlashReadWriteSeconds;      // Flash读写时长
@property (nonatomic, assign, readonly) NSTimeInterval api_statisticDeviceSystemInfoPPGWorkingSeconds;          // 心率计工作时长

@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceSystemInfoButtonPressedCount;             // 按键次数
@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceSystemInfoLiftWristCount;                 // 抬腕次数
@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceSystemInfoAppNotifyCount;                 // App通知次数
@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceSystemInfoIncomingCallNotifyCount;        // 来电提醒通知次数
@property (nonatomic, strong, readonly) NSDate *api_statisticDeviceSystemInfoLastChargeTime;                    // 上次充电的时间

@end


typedef NS_ENUM(NSUInteger, HMServiceAPIStatisticDeviceProductInfoFontType) {
    HMServiceAPIStatisticDeviceProductInfoFontTypeEnglish = 0x00,
    HMServiceAPIStatisticDeviceProductInfoFontTypeChinese = 0xFF
};

/**
 设备统计中的产品信息
 */
@protocol HMServiceAPIStatisticDeviceProductInfo <NSObject>

@property (nonatomic, assign, readonly) HMServiceAPIDeviceType api_statisticDeviceProductDeviceType;                        // 设备类型
@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_statisticDeviceProductDeviceSource;                    // 设备Source
@property (nonatomic, assign, readonly) HMServiceAPIProductVersion api_statisticDeviceProductVersion;                       // 产品Version
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductDeviceID;                                         // 设备ID
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductID;                                               // 产品ID
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductSerialNumber;                                     // 设备序列号

@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductFirmwareVersion;                                  // 固件版本
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductHardwareVersion;                                  // 硬件版本

@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductFontVersion;                                      // 硬件版本
@property (nonatomic, assign, readonly) HMServiceAPIStatisticDeviceProductInfoFontType api_statisticDeviceProductFontType;  // 字体类别

@property (nonatomic, assign, readonly) NSInteger api_statisticDeviceProductBand1Feature;                                   // 仅仅一代手环使用
@property (nonatomic, assign, readonly) NSInteger api_statisticDeviceProductBand1Appearance;                                // 仅仅一代手环使用
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductBand1ProfileVersion;                              // 仅仅一代手环使用

@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductBand1SHeartRateFirmwareVersion;                   // 仅仅1S手环使用

@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductResourceVersion;                                  // 资源版本
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductVendorID;                                         // 厂商ID
@property (nonatomic, copy, readonly) NSString *api_statisticDeviceProductVendorSource;                                     // 厂商Source

@end


/**
 设备统计中的电池信息
 */
@protocol HMServiceAPIStatisticDeviceBatteryInfo <NSObject>

@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceBatteryLevel;                             // 电量
@property (nonatomic, assign, readonly) NSUInteger api_statisticDeviceBatteryLastChargeTimeLevel;               // 上次充电时的电量
@property (nonatomic, strong, readonly) NSDate *api_statisticDeviceBatteryLastChargeTime;                       // 上次充电时间
@property (nonatomic, strong, readonly) NSDate *api_statisticDeviceBatteryLastFullyChargedTime;                 // 上次充满电时间

@end


/**
 设备统计中的温度信息
 */
@protocol HMServiceAPIStatisticDeviceTemperatureInfo <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_statisticDeviceTemperatureTime;                             // 时间
@property (nonatomic, assign, readonly) double api_statisticDeviceTemperatureDegreeInCentigrade;                // 温度

@end


/**
 设备统计信息数据
 */
@protocol HMServiceAPIStatisticDeviceInfo <NSObject>

@property (nonatomic, strong, readonly) id<HMServiceAPIStatisticDeviceSystemInfo> api_statisticDeviceSystemInfo;                    // 系统信息
@property (nonatomic, strong, readonly) id<HMServiceAPIStatisticDeviceProductInfo> api_statisticDeviceProductInfo;                  // 产品信息
@property (nonatomic, strong, readonly) id<HMServiceAPIStatisticDeviceBatteryInfo> api_statisticDeviceBatteryInfo;                  // 电池信息
@property (nonatomic, strong, readonly) NSArray<id<HMServiceAPIStatisticDeviceBatteryInfo>> *api_statisticDeviceTemperatureInfos;   // 温度信息

@end


@protocol HMServiceStatisticAPI <NSObject>

/**
 记录设备信息
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=139
 @param deviceInfo 设备信息
 */
- (id<HMCancelableAPI>)statistic_recordDeviceInfo:(id<HMServiceAPIStatisticDeviceInfo>)deviceInfo
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 记录App从后台到前台
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=159
 @param deviceID 设备ID，获取自：[MiStatSDK getDeviceID]
 @param userSecurity 用户的security，登录时获得
 @param country 国家 e.g CN
 @param language 语言 e.g zh_CN
 */
- (id<HMCancelableAPI>)statistic_recordBecameActiveWithDeviceID:(NSString *)deviceID
                                                   userSecurity:(NSString *)userSecurity
                                                        counrty:(NSString *)country
                                                       language:(NSString *)language
                                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;
@end

@interface HMServiceAPI (Statistic) <HMServiceStatisticAPI>
@end
