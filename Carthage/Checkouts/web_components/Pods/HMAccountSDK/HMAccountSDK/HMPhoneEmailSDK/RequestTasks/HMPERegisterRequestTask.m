//
//  HMPERegisterRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPERegisterRequestTask.h"
#import "HMPEConfig.h"

@interface HMPERegisterRequestTask ()

/**
 密码
 */
@property (nonnull, nonatomic, copy) NSString *password;

/**
 昵称
 */
@property (nonnull, nonatomic, copy) NSString *name;

/**
 服务器返回状态 默认HMPEStateOptionsKeyRedirection
 */
@property (nonnull, nonatomic, copy) HMPEStateOptionsKey state;

/**
 @see HMPETokenOptionsKey
 */
@property (nonnull, nonatomic, copy) NSArray <HMPETokenOptionsKey>*tokes;

/**
 手机号验证码
 */
@property (nullable, nonatomic, copy) NSString *securityCode;

/**
 验证码
 */
@property (nullable, nonatomic, copy) NSString *captcha;

@end

@implementation HMPERegisterRequestTask

+ (nonnull HMPERegisterRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                     phone:(nonnull NSString *)phone
                                                    region:(nonnull NSString *)region
                                              securityCode:(nonnull NSString *)securityCode
                                                 password:(nonnull NSString *)password
                                                    tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes{
    HMPERegisterRequestTask *requestTask = [HMPERegisterRequestTask requestTaskWithAreaCode:areaCode account:phone region:region securityCode:securityCode name:nil password:password tokes:tokes captcha:nil];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}



+ (nonnull HMPERegisterRequestTask *)emialTaskWithEmail:(nonnull NSString *)email
                                                 region:(nonnull NSString *)region
                                                   name:(nonnull NSString *)name
                                               password:(nonnull NSString *)password
                                                    tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes
                                                  captcha:(nullable NSString *)captcha{
    HMPERegisterRequestTask *requestTask = [HMPERegisterRequestTask requestTaskWithAreaCode:nil account:email region:region securityCode:nil name:name password:password tokes:tokes captcha:captcha];
    requestTask.accountType = HMPEAccountTypeEmail;
    return requestTask;
}

#pragma mark - Private Methods

+ (nonnull HMPERegisterRequestTask *)requestTaskWithAreaCode:(nullable NSString *)areaCode
                                                     account:(nonnull NSString *)account
                                                      region:(nonnull NSString *)region
                                                securityCode:(nullable NSString *)securityCode
                                                        name:(nullable NSString *)name
                                                    password:(nonnull NSString *)password
                                                       tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes
                                                     captcha:(nullable NSString *)captcha{
    HMPERegisterRequestTask *requestTask = [[HMPERegisterRequestTask alloc] initWithAreaCode:areaCode account:account region:region];
    requestTask.securityCode = securityCode;
    requestTask.name = name;
    requestTask.password = password;
    requestTask.tokes = tokes;
    requestTask.captcha = captcha;
    return requestTask;
}



- (instancetype)initWithAreaCode:(NSString *)areaCode account:(NSString *)account region:(NSString *)region{
    self = [super initWithAreaCode:areaCode account:account region:region];
    if (self) {
        self.state = HMPEStateOptionsKeyRedirection;
        self.shouldHookRedirection = YES;
    }
    return self;
}

- (NSString *)apiName{
    return [NSString stringWithFormat:@"registrations/%@",self.account];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.password]) {
        return [NSError wsLocalParamErrorKey:@"password"];
    }
    if (self.accountType == HMPEAccountTypeEmail) {
        if ([HMAccountTools isEmptyString:self.name]) {
            return [NSError wsLocalParamErrorKey:@"name"];
        }
    }
    if ([HMAccountTools isEmptyString:[HMPEConfig sharedInstance].clientId]) {
        return [NSError wsLocalParamErrorKey:@"clientId"];
    }
    if (!self.tokes || [self.tokes count] == 0) {
        return [NSError wsLocalParamErrorKey:@"tokes"];
    }
    if ([HMAccountTools isEmptyString:self.state]) {
        return [NSError wsLocalParamErrorKey:@"state"];
    }
    if (self.accountType == HMPEAccountTypePhone) {
        if ([HMAccountTools isEmptyString:self.securityCode]) {
            return [NSError wsLocalParamErrorKey:@"securityCode"];
        }
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.password forKey:@"password"];
    if (self.name) {
        [self.parameter setObject:self.name forKey:@"name"];
    } else {
        [self.parameter setObject:@"" forKey:@"name"];
    }
    [self.parameter setObject:[HMPEConfig sharedInstance].clientId forKey:@"client_id"];
    [self.parameter setObject:self.tokes forKey:@"token"];
    [self.parameter setObject:self.state forKey:@"state"];
    if (self.securityCode) {
        [self.parameter setObject:self.securityCode forKey:@"code"];
    }
    if (self.captcha) {
        [self.parameter setObject:self.captcha forKey:@"code"];
    }
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    HMPEAccessToken *accessToken = [[HMPEAccessToken alloc] initWithDictionary:self.responseRawObject];
    self.resultItem = accessToken;
}

@end
