//
//  HMIDRenewLoginTokenRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRenewLoginTokenRequestTask.h"

@interface HMIDRenewLoginTokenRequestTask ()

@property (nonnull, nonatomic, copy) NSString *loginToken;

@end

@implementation HMIDRenewLoginTokenRequestTask

- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken{
    self = [super init];
    if (self) {
        self.loginToken = loginToken;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/renew_login_token";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.loginToken]) {
        return [NSError wsLocalParamErrorKey:@"loginToken"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.loginToken forKey:@"login_token"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    self.resultItem = [[HMIDLoginTokenItem alloc] initWithDictionary:infoDict[@"token_info"]];
}
@end
