//  RCTHMWebView.m
//  Created on 2018/6/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "RCTHMWebView.h"
#import "WVJBManager.h"
#import "WVJBUtils.h"
#import <WebKit/WebKit.h>

@interface RCTHMWebView () <WKNavigationDelegate,WVJBManagerDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WVJBManager *wvjbManager;
@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;

@end

@implementation RCTHMWebView

- (void)dealloc {
    [_webView stopLoading];
    _webView.navigationDelegate = nil;
    [_jsBridge setWebViewDelegate:nil];
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _webView = [[WKWebView alloc] initWithFrame:self.bounds];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.navigationDelegate = self;
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 /* __IPHONE_11_0 */
        if ([_webView.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
#endif
        _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
        [_jsBridge setWebViewDelegate:self];
        
        _wvjbManager = [[WVJBManager alloc] initWithJSBridge:_jsBridge];
        _wvjbManager.delegate = self;
        
        [self addSubview:_webView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _webView.frame = self.bounds;
}

- (void)setSourceURL:(NSString *)sourceURL {
    _sourceURL = sourceURL;
    NSString *urlStr = [RCTConvert NSString:sourceURL];
    RCTLogInfo(@"设置的URL地址: %@",urlStr);
    
    // 全局注册userAgent
    NSString *userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_2 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C202 com.xiaomi.hm.health/73_3.2.7 NetType/WIFI Language/zh_CN Country/CN UserRegion/1";
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sourceURL]]];
}

#pragma mark - WVJBManagerDelegate
// 处理信息获取
- (void)fetchMifitInfo:(JBContentType)contentType callBack:(WVJBResponseCallback)callBack {
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
        }
            break;
        case JBContentTypeUserToken:
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSDictionary *dict = @{
                                   @"openId":[userDict objectForKey:@"openId"],
                                   @"openType":@"mi",
                                   @"token":[userDict objectForKey:@"token"],
                                   @"uid":[userDict objectForKey:@"uid"]
                                   };
            callBack([WVJBUtils JSONWithDict:dict]);
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
    }
}
@end
