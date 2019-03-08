//  HMPay.m
//  Created on 2018/3/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMPay.h"
#import "HMAliPay.h"
#import "HMWxPay.h"

@interface HMPay ()

@property (strong, nonatomic) HMPayMent *payment;

@end

@implementation HMPay

+ (instancetype)defaultPay {
    static dispatch_once_t onceToken;
    static HMPay *instance;
    dispatch_once(&onceToken, ^{
        instance = [[HMPay alloc] init];
    });
    return instance;
}
/**
 *  支付调用接口(支付宝/微信)
 *  说明：微信支付 success：YES,去后端验证，否则提示用户支付失败信息
 *  注意：不能success=YES，作为用户支付成功的结果，应以服务器端的接收的支付通知或查询API返回的结果为准
 */
- (void)pay:(HMPayType)payType order:(id<HMPayOrder>)order payHandler:(HMPayResultHandler)handler {
    self.payment = [[HMPay defaultPay] payment:payType];
    [self.payment jumpToPay:order callBack:handler];
}

- (BOOL)handlerOpenURL:(NSURL *)URL {
    return [self.payment handlerOpenUrl:URL];
}

- (HMPayMent *)payment:(HMPayType)payType {
    switch (payType) {
        case HMPayTypeAliPay:
            return [[HMAliPay alloc] init];
        case HMPayTypeWxPay:
            return [[HMWxPay alloc] init];
        default:
            return nil;
    }
}
@end
