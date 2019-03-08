//  HMDBCurrentWeatherRecord.h
//  Created on 18/12/2017
//  Description 当前天气 Model

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMDBCurrentWeatherRecord : CTPersistanceRecord

@property (copy, nonatomic)   NSNumber      *identifier;                // 数据库自生成主键，无实际意义
@property (copy, nonatomic)   NSString      *weatherPublishTime;        // 天气数据发布时间
@property (assign, nonatomic) NSInteger     weatherType;                // 天气类型
@property (assign, nonatomic) NSInteger     temperature;                // 温度
@property (copy, nonatomic)   NSString      *temperatureUnit;           // 温度单位
@property (assign, nonatomic) long long     recordUpdateTimeInterval;   // 数据库记录更新时间，毫秒数取整
@property (copy, nonatomic)   NSString      *locationKey;               // 行政区标示

@end
