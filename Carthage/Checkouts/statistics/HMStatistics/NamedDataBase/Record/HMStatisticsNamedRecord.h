//  HMStatisticsNamedRecord.h
//  Created on 2018/4/12
//  Description 具名信息

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistanceRecord.h>

@interface HMStatisticsNamedRecord : CTPersistanceRecord

@property (copy, nonatomic)     NSNumber    *identifier;            // 数据库自生成主键
@property (copy, nonatomic)     NSString    *huamiID;               // 华米 ID
@property (copy, nonatomic)     NSString    *eventID;               // 事件 ID
@property (assign, nonatomic)   long long   eventTimestamp;         // 事件起始时间戳，毫秒数
@property (copy, nonatomic)     NSString    *eventTimeZone;         // 时区名;
@property (copy, nonatomic)     NSString    *stringValue;           // 字符型数值
@property (copy, nonatomic)     NSNumber    *doubleValue;           // 数值型数值
@property (copy, nonatomic)     NSString    *eventType;             // 事件类型
@property (copy, nonatomic)     NSString    *eventParams;           // 字符型值，JSON 格式
@property (copy, nonatomic)     NSNumber    *contextID;              // 上下文 ID
@end
