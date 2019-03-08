//
//  HMServiceAPI+Configuration.h
//  HuamiWatch
//
//  Created by 李宪 on 1/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIConfiguration <NSObject>

@property (nonatomic, copy, readonly) NSString *api_configurationWeatherCityName;
@property (nonatomic, copy, readonly) NSString *api_configurationWeatherCityLocationKey;
// 主设备
@property (nonatomic, copy, readonly) NSString *api_configurationMainDeviceID;

@end


@protocol HMConfigurationAPI <HMServiceAPI>

- (id<HMCancelableAPI>)configuration_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfiguration>configuration))completionBlock;

@end


@interface HMServiceAPI (Configuration) <HMConfigurationAPI>
@end

