//  HMWeatherInfo.h
//  Created on 2018/1/5
//  Description 天气数据info

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "HMWeatherAlertItem.h"
#import "HMWeatherCurrentItem.h"
#import "HMWeatherForecastItem.h"
#import "HMWeatherAirQualityItem.h"
#import "HMWeatherLocationItem.h"
#import "HMWeatherSunRiseSet.h"
#import "HMWeatherConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HMWeatherRequestBlock)(NSString *locationKey, BOOL hasRequestSuccess, BOOL hasWeatherUpdate);
typedef void(^HMWeatherCityResultBlock)(NSArray<HMWeatherLocationItem *> * __nullable locationItem, BOOL isSuccess);

@interface HMWeatherInfo : NSObject

@property (assign, nonatomic) BOOL needAlertPush;
@property (strong, nonatomic) NSTimer *refreshTimer;
@property (nonatomic, strong) HMWeatherConfig *weatherConfig;

+ (instancetype)shareInfo;

/**
 根据定位获取天气更新

 @param locationCoordinate 定位location
 @param isGlobalUser 是否是国外用户
 @param block block
 */
- (void)requestWeatherInfoWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate
                                        isGlobal:(BOOL)isGlobalUser
                                  Completion:(HMWeatherRequestBlock)block;

/**
 根据locationKey获取天气更新

 @param locationKey 行政区key
 @param isGlobalUser 是否是国外用户
 @param block block
 */
- (void)requestWeatherInfoWithLocationKey:(NSString *)locationKey
                                 isGlobal:(BOOL)isGlobalUser
                               Completion:(HMWeatherRequestBlock)block;

/**
 根据定位地点更新location info

 @param coordinate coordinate
 @param isGlobalUser 是否是国外用户
 @param completion completion
 */
- (void)fetchLocationItemWithCoordination:(CLLocationCoordinate2D)coordinate
                                 isGlobal:(BOOL)isGlobalUser
                               completion:(void (^)(BOOL success))completion;

/**
 根据当前定位获取AQI数据

 @param coordinate 定位
 @param isGlobalUser 是否是国外用户
 @param completion completion
 */
- (void)fetchAqiWithCoordination:(CLLocationCoordinate2D)coordinate
                isGlobal:(BOOL)isGlobalUser
              completion:(void (^)(BOOL success, HMWeatherAirQualityItem * __nullable aqi))completion;
/**
 根据当前定位获取实时天气数据
 
 @param coordinate 定位
 @param isGlobalUser 是否是国外用户
 @param completion completion
 */
- (void)fetchCurWeatherWithCoordination:(CLLocationCoordinate2D)coordinate
                               isGloabl:(BOOL)isGlobalUser
                             completion:(void (^)(BOOL success, HMWeatherCurrentItem * __nullable aqi))completion;

/**
 根据当前定位获取日出日落数据
 
 @param coordinate 当前定位
 @param isGlobal 是否是国外用户
 @param completion completion
 */
- (void)fetchSunRiseWithCoordination:(CLLocationCoordinate2D)coordinate
                            isGlobal:(BOOL)isGlobal
                          completion:(void(^)(BOOL isSuccess, BOOL isUpdate))completion;

/**
 根据city名称获取location info列表

 @param cityName 城市名称(eg. 合肥)
 @param isGlobalUser 是否是国外用户
 @param cityBlock cityBlock
 */
- (void)getLocationInfoWithCityName:(NSString *)cityName
                           isGlobal:(BOOL)isGlobalUser
                         Completion:(HMWeatherCityResultBlock)cityBlock;
/**
 *  上次定位信息
 */
- (HMWeatherLocationItem * __nullable)getLastLocationItem;
/**
 *  当日的日出日落数据
 *  isAutoLocate  是否是当前定位
 *  注意: 存在 7天的天气预报数据,但是日出日落只有 5天的情况
 */
- (id<HMWeatherSunRiseSetItemProtocol> __nullable)curSunRiseSetWithAutoLocate:(BOOL)isAutoLocate;

- (HMWeatherCurrentItem * __nullable)currentRealDataForDevice:(BOOL)supportDevice;
- (HMWeatherAirQualityItem * __nullable)currentAQIForDevice:(BOOL)supportDevice;
- (HMWeatherAlertItem * __nullable)currentAlertForDevice:(BOOL)supportDevice;
- (NSArray<HMWeatherForecastItem *> * __nullable)currentForecastForDevice:(BOOL)supportDevice;

/**
 清除之前存储的(提供给设备端)天气信息
 */
- (BOOL)cleanWeatherData;
/** 删除weather数据文件 */
- (void)cleanWeatherDataBase;
@end

NS_ASSUME_NONNULL_END
