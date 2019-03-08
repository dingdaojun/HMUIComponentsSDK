//
//  HMIDGetPhoneNumberRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/9/13.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDGetPhoneNumberRequestTask.h"

@interface HMIDGetPhoneNumberRequestTask ()

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *appToken;


@property (nonatomic, strong, readwrite) NSString *phoneNumber;

@end

@implementation HMIDGetPhoneNumberRequestTask

- (instancetype)initWithUserId:(NSString *)userId
                      appToken:(NSString *)appToken {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.appToken = appToken;
    }
    return self;
}

- (NSString *)apiName{
    return [NSString stringWithFormat:@"/v1/client/users/%@/profile",self.userId];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.appToken]) {
        return [NSError wsLocalParamErrorKey:@"appToken"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.appToken forKey:@"app_token"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    self.resultItem = infoDict[@"phone_number"];
}

@end
