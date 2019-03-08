//  WVJBUtils.h
//  Created on 2018/5/16
//  Description 数据处理

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WVJBCommon.h"
#import "WKWebViewJavascriptBridge.h"

//分享类型
extern NSString *const JSBridgeShareTypeCard;
extern NSString *const JSBridgeShareTypeImage;
extern NSString *const JSBridgeShareTypeText;
extern NSString *const JSBridgeShareTypeMix;

@interface WVJBUtils : NSObject

+ (NSString *)getAppLaunguage;

+ (NSString *)JSONWithDict:(NSDictionary *)dict;

+ (BOOL)isValidURL:(NSString *)url;

+ (void)JBSuccessCallBack:(WVJBResponseCallback)callBack;
+ (void)JBErrorWithCode:(JSErrorCode)errorCode callBack:(WVJBResponseCallback)callBack;
+ (void)JBErrorWithMsg:(NSDictionary *)errorMsg callBack:(WVJBResponseCallback)callBack;

+ (NSString *)JSFileContentFromNative;
+ (void)updateNativeJS;

@end
