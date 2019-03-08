//
//  HMIDUnBindAccountRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDUnBindAccountRequestTask.h"

@interface HMIDUnBindAccountRequestTask ()

@property (nonatomic, copy) NSString *thirdName;

@property (nonatomic, copy) NSString *thirdId;

@property (nonatomic, copy) NSString *appToken;

@end

@implementation HMIDUnBindAccountRequestTask

- (instancetype)initWithThirdName:(NSString *)thirdName
                          thirdId:(NSString *)thirdId
                         appToken:(NSString *)appToken {
    self = [super init];
    if (self) {
        self.thirdName = thirdName;
        self.appToken = appToken;
        self.thirdId = thirdId;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/unbind_account";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.thirdName]) {
        return [NSError wsLocalParamErrorKey:@"thirdName"];
    }
    if ([HMAccountTools isEmptyString:self.thirdId]) {
        return [NSError wsLocalParamErrorKey:@"thirdId"];
    }
    if ([HMAccountTools isEmptyString:self.appToken]) {
        return [NSError wsLocalParamErrorKey:@"appToken"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.thirdName forKey:@"third_name"];
    [self.parameter setObject:self.thirdId forKey:@"third_id"];
    [self.parameter setObject:self.appToken forKey:@"app_token"];
}

@end
