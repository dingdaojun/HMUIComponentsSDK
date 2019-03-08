//  HMServiceAPI+Weather.h
//  Created on 2018/1/3
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <CoreLocation/CoreLocation.h>
#import "HMServiceApiWeatherProtocol.h"




@protocol HMServiceWeatherAPI <HMServiceAPI>

/**
 *  @brief  获取位置的locationKey
 *
 *  @param  coordinate      当前用户的位置
 *
 *  @param  isGlobal        是否是全球的地址（非国内大陆地区）
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)weather_locationDataWithCoordination:(CLLocationCoordinate2D)coordinate
                                                   isGlobal:(BOOL)isGlobal
                                            completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData))completionBlock;

/**
 *  @brief  获取位置的locationKey
 *
 *  @param  cityName        当前用户城市
 *
 *  @param  isGlobal        是否是全球的地址（非国内大陆地区）
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)weather_locationDataWithCityName:(NSString *)cityName
                                               isGlobal:(BOOL)isGlobal
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIWeatherLocationData>> *locationDatas))completionBlock;


/**
 *  @brief  获取天气实时信息
 *
 *  @param  locationKey     天气返回的位置字符串
 *
 *  @param  isGlobal        是否是全球的地址（非国内大陆地区）
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)weather_realTimeDataWithLocationKey:(NSString *)locationKey
                                                  isGlobal:(BOOL)isGlobal
                                           completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherRealTimeData> realTimeData))completionBlock;

/**
 *  @brief  获取天气预报信息
 *
 *  @param  locationKey     天气返回的位置字符串
 *
 *  @param  isGlobal        是否是全球的地址（非国内大陆地区）
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)weather_forecastDataWithLocationKey:(NSString *)locationKey
                                                  isGlobal:(BOOL)isGlobal
                                                      days:(NSInteger)days
                                           completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherForecastData> forecastData))completionBlock;

/**
 *  @brief  获取空气质量信息
 *
 *  @param  locationKey     天气返回的位置字符串
 *
 *  @param  isGlobal        是否是全球的地址（非国内大陆地区）
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)weather_airQualityDataWithLocationKey:(NSString *)locationKey
                                                    isGlobal:(BOOL)isGlobal
                                             completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherAirQualityData> airQualityData))completionBlock;

/**
 *  @brief  获取天气预警信息
 *
 *  @param  locationKey     天气返回的位置字符串
 *
 *  @param  isGlobal        是否是全球的地址（非国内大陆地区）
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)weather_weatherWarningDataWithLocationKey:(NSString *)locationKey
                                                        isGlobal:(BOOL)isGlobal
                                                 completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherWarningData> weatherWarningData))completionBlock;


@end



@interface HMServiceAPI (Weather) <HMServiceWeatherAPI>




@end
