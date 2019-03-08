//  HMDBWeatherForecastRecord.h
//  Created on 19/12/2017
//  Description 天气预报数据库记录

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMDBWeatherForecastRecord : CTPersistanceRecord

@property (copy, nonatomic)   NSNumber      *identifier;                // 数据库自生成主键，无实际意义
@property (copy, nonatomic)   NSString      *forecastPublishTime;       // 天气数据发布时间
@property (assign, nonatomic) NSInteger     weatherFromValue;           // 天气区间起始值
@property (assign, nonatomic) NSInteger     weatherToValue;             // 天气区间结束值
@property (assign, nonatomic) NSInteger     temperatureFromValue;       // 温度区间起始值
@property (assign, nonatomic) NSInteger     temperatureToValue;         // 温度区间结束值
@property (copy, nonatomic)   NSString      *temperatureUnit;           // 温度单位
@property (assign, nonatomic) long long     recordUpdateTimeInterval;   // 数据库记录更新时间，毫秒数取整
@property (assign, nonatomic) long long     forecastDateTimeInterval;   // 预报对应的日期时间戳，毫秒数取整
@property (copy, nonatomic)   NSString      *sunriseDateString;         // 日出时间
@property (copy, nonatomic)   NSString      *sunsetDateString;          // 日落时间
@property (copy, nonatomic)   NSString      *locationKey;               // 行政区标示

@end
