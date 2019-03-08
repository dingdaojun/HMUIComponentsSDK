//
//  HMDBRecordVersion_1.h
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMDBRecordVersion_1 : NSObject

@property (copy, nonatomic)   NSNumber      *identifier;                // 数据库自生成主键，无实际意义
@property (copy, nonatomic)   NSString      *weatherPublishTime;        // 天气数据发布时间
@property (assign, nonatomic) NSInteger     weatherType;                // 天气类型
@property (assign, nonatomic) NSInteger     temperature;                // 温度
@property (copy, nonatomic)   NSString      *temperatureUnit;           // 温度单位
@property (assign, nonatomic) long long     recordUpdateTimeInterval;   // 数据库记录更新时间，毫秒数取整

@end
