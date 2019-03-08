#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HMPay.h"
#import "HMPayMent.h"
#import "HMPayOrder.h"
#import "AlipaySDK.h"
#import "APayAuthInfo.h"
#import "WechatAuthSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "HMAliPay.h"
#import "HMAliPayAuth.h"
#import "HMAliPayResult.h"
#import "HMWxPay.h"

FOUNDATION_EXPORT double HMPayKitVersionNumber;
FOUNDATION_EXPORT const unsigned char HMPayKitVersionString[];

