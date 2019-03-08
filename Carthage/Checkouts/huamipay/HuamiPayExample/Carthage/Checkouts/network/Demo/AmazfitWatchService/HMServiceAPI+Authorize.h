//
//  HMServiceAPI+Authorize.h
//  AmazfitWatch
//
//  Created by 朱立挺 on 2018/1/16.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIAuthorizeData <NSObject>

@property (readonly) BOOL       api_healthDataAuthorizeIsBind;                   // 是否绑定了
@property (readonly) NSString  *api_healthDataAuthorizeBindName;                 // 绑定名称

@end

@interface HMServiceAPI (HealthDataAuthorize)

- (id<HMCancelableAPI>)healthDataAuthorize_checkWithCompletionBlock:(void (^)(BOOL success, NSString *message,id <HMServiceAPIAuthorizeData> authorizeData))completionBlock;

- (id<HMCancelableAPI>)healthDataAuthorize_bindWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSString *bindInfo)) completionBlock;

@end
