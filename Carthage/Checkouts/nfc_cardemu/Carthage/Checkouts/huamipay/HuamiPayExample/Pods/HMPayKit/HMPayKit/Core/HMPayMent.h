//  HMBasePay.h
//  Created on 2018/3/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import "HMPayOrder.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kPaySuccessMessage;
extern NSString * const kPayFailureMessage;
extern NSString * const kPayCancelMessage;
extern NSString * const kPayAuthFailMessage;

extern NSInteger  const kPayAppNotInstall;
extern NSInteger  const kPayNotSupport;
extern NSInteger  const kPayErrorCode;

#define AliUrlSign @"alipay"
#define AliUrlPrefix  [NSString stringWithFormat:@"%@%@",AliUrlSign,@"://"]
#define AliUrlClient  [NSString stringWithFormat:@"%@%@",AliUrlSign,@"client/?"]

typedef NS_ENUM(NSInteger, HMPayResultStatus) {
    HMPayResultStatusSuccess,
    HMPayResultStatusFailure,
    HMPayResultStatusCancel,
    HMPayResultStatusProcessing, // 正在处理, only in aliPay
    HMPayResultStatusUnInstall,  // 微信必须检测, 支付宝可以网页支付
    HMPayResultStatusNetWorkFail,// 网络连接失败
};

typedef void(^HMPayResultHandler)(HMPayResultStatus status, NSDictionary * __nullable resultInfo, NSError * __nullable error);

@protocol HMPayMent <NSObject>

@required
/**
 跳转支付

 @param order 订单
 @param handler 操作回调
 */
- (void)jumpToPay:(id<HMPayOrder>)order callBack:(HMPayResultHandler)handler;

/**
 支付完成的url回调处理

 @param openUrl 回调的url
 */
- (BOOL)handlerOpenUrl:(NSURL *)openUrl;

@optional

/**
 微信支付必须注册appID

 @param appId 微信平台注册appId
 @return BOOL 执行状态
 */
- (BOOL)registerApp:(NSString *)appId;

- (BOOL)isAppInstalled;

@end

@interface HMPayMent : NSObject <HMPayMent>

@property (strong, nonatomic) NSString *appScheme;
@property (copy, nonatomic) HMPayResultHandler payResultHandler;

@end

NS_ASSUME_NONNULL_END
