//  ViewController.m
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "ViewController.h"
#import "HMWebViewController+MiFit.h"
#import "WVJBUtils.h"

#import <HMAccountSDK.h>
#import <DDSocialShareHandler.h>
#import "UserInfoModel.h"
#import "HMProgressHUD.h"

@import HMCategory;
@import ReactiveObjC;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JSBridge页面测试";
    [HMAccountConfig setServerEnvironment:HMIDServerEnvironmentLive];
    
    // 修改全局WKWebView UserAgent ,针对iOS8.x设备
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = [userAgent stringByAppendingString:@" com.xiaomi.hm.health/73_3.2.7 NetType/WIFI Language/zh_CN Country/CN UserRegion/1"];
    NSLog(@"new UserAgent: %@",newUserAgent);
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
    
}

- (IBAction)openVC:(id)sender {
    HMWebViewController *webViewVC = [HMWebViewController baseVC];
    
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (IBAction)loginAccount:(id)sender {
    
    DDSSPlatform sPlatform = DDSSPlatformMI;
    DDSSAuthMode mode = DDSSAuthModeCode;
    
    [[DDSocialShareHandler sharedInstance] authWithPlatform:sPlatform authMode:mode controller:self handler:^(DDSSPlatform platform, DDSSAuthState state, DDAuthItem *authItem, NSError *error) {
        if (state == DDSSAuthStateBegan) {
        } else if (state == DDSSAuthStateSuccess) {
            HMIDAuthItem *auth = [[HMIDAuthItem alloc] init];
            auth.thirdId = authItem.thirdId;
            auth.thirdToken = authItem.thirdToken;
            HMIDLoginPlatForm idPlatform = HMIDLoginPlatFormMI;
            
            [HMProgressHUD showHUDWithStatus:@"登录中..."];
            [HMAccountSDK loginWithPlatform:idPlatform region:nil authItem:auth eventHandler:^(HMIDLoginItem *loginItem, NSError *error) {
                if (error) {
                    [HMProgressHUD showErrorWithStatus:@"失败"];
                } else {
                    [HMProgressHUD showSucessWithStatus:@"成功"];
                    
                    [self clearCookie];
                    
                    UserInfoModel *userInfo = [[UserInfoModel alloc] init];
                    userInfo.nickname = loginItem.userItem.nickname;
                    userInfo.avatarURL = loginItem.userItem.avatarURL;
                    userInfo.userId = loginItem.appTokenItem.userId;
                    userInfo.appToken = loginItem.appTokenItem.appToken;
                    userInfo.thirdId = loginItem.userItem.thirdId;
                    userInfo.region = loginItem.registItem.region;
                    [userInfo saveUserDict];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }];
        } else if (state == DDSSAuthStateCancel) {
            [HMProgressHUD showErrorWithStatus:@"取消授权"];
        } else if (state == DDSSAuthStateFail) {
            [self handlerError:error];
        }
    }];
    
}

- (void)logoutForce:(BOOL)force{
    [HMProgressHUD showHUDWithStatus:@"退出中..."];
    [HMAccountSDK logoutForce:force eventHandler:^(NSError *error) {
        if (!force && error) {
            [HMProgressHUD dismiss];
            [self handlerError:error];
        } else {
            [HMProgressHUD showSucessWithStatus:@"退出成功"];
        }
    }];
}

- (void)handlerError:(NSError *)error{
    if (!error) {
        return;
    }
    if (error.idErrorType == HMIDErrorTypeMutexLogin) {
        NSTimeInterval dateTime = error.idMutime / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM月dd日 HH:mm";
        NSString *dateString = [formatter stringFromDate:date];
        NSString *alertStr = [NSString stringWithFormat:@"你的设备于%@在另一台手机上登录", dateString];
        [[[UIAlertView alloc] initWithTitle:@"互斥登录" message:alertStr delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil] show];
    } else {
        [HMProgressHUD showErrorWithStatus:@"失败了"];
    }
}

- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
    [self logoutForce:YES];
}

- (void)clearCookie {
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
