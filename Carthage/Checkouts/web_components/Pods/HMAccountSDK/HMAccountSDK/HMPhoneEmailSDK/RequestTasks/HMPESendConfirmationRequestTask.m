//
//  HMPESendConfirmationRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/8/24.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMPESendConfirmationRequestTask.h"

@implementation HMPESendConfirmationRequestTask

#pragma mark - Public Methods

+ (nonnull HMPESendConfirmationRequestTask *)emailTaskWithEmail:(nonnull NSString *)email
                                                         region:(nonnull NSString *)region {
    HMPESendConfirmationRequestTask *requestTask = [[HMPESendConfirmationRequestTask alloc] initWithAreaCode:nil account:email region:region];
    requestTask.accountType = HMPEAccountTypeEmail;
    return requestTask;
}


#pragma mark - Private Methods

- (NSString *)apiName{
    return [NSString stringWithFormat:@"registrations/%@/confirmation",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

@end
