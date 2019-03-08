//  AppDelegate.m
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "AppDelegate.h"
#import <DDSocialShareHandler.h>
#import <HMAccountSDK.h>
@import HMLog;
@import WebKit;

@interface AppDelegate ()

@property (nonatomic, strong) NSDictionary *userDict;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformMI appKey:@"2882303761517154077" redirectURL:@"https://api-mifit-cn.huami.com/huami.health.loginview.do"];
    
    HMLogManager *manager = [HMLogManager sharedInstance];
#if DEBUG
    HMConsoleLogger *console = [HMConsoleLogger sharedLogger];
    console.filterLevels = [NSSet setWithArray:@[@(HMLogLevelVerbose), @(HMLogLevelInfo), @(HMLogLevelDebug), @(HMLogLevelError), @(HMLogLevelWarning), @(HMLogLevelFatal)]];
    [manager addLogger:console];
    
    HMWebLogger *web = [[HMWebLogger alloc] initWithPort:9999];
    [manager addLogger:web];
#endif
    HMDatabaseLogger *db = [HMDatabaseLogger sharedLogger];
    db.filterLevels = [NSSet setWithArray:@[@(HMLogLevelError), @(HMLogLevelWarning), @(HMLogLevelFatal)]];
    db.maximumItemCount = 10000;
    [manager addLogger:db];
    
    HMFileLogger *file = [HMFileLogger sharedLogger];
    [manager addLogger:file];
    
    [manager startup];
    
    
    // 查看用户登录信息
    self.userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSLog(@"用户信息: %@",self.userDict);
    
    // 修改全局WKWebView UserAgent ,针对iOS8.x设备
    /*
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"origin UserAgent: %@",userAgent);
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":@"Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_2 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C202 com.xiaomi.hm.health/73_3.2.7 NetType/WIFI Language/zh_CN Country/CN UserRegion/1"}];
    */
    return YES;
}

- (NSString *)userIDForService:(id<HMServiceAPI>)service {
    return [self.userDict objectForKey:@"uid"];
}

- (NSString *)absoluteURLForService:(id<HMServiceAPI>)service referenceURL:(NSString *)referenceURL {
    NSString *baseUrl = @"https://api-mifit.huami.com/";
    NSString *absoluteURL = [baseUrl stringByAppendingPathComponent:referenceURL];
    NSString *requester = [self URLRequestLogUUID];
    NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;
    
    if ([absoluteURL containsString:@"?"]) {
        return [NSString stringWithFormat:@"%@&r=%@&t=%.0f", absoluteURL, requester, timestamp * 1000];
    }
    else {
        return [NSString stringWithFormat:@"%@?r=%@&t=%.0f", absoluteURL, requester, timestamp * 1000];
    }
}

- (NSString *)URLRequestLogUUID {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppLifeUUIDKey"];
    if ([uuid length]) {
        return uuid;
    }
    
    uuid = [[NSUUID UUID] UUIDString];
    if ([uuid length]) {
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"AppLifeUUIDKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return uuid;
}

- (NSDictionary<NSString *, NSString *> *)uniformHeaderFieldValuesForService:(id<HMServiceAPI>)service error:(NSError **)error {
    return [self uniformHeaderFieldValuesForService:service auth:YES error:error];
}

- (NSDictionary<NSString *, NSString *> *)uniformHeaderFieldValuesForService:(id<HMServiceAPI>)service auth:(BOOL)auth error:(NSError **)error {
    NSDictionary *tmpDict = @{
                              @"X-Request-Id": @"7654C395-B6E0-4DAC-ADE3-3B3B1D8A07C6",
                              @"appname":@"com.xiaomi.hm.health",
                              @"appplatform": @"ios_phone",
                              @"channel": @"appstore",
                              @"country": @"CN",
                              @"cv": @"73_3.2.7",
                              @"hm-privacy-ceip": @"true",
                              @"hm-privacy-diagnostics":@"false",
                              @"lang": @"zh_CN",
                              @"timezone":@"Asia/Shanghai",
                              @"v": @"2.0"
                              };
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tmpDict];
    NSString *token = [self.userDict objectForKey:@"token"];
    
    [dict setObject:token forKey:@"apptoken"];
    
    return dict;
}

- (NSDictionary<NSString *, id> *)uniformParametersForService:(id<HMServiceAPI>)service error:(NSError **)error {
    return nil;
}

- (void)service:(HMServiceAPI *)service didDetectError:(NSError *)error inAPI:(NSString *)apiName localizedMessage:(NSString *__autoreleasing *)message {
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
        } break;
        case HMServiceAPIErrorUnknown:
            *message = @"未知错误";
    }
}

@end
