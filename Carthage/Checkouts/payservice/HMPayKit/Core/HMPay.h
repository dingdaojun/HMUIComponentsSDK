//  HMPay.h
//  Created on 2018/3/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import "HMPayMent.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HMPayType) {
    HMPayTypeWxPay, // 微信支付
    HMPayTypeAliPay,// 支付宝支付
};

@interface HMPay : NSObject

+ (instancetype)defaultPay;

/**
 开始支付

 @param payType 支付方式
 @param order 订单
 @param handler payHandler
 */
- (void)pay:(HMPayType)payType order:(id<HMPayOrder>)order payHandler:(HMPayResultHandler)handler;

/**
 支付完成url回调处理

 @param URL openURL
 @return BOOL 操作状态
 */
- (BOOL)handlerOpenURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
