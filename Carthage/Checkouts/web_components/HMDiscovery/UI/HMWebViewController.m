//  HMWebViewController.m
//  Created on 2018/5/16
//  Description web控制器

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWebViewController.h"
#import "HMWebNavigationBar.h"
#import "HMWebPromptView.h"
#import "WVBTManager.h"
#import "WVJBUtils.h"
#import <StoreKit/StoreKit.h>
#import <WebKit/WebKit.h>
#import "WVNetworkReachability.h"
@import AVFoundation;
@import HMCategory;
@import Masonry;
@import ReactiveObjC;
@import MIFitService;
@import HMLog;

@interface HMWebViewController () <WKNavigationDelegate,WKUIDelegate,WVJBManagerDelegate,WVBTManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SKStoreProductViewControllerDelegate>
/** 授权链接*/
@property (nonatomic, copy) NSString *authorizeUrlString;
@property (nonatomic, assign) BOOL hasFinishLoad;
@property (nonatomic, assign) BOOL isInMarket;

@property (strong, nonatomic)  UIProgressView *progressView;
@property (strong, nonatomic)  HMWebPromptView *promptView;
@property (strong, nonatomic)  HMWebNavigationBar *navigationBar;
@property (strong, nonatomic)  WKWebView *webView;

@property (strong, nonatomic)  WKWebViewJavascriptBridge *jsBridge;
@property (strong, nonatomic)  WVJBManager *bridgeManager;
@property (strong, nonatomic)  WVBTManager *braceletManager;
@property (strong, nonatomic)  WVJBShareViewModel *shareViewModel;
@property (copy,   nonatomic)  WVJBResponseCallback wechatPayEventCallBack;
@property (assign, nonatomic)  BOOL navigationVisible;
/** JBBridge业务适配器*/
@property (nonatomic, strong) id<WVJBBusinessProtocol> businessAdapter;

@end

@implementation HMWebViewController

