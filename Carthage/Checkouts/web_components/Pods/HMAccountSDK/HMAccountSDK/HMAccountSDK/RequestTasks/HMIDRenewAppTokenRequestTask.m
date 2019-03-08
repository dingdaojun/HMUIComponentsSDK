//
//  HMIDRenewAppTokenRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRenewAppTokenRequestTask.h"

@interface HMIDRenewAppTokenRequestTask ()

@property (nonnull, nonatomic, copy) NSString *loginToken;

@property (nonnull, nonatomic, copy) NSString *appName;


@end

@implementation HMIDRenewAppTokenRequestTask

- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken
                                   appName:(nonnull NSString *)appName{
    self = [super init];
    if (self) {
        self.loginToken = loginToken;
        self.appName = appName;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/app_tokens";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if (!self.loginToken || [self.loginToken length] == 0) {
        return [NSError wsLocalParamErrorKey:@"loginToken"];
    }
    if (!self.appName || [self.appName length] == 0) {
        return [NSError wsLocalParamErrorKey:@"appName"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.loginToken forKey:@"login_token"];
    [self.parameter setObject:self.appName forKey:@"app_name"];
    
    [self.parameter setObject:[HMAccountTools appVersion] forKey:@"os_version"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    self.resultItem = [[HMIDAppTokenItem alloc] initWithDictionary:infoDict[@"token_info"]];
}

@end
