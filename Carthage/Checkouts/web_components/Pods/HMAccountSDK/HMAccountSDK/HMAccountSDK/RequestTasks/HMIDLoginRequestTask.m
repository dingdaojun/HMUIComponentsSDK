//
//  HMIDLoginRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDLoginRequestTask.h"

@interface HMIDLoginRequestTask ()

@property (nonnull, nonatomic, copy) HMIDTokenGrantTypeOptionKey grantType;

@property (nonnull, nonatomic, copy) NSString *appName;

@property (nonnull, nonatomic, copy) NSString *thirdName;

@property (nonnull, nonatomic, copy) NSString *code;

@property (nullable, nonatomic, copy) NSString *region;

@property (nonnull, nonatomic, copy) NSString *deviceIdType;

@property (nonnull, nonatomic, copy) NSString *deviceId;

@end

@implementation HMIDLoginRequestTask

@synthesize loginItem = _loginItem;
@synthesize loginTokenItem = _loginTokenItem;
@synthesize domain = _domain;

- (nonnull instancetype)initWithGrantType:(nonnull HMIDTokenGrantTypeOptionKey)grantType
                                  appName:(nonnull NSString *)appName
                                thirdName:(nonnull NSString *)thirdName
                                     code:(nonnull NSString *)code
                                   region:(nonnull NSString *)region
                             deviceIdType:(nullable NSString *)deviceIdType
                                 deviceId:(nullable NSString *)deviceId{
    self = [super init];
    if (self) {
        self.grantType = grantType;
        self.appName = appName;
        self.thirdName = thirdName;
        self.code = code;
        self.region = region ? region : [HMAccountTools countryCode];

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

- (NSURL *)baseUrl {
    return [NSURL URLWithString:[HMAccountConfig idAccountServerHost]];
}

- (NSString *)apiName{
    return @"/v2/client/login";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.grantType]) {
        return [NSError wsLocalParamErrorKey:@"grantType"];
    }
    if ([HMAccountTools isEmptyString:self.thirdName]) {
        return [NSError wsLocalParamErrorKey:@"thirdName"];
    }
    if ([HMAccountTools isEmptyString:self.code]) {
        return [NSError wsLocalParamErrorKey:@"code"];
    }
    if ([HMAccountTools isEmptyString:self.appName]) {
        return [NSError wsLocalParamErrorKey:@"appName"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.thirdName forKey:@"third_name"];
    [self.parameter setObject:self.grantType forKey:@"grant_type"];
    [self.parameter setObject:self.code forKey:@"code"];
    [self.parameter setObject:self.region forKey:@"country_code"];

    [self.parameter setObject:self.appName forKey:@"app_name"];
    [self.parameter setObject:self.deviceIdType forKey:@"device_id_type"];
    [self.parameter setObject:self.deviceId forKey:@"device_id"];
    
    [self.parameter setObject:[HMAccountTools systemLanguage] forKey:@"lang"];
    [self.parameter setObject:self.appName forKey:@"source"];
    [self.parameter setObject:[HMAccountTools deviceModel] forKey:@"device_model"];
    [self.parameter setObject:HMAccountSDKVersion forKey:@"os_version"];
    [self.parameter setObject:[HMAccountTools appVersion] forKey:@"app_version"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    _loginItem = [[HMIDLoginItem alloc] initWithDictionary:infoDict];
    _loginTokenItem = [[HMIDLoginTokenItem alloc] initWithDictionary:infoDict[@"token_info"]];
    _domain = infoDict[@"domain"][@"id-dns"];
}

@end
