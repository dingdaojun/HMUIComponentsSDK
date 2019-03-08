//  WVJBManager.h
//  Created on 2018/5/16
//  Description webView JSBridge Manager.

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WVJBCommon.h"
#import "WKWebViewJavascriptBridge.h"

@protocol WVJBManagerDelegate <NSObject>

@optional
- (void)exitWebView;
- (void)navigationToPage:(NSDictionary *)pageConfig;
- (void)shareWithDict:(NSDictionary *)shareInfo isH5Share:(BOOL)isH5Share;
- (void)chooseImage:(NSDictionary *)imageConfig callBack:(WVJBResponseCallback)callBack;
- (void)syncWatchSkinWithConfig:(NSDictionary *)config callBack:(WVJBResponseCallback)callBack;
- (void)writeDeviceNoticeInfo:(NSDictionary *)deviceNotice callBack:(WVJBResponseCallback)callBack;
- (void)wechatPay:(NSDictionary *)payOrder callBack:(WVJBResponseCallback)callBack;
- (void)fetchMifitInfo:(JBContentType)contentType callBack:(WVJBResponseCallback)callBack;

@end

@interface WVJBManager : NSObject

@property (nonatomic, assign) BOOL navigationVisible;
@property (nonatomic, copy) NSString *authorizeUrlString;

@property (nonatomic, assign) BOOL isShareButtonDisplay;
@property (nonatomic, assign) BOOL isAuthorizeButtonDisplay;

@property (nonatomic, strong) UIColor *navigationBgColor;
@property (nonatomic, strong) UIColor *navigationFgColor;

@property (nonatomic, weak) id <WVJBManagerDelegate> delegate;

- (instancetype)initWithJSBridge:(WKWebViewJavascriptBridge *)JSBridge;

- (void)registerJSApiWithURL:(NSString *)URLString isNeedAuth:(BOOL)isNeedAuth;

@end
