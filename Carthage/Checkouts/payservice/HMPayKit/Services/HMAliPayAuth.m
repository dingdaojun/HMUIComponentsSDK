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

+ (void)handlerAuthUrl:(NSURL *)openUrl callBack:(CallBack)callBack{
    if ([openUrl.host isEqualToString:@"safepay"]) {
        // v2版本快登授权返回, 新版本callBack回调只在openURL方法中有值回调
        [[AlipaySDK defaultService] processAuth_V2Result:openUrl standbyCallback:callBack];
    }
}

@end
