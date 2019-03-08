//  HMWeatherCurrentItem.h
//  Created on 2018/1/4
//  Description 当前天气信息

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
@import HMDBWeather.HMDBCurrentWeatherProtocol;
@import WeatherService.HMServiceApiWeatherProtocol;

@interface HMWeatherCurrentItem : NSObject <HMDBCurrentWeatherProtocol>

@property (nonatomic, strong) NSString *curFeelsLikeValue;
@property (nonatomic, strong) NSString *curFeelsLikeUnit;
// Humidity
@property (nonatomic, strong) NSString *curHumidityValue;
@property (nonatomic, strong) NSString *curHumidityUnit;
// pressure
@property (nonatomic, strong) NSString *curPressureValue;
@property (nonatomic, strong) NSString *curPressureUnit;
// Temperature
@property (nonatomic, strong) NSString *curTemperatureValue;
@property (nonatomic, strong) NSString *curTemperatureUnit;
// visibility
@property (nonatomic, strong) NSString *visibilityValue;
@property (nonatomic, strong) NSString *visibilityUnit;
// wind direction
@property (nonatomic, strong) NSString *windDirectionValue;
@property (nonatomic, strong) NSString *windDirectionUnit;
// wind speed
@property (nonatomic, strong) NSString *windSpeedValue;
@property (nonatomic, strong) NSString *windSpeedUnit;

@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSDate   *lastUpdateDate;

@property (nonatomic, assign) NSInteger uvIndex;    // 紫外线指数
@property (nonatomic, assign) NSInteger weather;    // 天气现象编码
@property (nonatomic, strong) NSString *locationKey;// 行政区key

- (instancetype)initWithRealTimeData:(id<HMServiceAPIWeatherRealTimeData>)realTimeData locationKey:(NSString *)locationKey;
- (instancetype)initWithDBRealTimeData:(id<HMDBCurrentWeatherProtocol>)dbRealTimeData;

@end
