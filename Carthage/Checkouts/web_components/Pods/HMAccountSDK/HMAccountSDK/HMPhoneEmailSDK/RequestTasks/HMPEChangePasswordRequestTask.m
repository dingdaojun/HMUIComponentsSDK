//
//  HMPEChangePasswordRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEChangePasswordRequestTask.h"

@interface HMPEChangePasswordRequestTask ()
/**
 旧密码
 */
@property (nonnull, nonatomic, copy) NSString *oldPassword;

/**
 新密码
 */
@property (nonnull, nonatomic, copy) NSString *changedPassword;

/**
 手机验证码
 */
@property (nullable, nonatomic, copy) NSString *securityCode;

@end

@implementation HMPEChangePasswordRequestTask

+ (nonnull HMPEChangePasswordRequestTask *)phoneChangeTaskWithAreaCode:(nonnull NSString *)areaCode
                                                                 phone:(nonnull NSString *)phone
                                                           oldPassword:(nonnull NSString *)oldPassword
                                                           newPassword:(nonnull NSString *)newPassword {
    HMPEChangePasswordRequestTask *requestTask = [HMPEChangePasswordRequestTask requestTaskWithAreaCode:areaCode account:phone newPassword:newPassword oldPassword:oldPassword];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}

+ (nonnull HMPEChangePasswordRequestTask *)phoneResetTaskWithAreaCode:(nonnull NSString *)areaCode
                                                                phone:(nonnull NSString *)phone
                                                         securityCode:(nonnull NSString *)securityCode
                                                          newPassword:(nonnull NSString *)newPassword {
    HMPEChangePasswordRequestTask *requestTask = [HMPEChangePasswordRequestTask requestTaskWithAreaCode:areaCode account:phone newPassword:newPassword oldPassword:nil];
    requestTask.accountType = HMPEAccountTypePhone;
    requestTask.securityCode = securityCode;
    return requestTask;
}

+ (nonnull HMPEChangePasswordRequestTask *)emailChangeTaskWithEmail:(nonnull NSString *)email
                                                        oldPassword:(nonnull NSString *)oldPassword
                                                        newPassword:(nonnull NSString *)newPassword{
    HMPEChangePasswordRequestTask *requestTask = [HMPEChangePasswordRequestTask requestTaskWithAreaCode:nil account:email newPassword:newPassword oldPassword:oldPassword];
    requestTask.accountType = HMPEAccountTypeEmail;
    return requestTask;
}

#pragma mark - Private Methods

+ (nonnull HMPEChangePasswordRequestTask *)requestTaskWithAreaCode:(nullable NSString *)areaCode
                                                           account:(nonnull NSString *)account
                                                       newPassword:(nonnull NSString *)newPassword
                                                       oldPassword:(nullable NSString *)oldPassword {
    HMPEChangePasswordRequestTask *requestTask = [[HMPEChangePasswordRequestTask alloc] initWithAreaCode:areaCode account:account region:nil];
    requestTask.changedPassword = newPassword;
    requestTask.oldPassword = oldPassword;
    return requestTask;
}

- (NSString *)apiName{
    return [NSString stringWithFormat:@"registrations/%@/password",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.changedPassword]) {
        return [NSError wsLocalParamErrorKey:@"changedPassword"];
    }
    if ([HMAccountTools isEmptyString:self.oldPassword] && (self.accountType == HMPEAccountTypeEmail || !self.securityCode)) {
        return [NSError wsLocalParamErrorKey:@"oldPassword"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.changedPassword forKey:@"new"];
    if (self.oldPassword) {
        [self.parameter setObject:self.oldPassword forKey:@"old"];
    }
    if (self.securityCode) {
        [self.parameter setObject:self.securityCode forKey:@"reset"];
    }
}

@end
