//  HMAliPay.m
//  Created on 2018/3/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMAliPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HMAliPayResult.h"

@implementation HMAliPay

- (void)jumpToPay:(id<HMPayOrder>)order callBack:(HMPayResultHandler)handler {
    if (!handler) {
        return;
    }
    self.payResultHandler = handler;
    NSAssert((order.ali_urlScheme || [order.ali_urlScheme isEqualToString:@""]), @"支付宝必须配置app的URLScheme");
    [[AlipaySDK defaultService] payOrder:order.ali_signChargeStr fromScheme:order.ali_urlScheme callback:^(NSDictionary *resultDic) {
        [self parseResult:resultDic];
    }];
}

- (BOOL)handlerOpenUrl:(NSURL *)openUrl {
    if ([openUrl.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:openUrl standbyCallback:^(NSDictionary *resultDic) {
#ifdef DEBUG
            NSLog(@"aliPay result = %@", [HMAliPay returnErrorMessage:[[resultDic objectForKey:@"resultStatus"] integerValue]]);
#endif
            [self parseResult:resultDic];
        }];
    }
    //支付宝钱包快登授权返回authCode
    if ([openUrl.host isEqualToString:@"platformapi"]) {
        [[AlipaySDK defaultService] processAuthResult:openUrl standbyCallback:^(NSDictionary *resultDic) {
            [self parseResult:resultDic];
        }];
    }
    return YES;
}

- (void)parseResult:(NSDictionary *)resultDic {
#ifdef DEBUG
    NSLog(@"alipay handler reslut = %@", resultDic);
#endif
    if (!resultDic || ![resultDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    HMAliPayResult *payResult = [[HMAliPayResult alloc] initWithPayDict:resultDic];
    HMPayResultStatus status = HMPayResultStatusFailure;
    switch (payResult.resultStatus) {
        case 9000:
            status = HMPayResultStatusSuccess;
            break;
        case 8000:
            status = HMPayResultStatusProcessing;
            break;
        case 6001:
            status = HMPayResultStatusCancel;
            break;
        case 6002:
            status = HMPayResultStatusNetWorkFail;
            break;
        case 4000:
            status = HMPayResultStatusFailure;
            break;
        default:
            break;
    }
    
    NSString *message = [HMAliPay returnErrorMessage:payResult.resultStatus];
    if (status != HMPayResultStatusSuccess) {
#ifdef DEBUG
        NSLog(@"ali pay支付失败, status: %ld, message: %@",(long)status, message);
#endif
    }
    self.payResultHandler(status, resultDic, message);
}

+ (NSString *)returnErrorMessage:(NSInteger)status {
    NSDictionary *errorDic = [[self class] errrorMessage];
    NSString *message = errorDic[@(status)];
    if (!message) {
        message = @"未知错误";
    }
    return message;
}

+ (NSDictionary *)errrorMessage {
    return @{@9000: @"订单支付成功",
             @8000: @"正在处理中",
             @4000: @"订单支付失败",
             @6001: @"用户中途取消",
             @6002: @"网络连接出错"};
}

#pragma mark - 返回的数据结构
/*
{
    \"alipay_trade_app_pay_response\":{
    \"code\":\"10000\",
    \"msg\":\"Success\",
    \"app_id\":\"2014072300007148\",
    \"out_trade_no\":\"081622560194853\",
    \"trade_no\":\"2016081621001004400236957647\",
    \"total_amount\":\"0.01\",
    \"seller_id\":\"2088702849871851\",
    \"charset\":\"utf-8\",
    \"timestamp\":\"2016-10-11 17:43:36\"
},
\"sign\":\"NGfStJf3i3ooWBuCDIQSumOpaGBcQz+aoAqyGh3W6EqA/gmyPYwLJ2REFijY9XPTApI9YglZyMw+ZMhd3kb0mh4RAXMrb6mekX4Zu8Nf6geOwIa9kLOnw0IMCjxi4abDIfXhxrXyj********\",
\"sign_type\":\"RSA2\"
}
 
{
    "alipay_trade_app_pay_response":
    {
        "code":"40002",
        "msg":"Invalid Arguments",
        "sub_code":"isv.invalid-signature",
        "sub_msg":"验签出错，sign值与sign_type参数指定的签名类型不一致：sign_type参数值为RSA2，您实际用的签名类型可能是RSA"
    }
    
} */
@end
