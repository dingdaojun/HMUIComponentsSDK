//  HMDBWeatherEarlyWarningRecord.h
//  Created on 19/12/2017
//  Description 天气预警信息

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMDBWeatherEarlyWarningRecord : CTPersistanceRecord

@property (copy, nonatomic)   NSNumber      *identifier;                 // 数据库自生成主键，无实际意义
@property (copy, nonatomic)   NSString      *earlyWarningPublishTime;    // 天气预警数据发布时间
@property (copy, nonatomic)   NSString      *warningID;                  // 预警 ID
@property (copy, nonatomic)   NSString      *title;                      // 预警标题
@property (copy, nonatomic)   NSString      *detail;                     // 预警详情
@property (assign, nonatomic) long long     recordUpdateTimeInterval;   // 数据库记录更新时间，毫秒数取整
@property (copy, nonatomic)   NSString      *locationKey;               // 行政区标示

@end
