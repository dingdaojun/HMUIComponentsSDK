//  HMServiceAPI+Configuration.h
//  Created on 2018/5/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

@protocol HMServiceConfigurationAPI <HMServiceAPI>


/**
 获取设置数据
 */
- (id<HMCancelableAPI>)configuration_retrieveWithCompletionBlock1:(void (^)(BOOL success, NSString *message, NSDictionary *configuration))completionBlock;


/**
 上传设置数据
 */
- (id<HMCancelableAPI>)configuration_update:(NSDictionary *)configuration
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;


@end


@interface HMServiceAPI (Configuration) <HMServiceConfigurationAPI>
@end
