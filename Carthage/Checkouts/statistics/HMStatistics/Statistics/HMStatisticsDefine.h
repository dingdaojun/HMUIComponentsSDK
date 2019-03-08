//  HMStatisticsDefine.h
//  Created on 12/01/2018
//  Description SDK 公用常量定义文件

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#ifndef HMStatisticsDefine_h
#define HMStatisticsDefine_h

#pragma mark - 统计类型
static NSString * const kHMStatisticsCountingModule = @"cnt"; // 计次事件类型
static NSString * const kHMStatisticsCalculationModule = @"cal"; // 计算事件类型
static NSString * const kHMStatisticsExceptionModule = @"ex"; // 异常事件类型
static NSString * const kHMStatisticsInnerModule = @"inn"; // 模块内部事件类型

#pragma mark - 内部 EventID
static NSString * const kHMStatisticsInnerPageDuration = @"PageDuration"; // 内部自动页面时长统计


#pragma mark - 公用
static NSString * const kHMStatisticsSDKVersion = @"1.2.0"; // SDK 版本
static NSString * const kHMStatisticsEventVersion = @"1.0.0"; // Event 版本

#endif /* HMStatisticsDefine_h */