- (instancetype)initWithWVJBBusinessAdapter:(id<WVJBBusinessProtocol>)businessAdapter {
    self = [super init];
    if (self) {
        self.businessAdapter = businessAdapter;
        self.isJSBridgeNeedAuth = YES;
        if (@available(iOS 11.0, *)) {
            self.additionalSafeAreaInsets = UIEdgeInsetsMake([UIDevice isPhoneXDevice] ? -64 : -20, 0, 0, 0);
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        // 注册自定义userAgent
        if ([self.businessAdapter respondsToSelector:@selector(registerCustomUserAgent)]) {
            [self.businessAdapter registerCustomUserAgent];
        } else {
            HMLogW(discovery, @"没有实现注册自定义userAgent，可能导致mifit相关页面打不开");
        }
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.isJSBridgeNeedAuth = YES;
        if (@available(iOS 11.0, *)) {
            self.additionalSafeAreaInsets = UIEdgeInsetsMake([UIDevice isPhoneXDevice] ? -64 : -20, 0, 0, 0);
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}

- (void)dealloc {
    HMLogD(discovery,@"HMWebViewController 释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.jsBridge setWebViewDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 网络状态监听
    @weakify(self);
    [[WVNetworkReachability sharedInstance] addObserver:self reachableChanged:^(BOOL reachable) {
        @strongify(self);
        if (!reachable) {
            [self.promptView showPromptWithType:PromptTypeNoNetwork];
        } else {
            [self loadWebView];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[WVNetworkReachability sharedInstance] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self subscribeSignals];
    
    [self loadWebView];
}

- (void)subscribeSignals {
    
    self.shareViewModel = [[WVJBShareViewModel alloc] init];
    NSDictionary *defaultShareDict = @{ @"title" : self.shareTitle ? self.shareTitle : @"",
                                        @"content" : self.shareSubTitle ? self.shareSubTitle : @"",
                                        @"url" : self.shareUrl ? self.shareUrl : @"" };
    [self.shareViewModel configSharePlatform:defaultShareDict isJBShare:NO isShareLink:self.shareLink currentURL:self.requestURL webView:self.webView];
    self.jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.jsBridge setWebViewDelegate:self];
    self.bridgeManager = [[WVJBManager alloc] initWithJSBridge:self.jsBridge];
    self.bridgeManager.delegate = self;
    
    // 监听属性值变化
    RAC(self.navigationBar, statusColor) = RACObserve(self.bridgeManager, navigationBgColor);
    RAC(self.navigationBar, titleColor) = RACObserve(self.bridgeManager, navigationFgColor);
    RAC(self.bridgeManager, isShareButtonDisplay) = RACObserve(self, supportShare);
    RAC(self.navigationBar, isShowMoreButton) = RACObserve(self.bridgeManager, isShareButtonDisplay);
    RAC(self.navigationBar, isShowAuthorizeButton) = RACObserve(self.bridgeManager, isAuthorizeButtonDisplay);
    RAC(self, navigationVisible) = RACObserve(self.bridgeManager, navigationVisible);
    
    // 更新与前端交互的JB脚本
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WVJBUtils updateNativeJS];
    });
    // 页面加载失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWebView) name:WEBLoadFail object:nil];
    
    @weakify(self);
    [[self.navigationBar.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (![self.businessAdapter respondsToSelector:@selector(shareH5WithEvent:shareViewModel:)]) {
            HMLogW(discovery, @"没有配置分享能力.");
            return ;
        }
        [self.businessAdapter shareH5WithEvent:NO shareViewModel:self.shareViewModel];
    }];
    
    [[self.navigationBar.authorizeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.authorizeUrlString) {
            self.requestURL = self.authorizeUrlString;
        } else {
            self.requestURL = [NSString stringWithFormat:@"%@&cancel_auth=true", self.authorizeUrlString];
        }
        [self loadWebView];
    }];
    
    [[self.navigationBar.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self closeWebVCByJSBridge:NO];
    }];
    
    [self.navigationBar.backButton.rac_command.executionSignals.switchToLatest subscribeNext:^(NSDictionary *actionDict) {
        @strongify(self);
        if (!actionDict) {
            return ;
        }
        NSString *key = actionDict[@"key"];
        NSString *urlString = actionDict[@"url"];
        if ([key isEqualToString:@"exit"]) {
            [self closeWebVCByJSBridge:YES];
        } else if ([key isEqualToString:@"reload"]) {
            [self loadWebView];
        } else if ([key isEqualToString:@"custom"]) {
            self.requestURL = urlString;
            [self loadWebView];
        } else {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
                self.navigationBar.isShowCloseButton = YES;
            } else {
                [self closeWebVCByJSBridge:NO];
            }
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setupSubViews {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar = [[HMWebNavigationBar alloc] init];
    self.navigationBar.isShowCloseButton = NO;
    self.promptView = [[HMWebPromptView alloc] initWithLocalize:self.businessAdapter];
    self.promptView.hidden = YES;
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.hidden = YES;
    self.progressView.tintColor = [UIColor colorWithRGB:65 Green:145 Blue:225];
    
    // JS预加载
    WKUserContentController* userContentController = WKUserContentController.new;
    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    webViewConfig.userContentController = userContentController;
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:[self cookieJavaScriptString] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:cookieScript];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfig];
    _webView.allowsBackForwardNavigationGestures = self.supportNavigationGestures;
    if (@available(iOS 9.0, *)) {
        _webView.customUserAgent = self.customUserAgent;
    }
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.promptView];
    
    [self layoutSubViews];
}

- (void)layoutSubViews {
    CGFloat navigationH = [UIDevice isPhoneXDevice] ? 88.0f : 64.0f;
    CGFloat updateHeight = self.isHideNavigation ? 0 : navigationH;
    self.navigationBar.hidden = self.isHideNavigation;
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(updateHeight);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(0);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.height.mas_equalTo(@2);
    }];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
}

