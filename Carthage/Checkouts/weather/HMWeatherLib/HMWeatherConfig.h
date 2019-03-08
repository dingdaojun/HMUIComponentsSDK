//  HMWeatherConfig.h
//  Created on 2018/6/7
//  Description 天气数据更新规则config

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>

@interface HMWeatherConfig : NSObject
/** 天气预报更新间隔 (默认 8 小时) */
@property (nonatomic, readonly) NSInteger forecastUpdateHours;
/** AQI，实时，预警更新间隔(默认 1 小时) */
@property (nonatomic, readonly) NSInteger AQIUpdateHours;
/** 行政区更新距离 (默认 2 km) */
@property (nonatomic, readonly) NSInteger LocationKeyUpdateDistance;

- (instancetype)init NS_UNAVAILABLE;

/**
 初始化配置(其他init方法禁用)

 @param forecastUpdateH 天气预报更新间隔 (默认 8 小时)
 @param AQIUpdateH AQI，实时，预警更新间隔(默认 1 小时)
 @param updateDistance 行政区更新距离 (默认 2 km)
 @return HMWeatherConfig
 */
- (instancetype)initWithForecastUpdateHours:(NSInteger)forecastUpdateH
                             AQIUpdateHours:(NSInteger)AQIUpdateH
                  LocationKeyUpdateDistance:(NSInteger)updateDistance;

@end
