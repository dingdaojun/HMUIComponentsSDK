//  HMAliPayAuth.h
//  Created on 2018/3/16
//  Description aliPay授权

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)
//  流程: https://docs.open.alipay.com/218/105325

#import <Foundation/Foundation.h>

@interface HMAliPayAuth : NSObject

/**
 aliPay V2版本授权

 @param authInfo 授权信息
 @param scheme scheme
 @param completion 回调handler
 */
+ (void)authV2WithInfo:(NSString *)authInfo fromScheme:(NSString *)scheme handler:(void (^)(NSDictionary *resultDic))completion;

/**
 V2授权回调处理

 @param openUrl URL
 */
+ (void)handlerAuthUrl:(NSURL *)openUrl;

@end
