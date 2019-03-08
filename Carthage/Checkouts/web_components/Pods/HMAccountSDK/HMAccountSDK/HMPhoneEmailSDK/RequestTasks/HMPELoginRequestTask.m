//
//  HMPELoginRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPELoginRequestTask.h"
#import "HMPEConfig.h"

@interface HMPELoginRequestTask ()

/**
 用户的密码
 */
@property (nonnull, nonatomic, copy) NSString *password;

/**
 @see HMPETokenOptionsKey
 */
@property (nonnull, nonatomic, copy) NSArray <HMPETokenOptionsKey>*tokes;

/**
 服务器返回状态 默认HMPEStateOptionsKeyRedirection
 */
@property (nonnull, nonatomic, copy) HMPEStateOptionsKey state;

@end

@implementation HMPELoginRequestTask

+ (nonnull HMPELoginRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                  phone:(nonnull NSString *)phone
                                                 region:(nonnull NSString *)region
                                               password:(nonnull NSString *)password
                                                  tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes{
    HMPELoginRequestTask *requestTask = [HMPELoginRequestTask requestTaskWithAreaCode:areaCode account:phone region:region password:password tokes:tokes];
    requestTask.accountType = HMPEAccountTypePhone;
    return requestTask;
}


+ (nonnull HMPELoginRequestTask *)emailTaskWithEmail:(nonnull NSString *)email
                                              region:(nonnull NSString *)region
                                            password:(nonnull NSString *)password
                                               tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes{
    HMPELoginRequestTask *requestTask = [HMPELoginRequestTask requestTaskWithAreaCode:nil account:email region:region password:password tokes:tokes];
    requestTask.accountType = HMPEAccountTypeEmail;
    return requestTask;
}

#pragma mark - Private Methods

+ (nonnull HMPELoginRequestTask *)requestTaskWithAreaCode:(nullable NSString *)areaCode
                                                  account:(nonnull NSString *)account
                                                   region:(nonnull NSString *)region
                                                 password:(nonnull NSString *)password
                                                    tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes{
    HMPELoginRequestTask *requestTask = [[HMPELoginRequestTask alloc] initWithAreaCode:areaCode account:account region:region];
    requestTask.password = password;
    requestTask.tokes = tokes;
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
    return [NSString stringWithFormat:@"/registrations/%@/tokens",self.account];
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
    if (!self.tokes || [self.tokes count] == 0) {
        return [NSError wsLocalParamErrorKey:@"tokes"];
    }
    if ([HMAccountTools isEmptyString:[HMPEConfig sharedInstance].clientId]) {
        return [NSError wsLocalParamErrorKey:@"clientId"];
    }
    if ([HMAccountTools isEmptyString:self.state]) {
        return [NSError wsLocalParamErrorKey:@"state"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.password forKey:@"password"];
    [self.parameter setObject:[HMPEConfig sharedInstance].clientId forKey:@"client_id"];
    [self.parameter setObject:self.tokes forKey:@"token"];
    [self.parameter setObject:self.state forKey:@"state"];
}

 - (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
     [super parseResponseHanlderWithDictionary:infoDict];
     HMPEAccessToken *accessToken = [[HMPEAccessToken alloc] initWithDictionary:self.responseRawObject];
     self.resultItem = accessToken;
}

@end
