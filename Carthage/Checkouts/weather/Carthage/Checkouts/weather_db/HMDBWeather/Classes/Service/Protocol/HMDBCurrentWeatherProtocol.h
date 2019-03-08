//  HMDBCurrentWeatherProtocol.h
//  Created on 18/12/2017
//  Description HMDBCurrentWeatherRecord 对外协议化表示

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@protocol HMDBCurrentWeatherProtocol <NSObject>

@property (readonly, nonatomic)   NSString      *dbWeatherPublishTime;         // 天气数据发布时间
@property (readonly, nonatomic)   NSInteger     dbWeatherType;                 // 天气类型
@property (readonly, nonatomic)   NSInteger     dbTemperature;                 // 温度
@property (readonly, nonatomic)   NSString      *dbTemperatureUnit;            // 温度单位
@property (readonly, nonatomic)   NSDate        *dbRecordUpdateTime;           // 数据库记录更新时间
@property (readonly, nonatomic) NSString    *dbLocationKey;   // 城市标识

@end
