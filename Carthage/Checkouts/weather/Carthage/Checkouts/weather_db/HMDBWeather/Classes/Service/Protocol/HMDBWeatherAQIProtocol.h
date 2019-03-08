//  HMDBWeatherAQIProtocol.h
//  Created on 19/12/2017
//  Description HMDBWeatherAQIRecord 对外协议化表示

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@protocol HMDBWeatherAQIProtocol <NSObject>

@property (readonly, nonatomic)   NSString      *dbWeatherAQIPublishTime;      // 空气质量发布时间
@property (readonly, nonatomic)   NSInteger     dbValueOfAQI;                 // 空气质量数值
@property (readonly, nonatomic)   NSDate        *dbRecordUpdateTime;   // 数据库记录更新时间
@property (readonly, nonatomic) NSString    *dbLocationKey;   // 城市标识

@end
