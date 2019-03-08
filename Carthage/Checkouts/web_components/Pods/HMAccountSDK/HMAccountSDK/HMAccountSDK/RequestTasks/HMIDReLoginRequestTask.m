//
//  HMIDReLoginRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDReLoginRequestTask.h"

@interface HMIDReLoginRequestTask ()

@property (nonnull, nonatomic, copy) NSString *loginToken;

@property (nonnull, nonatomic, copy) NSString *appName;

@property (nonnull, nonatomic, copy) NSString *deviceIdType;

@property (nonnull, nonatomic, copy) NSString *deviceId;

@end

@implementation HMIDReLoginRequestTask

@synthesize loginTokenItem = _loginTokenItem;
@synthesize appTokenItem = _appTokenItem;

- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken
                                   appName:(nonnull NSString *)appName
                              deviceIdType:(nonnull NSString *)deviceIdType
                                  deviceId:(nonnull NSString *)deviceId{
    self = [super init];
    if (self) {
        self.loginToken = loginToken;
        self.appName = appName;
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
    return @"/v1/client/re_login";
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
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.loginToken forKey:@"login_token"];
    [self.parameter setObject:self.appName forKey:@"app_name"];
    [self.parameter setObject:self.deviceIdType forKey:@"device_id_type"];
    [self.parameter setObject:self.deviceId forKey:@"device_id"];
    
    
    [self.parameter setObject:[HMAccountTools systemLanguage] forKey:@"lang"];
    [self.parameter setObject:self.appName forKey:@"source"];
    [self.parameter setObject:[HMAccountTools deviceModel] forKey:@"device_model"];
    [self.parameter setObject:[HMAccountTools appVersion] forKey:@"os_version"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    _loginTokenItem = [[HMIDLoginTokenItem alloc] initWithDictionary:infoDict[@"token_info"]];
    _appTokenItem = [[HMIDAppTokenItem alloc] initWithDictionary:infoDict[@"token_info"]];
}


@end
