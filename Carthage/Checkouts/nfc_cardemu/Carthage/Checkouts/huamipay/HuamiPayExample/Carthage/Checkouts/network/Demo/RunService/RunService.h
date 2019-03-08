//  RunService.h
//  Created on 2018/3/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <UIKit/UIKit.h>

//! Project version number for RunService.
FOUNDATION_EXPORT double RunServiceVersionNumber;

//! Project version string for RunService.
FOUNDATION_EXPORT const unsigned char RunServiceVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RunService/PublicHeader.h>

#import <RunService/HMServiceAPI+FirstBeat.h>
#import <RunService/HMServiceAPI+Run.h>
#import <RunService/HMServiceApiRunProtocol.h>
#import <RunService/NSArray+HMServiceAPIRunDetailEncode.h>
#import <RunService/NSString+HMServiceAPIRunDetailDecode.h>
#import <RunService/HMServiceAPIRunGPSDataItem.h>
#import <RunService/HMServiceAPIRunGaitDataItem.h>
#import <RunService/HMServiceAPIRunLapDataItem.h>
#import <RunService/HMServiceAPIRunPaceDataItem.h>
#import <RunService/HMServiceAPIRunPauseDataItem.h>
#import <RunService/NSString+HMServiceAPIRunDailyPerformanceInfoData.h>
