//  HMDBWeatherEarlyWarningProtocol.h
//  Created on 19/12/2017
//  Description HMDBCurrentWeatherRecord 对外协议化表示

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@protocol HMDBWeatherEarlyWarningProtocol <NSObject>

@property (readonly, nonatomic) NSString    *dbEarlyWarningPublishTime;    // 天气预警数据发布时间
@property (readonly, nonatomic) NSString    *dbWarningID;  // 预警 ID
@property (readonly, nonatomic) NSString    *dbTitle;   // 预警标题
@property (readonly, nonatomic) NSString    *dbDetail;  // 预警详情
@property (readonly, nonatomic) NSDate      *dbRecordUpdateTime; // 数据库记录更新时间
@property (readonly, nonatomic) NSString    *dbLocationKey;   // 城市标识

@end
