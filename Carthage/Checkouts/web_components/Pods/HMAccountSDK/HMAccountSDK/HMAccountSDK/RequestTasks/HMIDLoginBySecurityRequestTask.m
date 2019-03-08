//
//  HMIDLoginBySecurityRequestTask.m
//  HMAuthDemo
//
//  Created by 李林刚 on 2017/4/25.
//  Copyright © 2017年 李林刚. All rights reserved.
//

#import "HMIDLoginBySecurityRequestTask.h"

@interface HMIDLoginBySecurityRequestTask ()

@property (nonnull, nonatomic, copy) NSString *appName;

@property (nonnull, nonatomic, copy) NSString *thirdName;

@property (nonnull, nonatomic, copy) NSString *security;

@property (nonnull, nonatomic, copy) NSString *thirdId;

@property (nonnull, nonatomic, copy) NSString *deviceIdType;

@property (nonnull, nonatomic, copy) NSString *deviceId;

@end

@implementation HMIDLoginBySecurityRequestTask

@synthesize loginItem = _loginItem;
@synthesize loginTokenItem = _loginTokenItem;

- (nonnull instancetype)initWithAppName:(nonnull NSString *)appName
                              thirdName:(nonnull NSString *)thirdName
                               security:(nonnull NSString *)security
                                thirdId:(nonnull NSString *)thirdId
                           deviceIdType:(nullable NSString *)deviceIdType
                               deviceId:(nullable NSString *)deviceId {
    self = [self init];
    if (self) {
        self.appName = appName;
        self.thirdName = thirdName;
        self.security = security;
        self.thirdId = thirdId;
        if ([HMAccountTools isEmptyString:deviceIdType]) {
            self.deviceIdType = @"unkown";
        } else {
            self.deviceIdType = [deviceIdType length] > 10 ? [deviceIdType substringToIndex:10] : deviceIdType;
        }
        if ([HMAccountTools isEmptyString:deviceId]) {
            self.deviceId = @"unkown";
        } else {
            self.deviceId = [deviceId length] > 100 ? [deviceId substringToIndex:100] : deviceId;
        }
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/login_by_security";
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
        return [NSError wsLocalParamErrorKey:@"app_name"];
    }
    if ([HMAccountTools isEmptyString:self.thirdName]) {
        return [NSError wsLocalParamErrorKey:@"third_name"];
    }
    if ([HMAccountTools isEmptyString:self.thirdId]) {
        return [NSError wsLocalParamErrorKey:@"third_id"];
    }
    if ([HMAccountTools isEmptyString:self.security]) {
        return [NSError wsLocalParamErrorKey:@"security"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.thirdName forKey:@"third_name"];
    [self.parameter setObject:self.appName forKey:@"app_name"];
    [self.parameter setObject:self.thirdId forKey:@"third_id"];
    [self.parameter setObject:self.security forKey:@"security"];
    
    [self.parameter setObject:self.deviceIdType forKey:@"device_id_type"];
    [self.parameter setObject:self.deviceId forKey:@"device_id"];
    
    [self.parameter setObject:[HMAccountTools systemLanguage] forKey:@"lang"];
    [self.parameter setObject:self.appName forKey:@"source"];
    [self.parameter setObject:[HMAccountTools deviceModel] forKey:@"device_model"];
    [self.parameter setObject:[HMAccountTools appVersion] forKey:@"os_version"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    _loginItem = [[HMIDLoginItem alloc] initWithDictionary:infoDict];
    _loginTokenItem = [[HMIDLoginTokenItem alloc] initWithDictionary:infoDict[@"token_info"]];
}

@end
