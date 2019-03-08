//  HMAliPayAuth.m
//  Created on 2018/3/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMAliPayAuth.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation HMAliPayAuth

+ (void)authV2WithInfo:(NSString *)authInfo fromScheme:(NSString *)scheme handler:(void (^)(NSDictionary *resultDic))completion {
    [[AlipaySDK defaultService] auth_V2WithInfo:authInfo fromScheme:scheme callback:completion];
}

+ (void)handlerAuthUrl:(NSURL *)openUrl {
    if ([openUrl.host isEqualToString:@"safepay"]) {
        // v2版本快登授权返回
        [[AlipaySDK defaultService] processAuth_V2Result:openUrl standbyCallback:^(NSDictionary *resultDic) {
#ifdef DEBUG
            NSLog(@"aliPay processAuth_V2Result = %@", resultDic);
#endif
        }];
    }
}

@end
