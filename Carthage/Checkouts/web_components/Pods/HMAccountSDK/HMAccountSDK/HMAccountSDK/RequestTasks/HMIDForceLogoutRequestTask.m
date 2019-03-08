//
//  HMIDForceLogoutRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2017/4/12.
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import "HMIDForceLogoutRequestTask.h"

HMIDForceLogoutScopeKey * _Nonnull const HMIDForceLogoutScopeKeyAll = @"all";
HMIDForceLogoutScopeKey * _Nonnull const HMIDForceLogoutScopeKeyOne = @"one";

@interface HMIDForceLogoutRequestTask ()

@property (nonnull, nonatomic, copy) NSString *loginToken;

@property (nonnull, nonatomic, copy) NSString *appName;

@property (nonnull, nonatomic, copy) HMIDForceLogoutScopeKey *scope;

@end

@implementation HMIDForceLogoutRequestTask

- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken appName:(nonnull HMIDForceLogoutScopeKey *)appName scope:(nonnull NSString *)scope{
    self = [super init];
    if (self) {
        self.loginToken = loginToken;
        self.appName = appName;
        self.scope = scope;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/force_logout";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.loginToken]) {
        return [NSError wsLocalParamErrorKey:@"loginToken"];
    }
    if ([HMAccountTools isEmptyString:self.appName]) {
        return [NSError wsLocalParamErrorKey:@"appName"];
    }
    if ([HMAccountTools isEmptyString:self.scope]) {
        return [NSError wsLocalParamErrorKey:@"scope"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.loginToken forKey:@"login_token"];
    [self.parameter setObject:self.appName forKey:@"app_name"];
    [self.parameter setObject:self.scope forKey:@"scope"];
    [self.parameter setObject:[HMAccountTools appVersion] forKey:@"os_version"];
}

@end
