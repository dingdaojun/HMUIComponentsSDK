//  HMWebViewController.h
//  Created on 2018/5/16
//  Description web控制器

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <UIKit/UIKit.h>
#import "WVJBBusinessProtocol.h"
#import "WVJBManager.h"

@protocol HMWebViewControllerRouteDelegate <NSObject>

- (void)shouldNavigationToPosition:(NSString *)position;
- (void)shouldPushWebViewControllerWithUrlString:(NSString *)urlString;

@end

@interface HMWebViewController : UIViewController
/** present方式展示*/
@property (nonatomic, assign) BOOL needPresentDismiss;
/** 请求的URL */
@property (nonatomic, strong) NSString *requestURL;
/** 导航栏标题 (默认显示web中获取的) */
@property (nonatomic, strong) NSString *titleText;
/** 是否支持分享 */
@property (nonatomic, assign) BOOL supportShare;
/** 是否分享链接 */
@property (nonatomic, assign) BOOL shareLink;
/** 使用JSBridgeAPI时是否需要授权*/
@property (nonatomic, assign) BOOL isJSBridgeNeedAuth;
/** 是否在米动圈*/
@property (nonatomic, assign) BOOL isInMIDongTimeLine;
/** 是否隐藏Web导航栏*/
@property (nonatomic, assign) BOOL isHideNavigation;
/** userAgent iOS9+新API设置 */
@property (nonatomic, copy)   NSString *customUserAgent;
/** 是否支持 NavigationGestures */
@property (nonatomic, assign) BOOL supportNavigationGestures;
/** 是否禁止网页弹窗 */
@property (nonatomic, assign) BOOL disableWebAlert;
/** 针对GDPR退出时获取UserInfo */
@property (nonatomic, copy) void (^updateUserInfo)(void);

@property (nonatomic, weak) id<HMWebViewControllerRouteDelegate> routeDelegate;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareSubTitle;
@property (nonatomic, copy) NSString *shareUrl;

- (instancetype)initWithWVJBBusinessAdapter:(id<WVJBBusinessProtocol>)businessAdapter;
- (void)reloadWebViewWithRequestURL:(NSString *)resquestURL;
- (void)setScrollDelegate:(id <UIScrollViewDelegate>)delegate;
- (void)scrollsToTop:(BOOL)scrollToTop;
- (CGPoint)scrollContentOffset;
/** 清除WKWebView缓存 */
- (void)cleanWKWebViewCache;

@end
