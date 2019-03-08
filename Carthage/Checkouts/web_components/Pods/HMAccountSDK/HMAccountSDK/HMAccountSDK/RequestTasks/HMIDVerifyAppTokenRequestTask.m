//
//  HMIDVerifyAppTokenRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDVerifyAppTokenRequestTask.h"

@interface HMIDVerifyAppTokenRequestTask ()

@property (nonnull, nonatomic, copy) NSString *appName;

@property (nonnull, nonatomic, copy) NSString *appToken;

@end

@implementation HMIDVerifyAppTokenRequestTask

- (nonnull instancetype)initWithAppName:(nonnull NSString *)appName
                               appToken:(nonnull NSString *)appToken{
    self = [super init];
    if (self) {
        self.appName = appName;
        self.appToken = appToken;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/verify_app_token";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.appName]) {
        return [NSError wsLocalParamErrorKey:@"appName"];
    }
    if ([HMAccountTools isEmptyString:self.appToken]) {
        return [NSError wsLocalParamErrorKey:@"appToken"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.appName forKey:@"app_name"];
    [self.parameter setObject:self.appToken forKey:@"app_token"];
}


@end