#pragma mark - public funcs
- (void)reloadWebViewWithRequestURL:(NSString *)resquestURL {
    self.hasFinishLoad = NO;
    if (!resquestURL ||
        [resquestURL isEqualToString:self.requestURL] ||
        [resquestURL isEqualToString:@""]) {
        [self.webView reload];
    } else {
        self.requestURL = resquestURL;
        [self loadWebView];
    }
}

- (void)setScrollDelegate:(id <UIScrollViewDelegate>)delegate {
    self.webView.scrollView.delegate = delegate;
}

- (void)scrollsToTop:(BOOL)scrollToTop {
    self.webView.scrollView.scrollsToTop = scrollToTop;
}

- (CGPoint)scrollContentOffset {
    return self.webView.scrollView.contentOffset;
}

- (void)cleanWKWebViewCache {
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            HMLogD(discovery, @"clean All WKWebView Cache.");
        }];
    } else {
        // 清除缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
        // 清除磁盘
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        // 一个弊端，无法清除静态资源
        HMLogD(discovery, @"clean All WebView Cache iOS8.x");
    }
}

#pragma mark - private funcs
- (void)setNavigationVisible:(BOOL)navigationVisible {
    // 外部的隐藏导航栏优先级最高
    if (!self.isHideNavigation) {
        _navigationVisible = navigationVisible;
        CGFloat navHeight = [UIDevice isPhoneXDevice] ? 88.0f : 64.0f;
        CGFloat updateNavHeight = navigationVisible ? navHeight : (navHeight - 44.0f);
        [self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(updateNavHeight);
        }];
        self.navigationBar.navigationVisible = navigationVisible;
    }
}

