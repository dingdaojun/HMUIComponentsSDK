//  HMWeatherForecastItem.h
//  Created on 2018/1/4
//  Description 天气预告 item

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
@import HMDBWeather.HMDBWeatherForecastProtocol;
@import WeatherService.HMServiceApiWeatherProtocol;

@interface HMWeatherForecastItem : NSObject <HMDBWeatherForecastProtocol>

@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, strong) NSDate *forecastDate;
@property (nonatomic, strong) NSString *locationKey;

// aqi
@property (nonatomic, strong) NSArray *aqiValues;

// sunrise
@property (nonatomic, strong) NSString *sunRiseFromValue;
@property (nonatomic, strong) NSString *sunRiseToValue;

// temperature
@property (nonatomic, strong) NSString *temperatureUnit;
@property (nonatomic, strong) NSString *temperatureFromValue;
@property (nonatomic, strong) NSString *temperatureToValue;

// weather
@property (nonatomic, strong) NSString *weatherFromValue;
@property (nonatomic, strong) NSString *weatherToValue;

// wind direction
@property (nonatomic, strong) NSString *windDirectionUnit;
@property (nonatomic, strong) NSString *windDirectionFromValue;
@property (nonatomic, strong) NSString *windDirectionToValue;

// wind speed
@property (nonatomic, strong) NSString *windSpeedUnit;
@property (nonatomic, strong) NSString *windSpeedFromValue;
@property (nonatomic, strong) NSString *windSpeedToValue;

+ (NSArray<HMWeatherForecastItem *> *)forecastItemsWithData:(id<HMServiceAPIWeatherForecastData>) forecastDatas locationKey:(NSString *)locationKey;
+ (NSArray<HMWeatherForecastItem *> *)forecastItemsWithDbData:(NSArray<id<HMDBWeatherForecastProtocol>> *) datas;
@end
