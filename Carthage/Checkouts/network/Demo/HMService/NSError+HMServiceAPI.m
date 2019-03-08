//
//  NSError+HMServiceAPI.m
//  HMNetworkLayer
//
//  Created by 李宪 on 18/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSError+HMServiceAPI.h"

NSErrorDomain const HMServiceAPIErrorDomain = @"error.hmservice.api";

NSString* const HMServiceAPIErrorUserInfoMutexLoginTimeKey = @"mutexLoginTime";


@implementation NSError (HMServiceAPI)

+ (instancetype)errorWithHMServiceAPIError:(HMServiceAPIError)error {
    return [self errorWithHMServiceAPIError:error userInfo:nil];
}

+ (instancetype)errorWithHMServiceAPIError:(HMServiceAPIError)error
                                  userInfo:(NSDictionary *)userInfo {
    
    NSParameterAssert(HMServiceAPIErrorNone ||
                      HMServiceAPIErrorNetwork ||
                      HMServiceAPIErrorResponseDataFormat ||
                      HMServiceAPIErrorServerInternal ||
                      HMServiceAPIErrorParameters ||
                      HMServiceAPIErrorInvalidUserID ||
                      HMServiceAPIErrorInvalidToken ||
                      HMServiceAPIErrorMutexLogin ||
                      HMServiceAPIErrorContentSensitive ||
                      HMServiceAPIErrorUnknown);
    return [NSError errorWithDomain:HMServiceAPIErrorDomain code:error userInfo:userInfo];
}

@end
