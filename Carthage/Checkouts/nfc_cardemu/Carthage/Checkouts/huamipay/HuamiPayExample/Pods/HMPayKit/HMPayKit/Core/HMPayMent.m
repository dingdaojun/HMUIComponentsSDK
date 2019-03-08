//  HMBasePay.m
//  Created on 2018/3/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMPayMent.h"

NSString * const kPaySuccessMessage = @"订单支付成功";
NSString * const kPayFailureMessage = @"订单支付失败";
NSString * const kPayCancelMessage = @"用户中途取消";
NSString * const kPayAuthFailMessage = @"授权失败";

const NSInteger  kPayAppNotInstall = 100;
const NSInteger  kPayNotSupport = 400;
const NSInteger  kPayErrorCode = 200;

@implementation HMPayMent

- (void)jumpToPay:(id<HMPayOrder>)order callBack:(HMPayResultHandler)handler {
    
}

- (BOOL)isAppInstalled {
    return YES;
}

- (BOOL)handlerOpenUrl:(NSURL *)openUrl {
    return YES;
}

- (BOOL)registerApp:(NSString *)appId {
    return YES;
}
@end
