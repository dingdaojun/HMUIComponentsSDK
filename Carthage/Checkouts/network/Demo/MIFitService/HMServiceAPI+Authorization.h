//  HMServiceAPI+Authorization.h
//  Created on 2018/5/22
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

@protocol HMServiceAPIMinorAuthorization <NSObject>

@property (readonly) BOOL api_minorAuthorization;
@property (readonly) NSInteger api_minorAuthorizationDay;

@end


@protocol HMServiceAuthorizationAPI <HMServiceAPI>

- (id<HMCancelableAPI>)authorization_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIMinorAuthorization> minorAuthorization))completionBlock;

@end

@interface HMServiceAPI (Authorization) <HMServiceAuthorizationAPI>

@end
