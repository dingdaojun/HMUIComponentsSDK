//  HMServiceTest.m
//  Created on 2018/3/17
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"

/**
 此处宏统一配置全局环境
 */
#define TrainingEnvironmentRelease     0          // 正式环境

/*
 此处统一配置全局host，userid，token字段
 子类TestCase可以重写实现单case自定义
 */
#if TrainingEnvironmentRelease
static NSString * const kHost = @"https://api-mifit.huami.com";

static NSString * const kUserID = @"1033358777";
static NSString * const kAppToken = @"CQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAALvVvQVTlJb4oIyEi1VuHHb7F9bZVoKpZNsE-9ErqLkUCYbl4z5OXCU65Bpp1K4qimkku5u_Tx_8lPo2LDNKE9A7nzQ8BaI74gSJiiZgp7mUaH5THrD3ZyvaplQg3p0wPnT8QvaBQsLkV_4AawMRjssGR1QelUhbR1gzCy0ziiF4";

#else

//static NSString * const kHost = @"http://mifit-device-service-staging-nfc.mi-ae.net";
static NSString * const kHost = @"https://api-mifit-staging.huami.com";

static NSString * const kUserID = @"1024532393";
static NSString * const kAppToken = @"cQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAADJX4zUQDehr0X64vRH3_IqILHU_qHohMWZ8k-488B4XqJRicEr16L81lqHDmi_FkgtdVvgjWmT5AvdjUrzozqz2dGdzw0ttV7gFsiuNXUJhu0NTKvmt49iF0Hn8Yc21e3SybqtL4SCTvv__mi6IvOmwasTPkonNoHjieN_Vk_xH";





#endif

@implementation HMServiceTest



