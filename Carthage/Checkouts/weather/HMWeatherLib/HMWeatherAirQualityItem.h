//  HMWeatherAirQualityItem.h
//  Created on 2018/1/4
//  Description 空气质量

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
@import HMDBWeather.HMDBWeatherAQIProtocol;
@import WeatherService.HMServiceApiWeatherProtocol;

@interface HMWeatherAirQualityItem : NSObject <HMDBWeatherAQIProtocol>

@property (nonatomic, assign) NSInteger aqi;  // air quality index

@property (nonatomic, assign) NSInteger co;

@property (nonatomic, assign) NSInteger no2;

@property (nonatomic, assign) NSInteger o3;

@property (nonatomic, assign) NSInteger pm10;

@property (nonatomic, assign) NSInteger pm25;

@property (nonatomic, strong) NSString *primary;    // @"pm2.5"

@property (nonatomic, strong) NSString *src;

@property (nonatomic, assign) NSInteger so2;

@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, strong) NSString *locationKey;

- (instancetype)initWithAQIData:(id<HMServiceAPIWeatherAirQualityData>) airQualityData locationKey:(NSString *)locationKey;
- (instancetype)initWithDBAqiData:(id<HMDBWeatherAQIProtocol>) dbAqiData;

@end
