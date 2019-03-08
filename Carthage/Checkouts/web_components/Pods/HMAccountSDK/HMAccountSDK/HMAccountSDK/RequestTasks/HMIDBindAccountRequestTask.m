//
//  HMIDBindAccountRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDBindAccountRequestTask.h"
#import "HMIDBindItem.h"

@interface HMIDBindAccountRequestTask ()

@property (nonatomic, copy) NSString *thirdName;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) HMIDTokenGrantTypeOptionKey grantType;

@property (nonatomic, copy) NSString *appToken;

@end

@implementation HMIDBindAccountRequestTask

- (instancetype)initWithThirdName:(NSString *)thirdName
                             code:(NSString *)code
                           region:(NSString *)region
                        grantType:(HMIDTokenGrantTypeOptionKey)grantType
                         appToken:(NSString *)appToken {
    self = [super init];
    if (self) {
        self.thirdName = thirdName;
        self.code = code;
        self.region = region ? region : [HMAccountTools countryCode];
        self.grantType = grantType;
        self.appToken = appToken;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/bind_account";
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
    if ([HMAccountTools isEmptyString:self.code]) {
        return [NSError wsLocalParamErrorKey:@"code"];
    }
    if ([HMAccountTools isEmptyString:self.grantType]) {
        return [NSError wsLocalParamErrorKey:@"grantType"];
    }
    if ([HMAccountTools isEmptyString:self.appToken]) {
        return [NSError wsLocalParamErrorKey:@"appToken"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.thirdName forKey:@"third_name"];
    [self.parameter setObject:self.code forKey:@"code"];
    [self.parameter setObject:self.region forKey:@"country_code"];
    [self.parameter setObject:self.grantType forKey:@"grant_type"];
    [self.parameter setObject:self.appToken forKey:@"app_token"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    self.resultItem = [[HMIDBindItem alloc] initWithDict:infoDict[@"data"]];
}
@end
