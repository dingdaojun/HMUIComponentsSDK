//
//  HMPEPhoneBindRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/9/13.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMPEPhoneBindRequestTask.h"

@implementation HMPEPhoneBindRequestTask

#pragma mark - Public Methods

+ (nonnull HMPEPhoneBindRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                      phone:(nonnull NSString *)phone
                                                     region:(nonnull NSString *)region {
    HMPEPhoneBindRequestTask *requestTask = [[HMPEPhoneBindRequestTask alloc] initWithAreaCode:areaCode account:phone region:region];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}

#pragma mark - Private Methods

- (NSString *)apiName{
    return [NSString stringWithFormat:@"/registrations/%@/sms/binding",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

@end
