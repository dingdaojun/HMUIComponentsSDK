//  HMDBWeatherForecastProtocol.h
//  Created on 19/12/2017
//  Description HMDBWeatherForecastRecord 对外协议化表示

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@protocol HMDBWeatherForecastProtocol <NSObject>

@property (readonly, nonatomic) NSString    *dbForecastPublishTime;        // 天气数据发布时间
@property (readonly, nonatomic) NSInteger   dbWeatherFromValue;            // 天气区间起始值
@property (readonly, nonatomic) NSInteger   dbWeatherToValue;              // 天气区间结束值
@property (readonly, nonatomic) NSInteger   dbTemperatureFromValue;        // 温度区间起始值
@property (readonly, nonatomic) NSInteger   dbTemperatureToValue;          // 温度区间结束值
@property (readonly, nonatomic) NSString    *dbTemperatureUnit;            // 温度单位
@property (readonly, nonatomic) NSDate   *dbRecordUpdateTime;              // 数据库记录更新时间
@property (readonly, nonatomic) NSDate   *dbForecastDateTime;              // 预报对应的日期
@property (readonly, nonatomic) NSString    *dbSunriseDateString;          // 日出时间
@property (readonly, nonatomic) NSString    *dbSunsetDateString;           // 日落时间
@property (readonly, nonatomic) NSString    *dbLocationKey;                // 城市标识

@end
