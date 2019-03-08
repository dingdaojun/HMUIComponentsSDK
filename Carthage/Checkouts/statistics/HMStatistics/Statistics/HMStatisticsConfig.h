//  HMStatisticsConfig.h
//  Created on 12/01/2018
//  Description 配置文件

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

/**
 统计策略

 - HMStatisticsReportPolicyRealTime: 实时统计，仅限 Debug 模式下有用
 - HMStatisticsReportPolicyFinishLaunching: APP 启动是发送统计信息
 - HMStatisticsReportPolicySendInterval: 最短间隔发送统计信息，([90-86400]s, default 90s)
 */

typedef NS_ENUM(NSInteger, HMStatisticsReportPolicy) {
    HMStatisticsReportPolicyRealTime = 0,
    HMStatisticsReportPolicyFinishLaunching,
    HMStatisticsReportPolicySendInterval
};

@interface HMStatisticsConfig : NSObject

/** required:  appID string */
@property(copy, nonatomic) NSString *appID;
/** required:  secret string */
@property(copy, nonatomic) NSString *secret;
/** optional:  huamiID: string*/
@property(copy, nonatomic) NSString *huamiID;
/** optional:  default: "App Store"*/
@property(copy, nonatomic) NSString *channelID;
/** optional:  default: HMStatisticsReportPolicyFinishLaunching */
@property(assign, nonatomic) HMStatisticsReportPolicy   reportPolicy;
/** optional:  default: 90 */
@property(assign, nonatomic) NSInteger minSendInterval;
/** optional: default  isDebug: YES */
@property(assign, nonatomic) BOOL   isDebug;

@end
