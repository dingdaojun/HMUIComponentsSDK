//  HMWebViewController+MiFit.m
//  Created on 2018/6/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWebViewController+MiFit.h"
@import ReactiveObjC;
#import <HMAccountSDK.h>

// 相关测试URL
#define JINGXUAN_URL    @"https://cdn.awsbj0.fds.api.mi-img.com/aos-pro/discovery/3.8.1/index.html?type=jingxuan&baidusiteId=ddbe3b5cebb62d4f23b311d6c542f76b&title=%E7%B2%BE%E9%80%89#/appPage/jingxuan"
#define SAISHI_URL  @"https://cdn.awsbj0.fds.api.mi-img.com/prod-mifit-activity/hm-saishi3/index.html?v=20171011"
#define GAN_HUO @"https://cdn.awsbj0.fds.api.mi-img.com/aos-pro/discovery/3.8.1/index.html?type=ganhuo&baidusiteId=ddbe3b5cebb62d4f23b311d6c542f76b&title=%E7%B2%BE%E9%80%89#/appPage/ganhuo"
#define DEBUG_WEBURL    @"https://cdn.awsbj0.fds.api.mi-img.com/aos-common/bridgeTools/index.html?v=0620"
#define OTHER_URL   @"https://api-mifit-cn.huami.com/huami.health.authorization.oauth.do?third_party_id=4290351154683723"
#define MIDONGQUAN  @"https://cdn.awsbj0.fds.api.mi-img.com/prod-mifit-activity/x-running-circle/index.html?v=20180123"
#define XUNZHANG    @"https://api-mifit.huami.com/t/mifit3.mine.icon.medal"

@implementation HMWebViewController (MiFit)

+ (HMWebViewController *)baseVC {
    
    HMWebViewController *webViewVC = [[HMWebViewController alloc] init];
    /*
     if (![UIDevice isIOS9_LowVserion]) {
     webViewVC.customUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_2 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C202 com.xiaomi.hm.health/73_3.2.7 NetType/WIFI Language/zh_CN Country/CN UserRegion/1";
     } else {
     
     } */
    webViewVC.isJSBridgeNeedAuth = NO;
    webViewVC.requestURL = JINGXUAN_URL;
    
    //外部宿主执行操作
    /*
    @weakify(webViewVC);
    webViewVC.shareBlock = ^(BOOL buttonEvent, WVJBShareViewModel *shareVM) {
        NSLog(@"share 外部配置");
        @strongify(webViewVC);
        [webViewVC reloadWebViewWithRequestURL:nil];
    };
    webViewVC.fetchMifitInfo = ^(JBContentType contentType, WVJBResponseCallback callBack) {
        NSLog(@"获取指定内容, content type: %ld",(long)contentType);
        switch (contentType) {
            case JBContentTypeLocation:
            {
                NSDictionary *dict = @{
                                       @"adcode":@(340104),
                                       @"address":@"高新技术产业开发区",
                                       @"city":@"合肥市",
                                       @"country":@"中国",
                                       @"district":@"蜀山区",
                                       @"latitude":@"31.84117317199707",
                                       @"longitude":@"117.1313858032227",
                                       @"province":@"安徽省"
                                       };
                callBack([WVJBUtils JSONWithDict:dict]);
            }
                break;
            case JBContentTypeUserInfo:
            {
                if ([HMAccountSDK isLogin]) {
                    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
                    NSDictionary *dict = @{
                                           @"avatar":[userDict objectForKey:@"avatar"],
                                           @"birthday":@"1993-07",
                                           @"gender":@(1),
                                           @"height":@(170),
                                           @"nickname":[userDict objectForKey:@"nickname"],
                                           @"openType":@"mi",
                                           @"uid":[userDict objectForKey:@"uid"],
                                           @"weight":@(60),
                                           };
                    callBack([WVJBUtils JSONWithDict:dict]);
                } else {
                    callBack([WVJBUtils JSONWithDict:[NSDictionary dictionary]]);
                }
            }
                break;
            case JBContentTypeUserToken:
            {
                if ([HMAccountSDK isLogin]) {
                    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
                    NSDictionary *dict = @{
                                           @"openId":[userDict objectForKey:@"openId"],
                                           @"openType":@"mi",
                                           @"token":[userDict objectForKey:@"token"],
                                           @"uid":[userDict objectForKey:@"uid"]
                                           };
                    callBack([WVJBUtils JSONWithDict:dict]);
                } else {
                    callBack([WVJBUtils JSONWithDict:[NSDictionary dictionary]]);
                }
            }
                break;
            case JBContentTypeDeviceInfo:
            {
                NSDictionary *dict = @{
                                       @"brand": @"apple",
                                       @"idfa": @"C6D5D5AB-659A-4FD9-9A61-CEF230D51B68",
                                       @"imei": @"9a6148ef33585bbf4636e3caac5256c439b846db",
                                       @"model": @"iPhone 6s",
                                       @"os": @(2),
                                       @"platform": @"iOS",
                                       @"version": @"11.2.2",
                                       };
                callBack([WVJBUtils JSONWithDict:dict]);
            }
                break;
                
            default:
                break;
        }
    };
    webViewVC.enterVCBlock = ^(NSString *actionName, UINavigationController *nav) {
        NSLog(@"进入指定控制器 %@",actionName);
    };
    webViewVC.login = ^(LoginType loginType) {
        NSLog(@"login 外部配置");
    };
    webViewVC.writeDeviceNotice = ^(NSDictionary *noticeDic, WVJBResponseCallback callBack) {
        NSLog(@"writeDeviceNotice 外部配置");
    };
    webViewVC.showSyncWatchSurface = ^(NSDictionary *watchConfig, WVJBResponseCallback callBack) {
        NSLog(@"showSyncWatch 外部配置");
    };
    webViewVC.webLoadEvent = ^(NSString *eventStatus) {
        //打点统计
        NSLog(@"打点统计, %@",eventStatus);
    }; */
    return webViewVC;
}

//#pragma mark - 多语言协议字段
//- (NSString *)noData_Field {
//    return @"no data";
//}
//
//- (NSString *)noNetwork_Field {
//    return @"no network";
//}
//- (NSString *)loadFail_Field {
//    return @"load fail";
//}
//
//-(NSString *)load_Field {
//    return @"load_Field";
//}
//
//- (NSString *)checkNetwork_Field {
//    return @"checkNetwork_Field";
//}
//
//- (NSString *)noAccess_Field {
//    return @"noAccess_Field";
//}
@end