- (NSMutableURLRequest *)webRequestWithURL:(NSString *)requestURL {
    NSURL *url = [NSURL URLWithString:requestURL];
    NSString *cookieStr = [self cookieStringWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    [request setValue:[WVJBUtils getAppLaunguage] forHTTPHeaderField:@"Accept-Language"];
    return request;
}

- (void)loadWebView {
    BOOL netAccess = [WVNetworkReachability sharedInstance].networkAccessEnable;
    if (!netAccess) {
        [self.promptView showPromptWithType:PromptTypeNoNetworkAccess];
        return;
    }
    
    BOOL netReachbility = [WVNetworkReachability sharedInstance].reachable;
    if (!netReachbility) {
        [self.promptView showPromptWithType:PromptTypeNoNetwork];
        return;
    }
    
    // 防止WKWebView缓存影响页面及时更新
    NSDate *lastDidLoadTime = [[NSUserDefaults standardUserDefaults] objectForKey:WEB_DIDLOADTIME];
    if (lastDidLoadTime && [lastDidLoadTime secondsBeforeDate:[NSDate date]] > 2 * 60 * 60) {
        [self cleanWKWebViewCache];
    }
    [self.promptView hidden];
    self.progressView.hidden = NO;
    self.hasFinishLoad = NO;
    [self.webView loadRequest:[self webRequestWithURL:self.requestURL]];
}

/** 检测相关电商app */
- (BOOL)canOpenEBApp:(NSString *)requestStr {
    return [requestStr hasPrefix:@"tmall://"]
    || [requestStr hasPrefix:@"taobao://"]
    || [requestStr hasPrefix:@"openapp.jdmobile://"]
    || [requestStr hasPrefix:@"suning://"]
    || [requestStr hasPrefix:@"youpin://"];//米家有品
}

/** 直接打开App Store详情页面 */
- (void)openAppWithIdentifier:(NSString*)appId {
    SKStoreProductViewController*storeProductVC =  [[SKStoreProductViewController alloc] init];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    storeProductVC.delegate = self;
    [self presentViewController:storeProductVC animated:YES completion:^{
        [storeProductVC loadProductWithParameters:dict completionBlock:nil];
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeWebVCByJSBridge:(BOOL)isJsBridgeWay {
    // 不是触发JSBridge退出webVC情况下
    if (self.updateUserInfo && !isJsBridgeWay) {
        //fetch User Info for GDPR.
        self.updateUserInfo();
    }
    if (self.needPresentDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configHtmlBraceletWithURL:(NSString *)requestURL {
    self.braceletManager = [[WVBTManager alloc] init];
    self.braceletManager.delegate = self;
    if ([requestURL rangeOfString:@"url="].location != NSNotFound) {
        [self.braceletManager setHtmlBraceletTypeWithRequestString:requestURL];
    } else {
        [self.braceletManager setHtmlBraceletTypeWithRequestString:[requestURL stringByRemovingPercentEncoding]];
    }
}

- (void)wechatPayNotificationBack:(NSNotification *)payNotific {
    if (![payNotific.object isKindOfClass:[NSNumber class]]) {
        return;
    }
    if (!self.wechatPayEventCallBack) {
        return;
    }
    int errorCode = [payNotific.object intValue];
    if (errorCode == 0) {
        [WVJBUtils JBSuccessCallBack:self.wechatPayEventCallBack];
    } else {
        NSDictionary *wechatErrorMsg = @{ @"errorCode": [NSString stringWithFormat:@"%@", @(errorCode)],
                            @"errorMessage" : @"微信支付失败." };
        [WVJBUtils JBErrorWithMsg:wechatErrorMsg callBack:self.wechatPayEventCallBack];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
                self.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKWebNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *requestString = navigationAction.request.URL.absoluteString;
    HMLogD(discovery,@"WebView Url:%@",requestString);
    
    if ([requestString hasPrefix:@"bracelet://"]) {
        [self configHtmlBraceletWithURL:requestString];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([requestString containsString:@"itunes.apple.com"] || [requestString hasPrefix:@"itms-apps"]) {
        NSString *appId = [[NSURL URLWithString:requestString].lastPathComponent substringFromIndex:2];
        [self openAppWithIdentifier:appId];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([requestString hasPrefix:@"alipay://"] ||
               [requestString hasPrefix:@"weixin://"] ||
               [requestString hasPrefix:@"alipays://"] ||
               [self canOpenEBApp:requestString]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSURL *requestURL = [NSURL URLWithString:requestString];
        if ([[UIApplication sharedApplication] canOpenURL:requestURL]) {
            [[UIApplication sharedApplication] openURL:requestURL];
        }
        return;
    } else if ([navigationAction.request.URL.scheme isEqualToString:@"tel"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        NSString * mutStr = [NSString stringWithFormat:@"telprompt://%@",navigationAction.request.URL.resourceSpecifier];
        NSURL *URL = [NSURL URLWithString:mutStr];
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL];
        }
        return;
    }
    
    if (self.isInMIDongTimeLine && ![requestString containsString:@"x-running-circle"]) {
        self.navigationVisible = YES;
    }
    
    
    if ([requestString rangeOfString:@"huami.health.authorization"].location != NSNotFound) {
        self.authorizeUrlString = requestString;
    }
    
    if (self.hasFinishLoad && self.navigationController.viewControllers.count == 0) {
        if ([self.routeDelegate respondsToSelector:@selector(shouldPushWebViewControllerWithUrlString:)]) {
            [self.routeDelegate shouldPushWebViewControllerWithUrlString:requestString];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView.isLoading) {
        return;
    }
    if ([self.businessAdapter respondsToSelector:@selector(webLoadEvent:)]) {
        [self.businessAdapter webLoadEvent:@"Success"];
    }
    self.hasFinishLoad = YES;
    [self.promptView hidden];
    self.navigationBar.titleLabel.text = self.titleText ? self.titleText : webView.title;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:WEB_DIDLOADTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [webView evaluateJavaScript:[WVJBUtils JSFileContentFromNative] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        [self.bridgeManager registerJSApiWithURL:webView.URL.absoluteString isNeedAuth:self.isJSBridgeNeedAuth];
    }];
    
    if (self.disableWebAlert) {
        // 禁止长按弹窗，UIActionSheet样式弹窗
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
        // 禁止长按弹窗，UIMenuController样式弹窗（效果不佳）
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([self.businessAdapter respondsToSelector:@selector(webLoadEvent:)]) {
        [self.businessAdapter webLoadEvent:@"LoadFail"];
    }
    HMLogD(discovery,@"网页加载失败: %@",error);
    
    if (error.code == NSURLErrorCancelled){
        /// -999 上一页面还没加载完，就加载当下一页面，就会报这个错。
        return;
    } else {
        self.progressView.hidden = YES;
        [self.promptView showPromptWithType:PromptTypeLoadFail];
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    HMLogD(discovery,@"webViewWebContentProcessDidTerminate, URL: %@",webView.URL.absoluteString);
    [webView reload];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    HMLogD(discovery,@"createWebViewWithConfiguration  request %@",navigationAction.request);
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(); }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:defaultText message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - JSBridge Delegate
- (void)exitWebView {
    [self.webView stopLoading];
    self.webView.navigationDelegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationToPage:(NSDictionary *)pageConfig {
    if (![self.businessAdapter respondsToSelector:@selector(navigationToPosition:navigationVC:)]) {
        HMLogW(discovery, @"没有配置进入指定界面的能力");
        return;
    }
    NSString *fallbackEvent = pageConfig[@"fallbackEvent"];
    NSString *position = pageConfig[@"position"];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count == 0) {
        if ([self.routeDelegate respondsToSelector:@selector(shouldNavigationToPosition:)]) {
            [self.routeDelegate shouldNavigationToPosition:position];
        }
    } else {
        if (![self.businessAdapter respondsToSelector:@selector(navigationToPosition:navigationVC:)]) {
            HMLogW(discovery, @"没有配置进入指定控制器能力, position: %@",position);
            return ;
        }
        [self.businessAdapter navigationToPosition:position navigationVC:self.navigationController];
    }
    
    if ([position isEqualToString:@"login"] && [self.businessAdapter respondsToSelector:@selector(loginMutexWithType:)]) {
        [self.businessAdapter loginMutexWithType:Login];
    }
    
    if ([fallbackEvent isEqualToString:@"exit"]) {
        [self closeWebVCByJSBridge:YES];
    } else if ([fallbackEvent isEqualToString:@"refresh"]) {
        [self loadWebView];
    }
}

- (void)shareWithDict:(NSDictionary *)shareInfo isH5Share:(BOOL)isH5Share {
    if (![self.businessAdapter respondsToSelector:@selector(shareH5WithEvent:shareViewModel:)]) {
        HMLogW(discovery, @"没有配置分享能力");
        return;
    }
    [self.shareViewModel configSharePlatform:shareInfo isJBShare:YES isShareLink:self.shareLink currentURL:self.requestURL webView:self.webView];
    if (isH5Share) {
        [self.businessAdapter shareH5WithEvent:YES shareViewModel:self.shareViewModel];
    }
}

- (void)syncWatchSkinWithConfig:(NSDictionary *)config callBack:(WVJBResponseCallback)callBack {
    if (![self.businessAdapter respondsToSelector:@selector(syncWatchSurface:callBack:)]) {
        HMLogW(discovery, @"没有配置同步表盘能力.");
        return ;
    }
    [self.businessAdapter syncWatchSurface:config callBack:callBack];
}

- (void)writeDeviceNoticeInfo:(NSDictionary *)deviceNotice callBack:(WVJBResponseCallback)callBack {
    if (![self.businessAdapter respondsToSelector:@selector(writeDeviceNotice:callBack:)]) {
        HMLogW(discovery, @"没有配置写入设备通知提醒能力.");
        return ;
    }
    [self.businessAdapter writeDeviceNotice:deviceNotice callBack:callBack];
}

- (void)wechatPay:(NSDictionary *)payOrder callBack:(WVJBResponseCallback)callBack {
    if (![self.businessAdapter respondsToSelector:@selector(wechatPayWithOrder:)]) {
        HMLogW(discovery, @"没有配置微信支付的能力");
        return;
    }
    // 监听页面内wechat支付.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayNotificationBack:) name:JBWechatPay object:nil];
    self.wechatPayEventCallBack = callBack;
    [self.businessAdapter wechatPayWithOrder:payOrder];
}

- (void)fetchMifitInfo:(JBContentType)contentType callBack:(WVJBResponseCallback)callBack {
    if (![self.businessAdapter respondsToSelector:@selector(fetchMifitInfo:callBack:)]) {
        HMLogW(discovery, @"没有配置获取信息能力");
        return;
    }
    [self.businessAdapter fetchMifitInfo:contentType callBack:callBack];
}

#pragma mark - WVBTManagerDelegate
- (void)braceletManagerDict:(NSDictionary *)braceletDict braceletType:(HMHtmlBraceletType)braceletType
{
    if (braceletType == HMHtmlBracelet_None || braceletDict == nil || [braceletDict allKeys] == 0) {
        return;
    }
    
    switch (braceletType) {
        case HMHtmlBracelet_Bind:
            [self requestAuthorizedWithBraceletDict:braceletDict];
            break;
        case HMHtmlBracelet_Relogin:
            [self reloginWithBraceletDict:braceletDict];
            break;
        case HMHtmlBracelet_Login: {
            if ([self.businessAdapter respondsToSelector:@selector(loginMutexWithType:)]) {
                [self.businessAdapter loginMutexWithType:Login];
            }
        }
            break;
        case HMHtmlBracelet_InvalidLogin:
            [self invalidLoginWithBraceletDict:braceletDict];
            break;
        case HMHtmlBracelet_Share:
            [self configureShareDictWithBraceletDict:braceletDict isH5Share:YES];
            break;
        case HMHtmlBracelet_ExitHtmlWebView:
            [self closeWebVCByJSBridge:YES];
            break;
        case HMHtmlBracelet_ShareButton:
            [self configureShareDictWithBraceletDict:braceletDict isH5Share:NO];
            break;
        case HMHtmlBracelet_SetTitleContent: {
            NSString *content = braceletDict[@"content"];
            self.navigationBar.titleLabel.text = content;
        }
            break;
        case HMHtmlBracelet_SetNavigationBgColor: {
            NSString *color = braceletDict[@"color"];
            NSString *opacity = braceletDict[@"opacity"];
            CGFloat alpha = opacity ? [opacity integerValue]/10.0 : 1;
            self.navigationBar.statusColor = [UIColor colorWithHEXString:color Alpha:alpha];
        }
            break;
        case HMHtmlBracelet_SetStatusBarColor: {
            NSString *color = braceletDict[@"color"];
            NSString *opacity = braceletDict[@"opacity"];
            CGFloat alpha = opacity ? [opacity integerValue]/10.0 : 1;
            self.navigationBar.statusColor = [UIColor colorWithHEXString:color Alpha:alpha];
        }
            break;
        case HMHtmlBracelet_SetBackButtonAction: {
            if ([braceletDict.allValues count] == 0) {
                break;
            }
            if ([braceletDict[@"url"] isKindOfClass:[NSString class]]) {
                NSString *urlString = braceletDict[@"url"];
                NSString *backButtonActionUrlString = [urlString stringByRemovingPercentEncoding];
                self.navigationBar.backButtonActionUrl = backButtonActionUrlString;
                self.navigationBar.backButtonActionKey = @"custom";
            } else {
                self.navigationBar.backButtonActionUrl = @"";
                NSString *backButtonActionKey = braceletDict[@"back_key"];
                self.navigationBar.backButtonActionKey = !backButtonActionKey ? @"history" : backButtonActionKey;
            }
        }
            break;
        case HMHtmlBracelet_Action: {
            if (![self.businessAdapter respondsToSelector:@selector(navigationToPosition:navigationVC:)]) {
                HMLogW(discovery, @"没有配置进入指定控制器能力.");
                return ;
            }
            [self.businessAdapter navigationToPosition:braceletDict[@"name"] navigationVC:self.navigationController];
            NSString *functionName = braceletDict[@"callback"];
            if (functionName) {
                [self.webView evaluateJavaScript:functionName completionHandler:nil];
            }
        }
            break;
        case HMHtmlBracelet_SetNavigationVisible: {
            NSString *visible = braceletDict[@"visible"];
            self.navigationBar.navigationVisible = visible;
        }
            break;
        case HMHtmlBracelet_CheckAppInstalled: {
            NSString *value = braceletDict[@"package"];
            if (value.length > 0) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", value]];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                [self.webView evaluateJavaScript:[NSString stringWithFormat:@"onCheckAppInstalled('%@','%d');", value, canOpen] completionHandler:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)invalidLoginWithBraceletDict:(NSDictionary *)braceletDict {
    NSString *jsonStr = [braceletDict objectForKey:@"response"];
    if (![jsonStr isKindOfClass:[NSString class]]) {
        return;
    }
    NSData * data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return;
    }
    NSError * error = nil;
    NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (![ret isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSInteger errorCode = [[ret objectForKey:@"code"] integerValue];
    if (errorCode == 0 && [self.businessAdapter respondsToSelector:@selector(loginMutexWithType:)]) {
        [self.businessAdapter loginMutexWithType:Login];
    }
    else if (errorCode == -1) {
        NSDictionary *dataDict = [ret objectForKey:@"data"];
        [self reloginWithBraceletDict:dataDict];
    }
}

- (void)reloginWithBraceletDict:(NSDictionary *)dict {
    if (!dict || [dict.allKeys count] == 0) {
        return;
    }
    NSNumber *loginTime = [dict objectForKey:@"login_time"];
    if (![self.businessAdapter respondsToSelector:@selector(loginMutexWithType:)]) {
        return;
    }
    if (loginTime) {
        [self.businessAdapter loginMutexWithType:Login];
        return;
    }
    [self.businessAdapter loginMutexWithType:QuitLogin];
}

- (void)requestAuthorizedWithBraceletDict:(NSDictionary *)braceletDict {
    NSString *valueStr = [braceletDict objectForKey:@"appid"];
    if ([valueStr length] == 0) {
        return;
    }
    
     [[HMServiceAPI defaultService] thirdPartyAuthorize_authorizeWithThirdPartyAppID:valueStr completionBlock:^(BOOL success, NSString *message, NSString *redirectURL) {
         if (success) {
             self.requestURL = redirectURL;
             [self loadWebView];
         }else{
             HMLogE(discovery, @"三方授权失败:%@",message);
         }
     }];
}

- (void)configureShareDictWithBraceletDict:(NSDictionary *)braceletDict isH5Share:(BOOL)isH5Share {
    NSString *encodedString = braceletDict[@"data"];
    if (![encodedString isKindOfClass:[NSString class]]) {
        return;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!data) {
        return;
    }
    NSDictionary *decodedDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *allPlatformsShareDict = DICT_ATTRIBUTE_FOR_KEY(decodedDict, @"share");
    [self.shareViewModel configSharePlatform:allPlatformsShareDict isJBShare:YES isShareLink:self.shareLink currentURL:self.requestURL webView:self.webView];
    if (isH5Share && [self.businessAdapter respondsToSelector:@selector(shareH5WithEvent:shareViewModel:)]) {
        [self.businessAdapter shareH5WithEvent:YES shareViewModel:self.shareViewModel];
    } else {
        self.navigationBar.isShowMoreButton = YES;
    }
}

#pragma mark - Getter
- (NSString *)cookieStringWithURL:(NSURL *)url {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    cookieJar.cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    NSMutableArray *cookies = [NSMutableArray array];
    for (NSHTTPCookie *cookie in cookieJar.cookies) {
        if ([url.host isEqualToString:cookie.domain] && [url.path isEqualToString:cookie.path]) {
            [cookies addObject:cookie];
        }
    }
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    return [headers objectForKey:@"Cookie"];
}

- (NSString *)cookieJavaScriptString {
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    cookieStorage.cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"document.cookie='%@=%@';", cookie.name, cookie.value];
        [cookieString appendString:excuteJSString];
    }
    //执行js
    return cookieString;
}
@end
