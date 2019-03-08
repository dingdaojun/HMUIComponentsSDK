//
//  HMPEResetPasswordRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEResetPasswordRequestTask.h"

@interface HMPEResetPasswordRequestTask ()
/**
 图片验证码
 */
@property (nullable, nonatomic, copy) NSString *captcha;

@end

@implementation HMPEResetPasswordRequestTask

+ (nonnull HMPEResetPasswordRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                          phone:(nonnull NSString *)phone{
    HMPEResetPasswordRequestTask *requestTask = [[HMPEResetPasswordRequestTask alloc] initWithAreaCode:areaCode account:phone region:nil];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}


+ (nonnull HMPEResetPasswordRequestTask *)emailTaskWithEmal:(nonnull NSString *)email
                                                    captcha:(nullable NSString *)captcha{
    HMPEResetPasswordRequestTask *requestTask = [[HMPEResetPasswordRequestTask alloc] initWithAreaCode:nil account:email region:nil];
    requestTask.accountType = HMPEAccountTypeEmail;
    requestTask.captcha = captcha;
    return requestTask;
}

#pragma mark - Private Methods

- (NSString *)apiName{
    return [NSString stringWithFormat:@"registrations/%@/password",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodDELETE;
}

- (void)configureParameterField{
    [super configureParameterField];
    if (self.captcha) {
        [self.parameter setObject:self.captcha forKey:@"code"];
    }
}

@end
