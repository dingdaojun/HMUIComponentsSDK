//
//  HMPEChangeAccountRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEChangeAccountRequestTask.h"

@interface HMPEChangeAccountRequestTask ()

/**
 旧密码
 */
@property (nonnull, nonatomic, copy) NSString *password;

/**
 新的手机区号
 */
@property (nonnull, nonatomic, copy) NSString *changedAreaCode;

/**
 新账号
 */
@property (nonnull, nonatomic, copy) NSString *changedAcount;

/**
 图片/语音验证码
 */
@property (nullable, nonatomic, copy) NSString *captcha;

/**
 验证码
 */
@property (nullable, nonatomic, copy) NSString *securityCode;

@end

@implementation HMPEChangeAccountRequestTask

+ (nonnull HMPEChangeAccountRequestTask *)phoneTaskWithAreaCode:(nullable NSString *)areaCode
                                                          phone:(nonnull NSString *)phone
                                                         region:(nonnull NSString *)region
                                                    newAreaCode:(nullable NSString *)newAreaCode
                                                       newPhone:(nonnull NSString *)newPhone
                                                   securityCode:(nonnull NSString *)securityCode
                                                        captcha:(nullable NSString *)captcha {
    HMPEChangeAccountRequestTask *requestTask = [HMPEChangeAccountRequestTask requestTaskWithAreaCode:areaCode account:phone region:region newAreaCode:newAreaCode newAccount:newPhone password:nil securityCode:securityCode captcha:captcha];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}

+ (nonnull HMPEChangeAccountRequestTask *)emialTaskWithEmail:(nonnull NSString *)email
                                                      region:(nonnull NSString *)region
                                                    newEmail:(nonnull NSString *)newEmail
                                                    password:(nonnull NSString *)password
                                                     captcha:(nullable NSString *)captcha {
    HMPEChangeAccountRequestTask *requestTask = [HMPEChangeAccountRequestTask requestTaskWithAreaCode:nil account:email region:region newAreaCode:nil newAccount:newEmail password:password securityCode:nil captcha:captcha];
    requestTask.accountType = HMPEAccountTypeEmail;
    return requestTask;
}

#pragma mark - Private Methods
+ (nonnull HMPEChangeAccountRequestTask *)requestTaskWithAreaCode:(nullable NSString *)areaCode
                                                          account:(nonnull NSString *)account
                                                           region:(nonnull NSString *)region
                                                      newAreaCode:(nullable NSString *)newAreaCode
                                                       newAccount:(nonnull NSString *)newAccount
                                                         password:(nullable NSString *)password
                                                     securityCode:(nullable NSString *)securityCode
                                                          captcha:(nullable NSString *)captcha {
    HMPEChangeAccountRequestTask *requestTask = [[HMPEChangeAccountRequestTask alloc] initWithAreaCode:areaCode account:account region:region];
    requestTask.changedAreaCode = newAreaCode;
    requestTask.changedAcount = newAccount;
    requestTask.password = password;
    requestTask.captcha = captcha;
    requestTask.securityCode = securityCode;
    return requestTask;
}

- (NSString *)apiName{
    return [NSString stringWithFormat:@"registrations/%@/change",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.changedAcount]) {
        return [NSError wsLocalParamErrorKey:@"changedAcount"];
    }
    if (self.accountType == HMPEAccountTypePhone) {
        if ([HMAccountTools isEmptyString:self.securityCode]) {
            return [NSError wsLocalParamErrorKey:@"securityCode"];
        }
        if ([HMAccountTools isEmptyString:self.changedAreaCode]) {
            return [NSError wsLocalParamErrorKey:@"changedAreaCode"];
        }
    } else {
        if ([HMAccountTools isEmptyString:self.password]) {
            return [NSError wsLocalParamErrorKey:@"password"];
        }
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    if (self.accountType == HMPEAccountTypePhone) {
        [self.parameter setObject:[self.changedAreaCode stringByAppendingString:self.changedAcount] forKey:@"new"];
    } else {
        [self.parameter setObject:self.password forKey:@"password"];
        [self.parameter setObject:self.changedAcount forKey:@"new"];
    }
    if (self.securityCode) {
        [self.parameter setObject:self.securityCode forKey:@"code"];
    }
    if (self.captcha) {
        [self.parameter setObject:self.captcha forKey:@"captcha"];
    }
}
@end