+ (NSString *)URLRequestLogUUID {

    NSString *key = @"MiFitAppLifeUUIDKey";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *UUID = [userDefaults stringForKey:key];
    if (UUID.length > 0) {
        return UUID;
    }

    UUID = [NSUUID UUID].UUIDString;

    [userDefaults setObject:UUID forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return UUID;
}

#pragma mark - HMServiceDelegate
- (NSString *)userIDForService:(id<HMServiceAPI>)service {
    return [self userID];
}

- (NSString *)absoluteURLForService:(id<HMServiceAPI>)service referenceURL:(NSString *)referenceURL {
    NSString *absoluteURL = [[self host] stringByAppendingPathComponent:referenceURL];

    NSString *requester = [[self class] URLRequestLogUUID];
    NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;

    if ([absoluteURL containsString:@"?"]) {
        return [NSString stringWithFormat:@"%@&r=%@&t=%.0f", absoluteURL, requester, timestamp * 1000];
    }
    else {
        return [NSString stringWithFormat:@"%@?r=%@&t=%.0f", absoluteURL, requester, timestamp * 1000];
    }
}

- (NSDictionary<NSString *, NSString *> *)uniformHeaderFieldValuesForService:(id<HMServiceAPI>)service error:(NSError **)error {

    return [self uniformHeaderFieldValuesForService:service auth:YES error:error];
}

- (NSDictionary<NSString *, NSString *> *)uniformHeaderFieldValuesForService:(id<HMServiceAPI>)service auth:(BOOL)auth error:(NSError **)error {

    NSMutableDictionary *header = [@{@"appname": @"com.xiaomi.hm.health",
                                     @"channel": @"appstore",
                                     @"cv": @"8_1.5.8",
                                     @"v": @"2.0",
                                     @"appplatform": @"ios_phone",
                                     @"lang": @"zh_CN",
                                     @"country": @"CN",
                                     @"timezone": @"Asia/Shanghai"
                                     } mutableCopy];

    if (auth) {
        [header setObject:[self appToken] forKey:@"apptoken"];
    }
    return header;
}

- (NSDictionary<NSString *, id> *)uniformParametersForService:(id<HMServiceAPI>)service error:(NSError *__autoreleasing *)error {
    return nil;
}

- (void)service:(id<HMServiceAPI>)service
 didDetectError:(NSError *)error
          inAPI:(NSString *)apiName
localizedMessage:(NSString *__autoreleasing *)message {

    switch (error.code) {
            case HMServiceAPIErrorNone:
            break;
            case HMServiceAPIErrorNetwork:
            *message = @"网络连接失败";
            break;
            case HMServiceAPIErrorResponseDataFormat:
            *message = @"接口返回参数错误";
            break;
            case HMServiceAPIErrorServerInternal:
            *message = @"服务器内部错误";
            break;
            case HMServiceAPIErrorParameters:
            *message = @"参数错误";
            break;
            case HMServiceAPIErrorInvalidToken:
            *message = @"无效token";
            break;
            case HMServiceAPIErrorMutexLogin: {
                *message = @"单点登录";
                NSDate *time = error.userInfo[HMServiceAPIErrorUserInfoMutexLoginTimeKey];
                NSLog(@"mutex login time is: %@", time);
            } break;
            case HMServiceAPIErrorUnknown:
            *message = @"未知错误";
    }
}

- (void)handleTestResultWithAPIName:(NSString *)name
                         parameters:(NSDictionary *)parameters
                            success:(BOOL)success
                            message:(NSString *)message
                               data:(id)data {
    NSLog(@"\n"
          "API: %@\n"
          "parameters: \n%@\n"
          "result: %@\n"
          "message: %@\n"
          "data: %@\n",
          name,
          parameters,
          success ? @"success" : @"failed",
          message,
          data);
}

- (NSString *)userID {
    return kUserID;
}


- (NSString *)host {
    return kHost;
}

- (NSString *)appToken {
    return kAppToken;
}

- (NSDictionary<NSString *, NSString *> *)uniformWalletHeaderFieldValues {

    return @{@"x-snbps-cplc" : @"4790057347012198010081130559439464924810000000510000044612B3354A80010000000000535244",
             @"x-snbps-module" : @"XMSH06HM",
             @"x-snbps-imei": @"40996CD720C3",
             @"x-snbps-rom-version" : @"test",
             @"x-snbps-os-version" : @"test",
             @"clientId": @"2882303761517154077",
             @"x-snbps-userid": @"3150003391",
             @"x-snbps-token": @"V2_VwX9UgN_tHecEMZ98jISK0AwBa3rueBGhXENewIiuRQwm-jFjb-NqQA3c40aekLnD9Ra2e5ccqmpAcz20gU6RmDvwiIAtAZcRsxhKV8oHLz1P94SLLmT9ZUa7jho08PyI2nZMMuYGkSrm8_UYSvEsiROkLf-7SriZsUULrimHvQ"};

//    return @{@"x-snbps-cplc": @"4790057347012198010081130558909464924810000000510000042111b3354a80010000000000535244",
//             @"x-snbps-module": @"XMSH06HM",
//             @"x-snbps-imei": @"09219D4365D6",
//             @"x-snbps-rom-version" : @"test",
//             @"x-snbps-os-version" : @"test",
//             @"x-snbps-userid" : @"690559145",
//             @"x-snbps-token" : @"V2_-3Pey2QeQz6Tx0EX48jeLhZtV5vS2Cc4xpqCQpocUwgSoU1KuJtTH8ZSr3WKhVSuS8_4UKuALCt-Kfg65sT6EbTkSakCPEgKsm7JCbkv5rZbofbLbGdrT4evWt33rrfXEXn6wgk5UhbP2YzNb0bbkg",
//             };
}


//    curl -i \
//    -X POST \
//    -H "x-snbps-imei:14B382DCB8F0"  \
//    -H "lang:zh_CN"  \
//    -H "User-Agent:HuamiPayExample/1.0 (iPhone; iOS 11.4; Scale/2.00)"  \
//    -H "appplatform:ios_phone"  \
//    -H "country:CN"  \
//    -H "clientId:2882303761517154077"  \
//    -H "channel:appstore"  \
//    -H "x-snbps-userid:165402595"  \
//    -H "v:1.0"  \
//    -H "x-snbps-rom-version:test"  \
//    -H "appname:com.xiaomi.hm.health"  \
//    -H "x-snbps-cplc:4790057347012198010081130560489464924810000000510000043913B3354A80010000000000535244"  \
//    -H "x-snbps-token:V2_eLP7f7QI0ubVMegdhvmp4YJTHOhzuVqVRe2ybJjZ05koGP_VXc6D94XyhbVtnbsxZSZBEzn_lFFS5FuQfJgOvwwVpxlec0kRotEbYMMDX2ZUFXkUO5EgrPhj6BDXO1-XrXeB5YMCrB0NNolhFiJATQ"  \
//    -H "Accept-Language:zh-Hans-CN;q=1, en-CN;q=0.9"  \
//    -H "timezone:Asia/Shanghai"  \
//    -H "x-snbps-module:XMSH06HM"  \
//    -H "x-snbps-os-version:test"  \
//    -H "apptoken:cQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAAGYoW1-NdghhtLw3Vj9yTEwhoBm0TzikkZqy-lZPMkVQ9cootFq2hOZJh00lAWSOt56bOFAzbTDsq7Lpvr3FLPQrlUa7Dcky9tOrzHVbD7bjRcmqIF8lQDuZmnhXJzbJ_k6uirnMwz1I6WlyhAPhZRhMUWOzkxczse_DITBmb9Wz"  \
//    -H "cv:8_1.5.8"  \
//    -H "Content-Type:application/x-www-form-urlencoded"  \
//    -d "=&action_type=copyFareCard&aid=&atqa=0400&blockContent=1111111111&fareCardType=10&fetch_adpu_mode=&sak=08&size=10&uid=ce9c6d54" \
//    "http://mifit-device-service-staging-nfc.mi-ae.net/nfc/accessCard/script/init?r=9FDB5CED-6197-4D00-9030-AA69EA5F5529&t=1531968977919"



@end

