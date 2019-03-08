//
//  HMPECheckRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPECheckRequestTask.h"

@implementation HMPECheckRequestTask

+ (nonnull HMPECheckRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                  phone:(nonnull NSString *)phone
                                                 region:(nonnull NSString *)region {
    HMPECheckRequestTask *requestTask = [[HMPECheckRequestTask alloc] initWithAreaCode:areaCode account:phone region:region];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}

+ (nonnull HMPECheckRequestTask *)emailTaskWithEmail:(nonnull NSString *)email
                                              region:(nonnull NSString *)region {
    HMPECheckRequestTask *requestTask = [[HMPECheckRequestTask alloc] initWithAreaCode:nil account:email region:region];
    requestTask.accountType = HMPEAccountTypeEmail;
    return requestTask;
}

#pragma mark - Private Methods

- (NSString *)apiName{
    return [NSString stringWithFormat:@"registrations/%@",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

@end
