//  HMWeatherAlertItem.h
//  Created on 2018/1/4
//  Description 天气预警

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
@import HMDBWeather.HMDBWeatherEarlyWarningProtocol;
@import WeatherService.HMServiceApiWeatherProtocol;

@interface HMWeatherAlertItem : NSObject <HMDBWeatherEarlyWarningProtocol>

@property (nonatomic, strong) NSString *alertId;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *level;

@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) NSDictionary *images;

@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, strong) NSString *locationKey;

- (instancetype)initWithWarningData:(id<HMServiceAPIWeatherWarningData>) weatherWarningData locationKey:(NSString *)locationKey;
- (instancetype)initWithDBWarningData:(id<HMDBWeatherEarlyWarningProtocol>) dbWarningData;
@end
