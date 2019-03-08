//  HMServiceAPI+AZConfiguration.h
//  Created on 2018/2/24
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

typedef NS_ENUM(NSUInteger, HMServiceAPIAZConfigurationModule) {
    HMServiceAPIAZConfigurationModuleDeviceID,          // 当前主设备的deviceID
    HMServiceAPIAZConfigurationModuleHealth,            //
};

@protocol HMServiceAPIConfigurationNotificationApplication <NSObject>

@property (readonly) NSString *api_notificaitonApplicationBundleID;
@property (readonly) NSString *api_notificaitonApplicationTitle;

@end

@protocol HMServiceAPIConfiguration <NSObject>


@property (readonly) NSString *api_azConfigurationMainDeviceID;     // 主设备
@property (readonly) BOOL api_azConfigurationAllDayHeartRate;       // 是否开启全天心率
@property (readonly) NSInteger api_azConfigurationStepTarget;       // 运动目标

@end


@protocol HMServiceAZConfigurationAPI <HMServiceAPI>

- (id<HMCancelableAPI>)azConfiguration_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfiguration> configuration))completionBlock;

@end

@interface HMServiceAPI (AZConfiguration) <HMServiceAZConfigurationAPI>
@end
