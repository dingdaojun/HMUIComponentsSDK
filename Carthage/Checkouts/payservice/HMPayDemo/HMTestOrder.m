//  HMTestOrder.m
//  Created on 2018/3/14
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMTestOrder.h"

@implementation HMTestOrder

//partid=1252885101
//prepayid=wx13142822763967015268227a2831867687
//noncestr=yghapqlcl9gnd6n48is1vzlitkjewflk
//timestamp=1523600902
//package=Sign=WXPay
//sign=2B884E8350A41EC4217408EA8FDBB825

#pragma mark - 微信支付订单参数
- (NSString *)wx_PayAppId {
    return @"wxd930ea5d5a258f4f";
}

- (NSString *)wx_partnerId {
    return @"1252885101";
}

- (NSString *)wx_prepayId {
    return @"wx13142822763967015268227a2831867687";
}

- (NSString *)wx_nonceStr {
    return @"yghapqlcl9gnd6n48is1vzlitkjewflk";
}

- (NSString *)wx_timeStamp {
    return @"1523600902";
}

- (NSString *)wx_package {
    return @"Sign=WXPay";
}

- (NSString *)wx_sign {
    return @"2B884E8350A41EC4217408EA8FDBB825";
}

#pragma mark - 支付宝订单参数
- (NSString *)ali_urlScheme {
    return @"HMPayKitExample";
}

- (NSString *)ali_signChargeStr {
    return @"app_id=2015052200084920&biz_content=%7B%22subject%22%3A%22%E5%90%88%E8%82%A5%E9%80%9A%E5%85%85%E5%80%BC%22%2C%22out_trade_no%22%3A%2262927441551022018052509271940131%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=utf-8&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Ftsmtest.snowballtech.com%2Fpaycenter%2Fpayment%2Fpaystatusnotify%2Falipay%2F50&sign_type=RSA&timestamp=2018-05-25%2009%3A27%3A19&version=1.0&sign=mrfAUSlqdv%2FGmJIbVuMvfM46UUfBcQpLqeboohepaC38%2FBeZry1%2F0Gcmlf6H45hn0QZYfLJRn79f%2FFstexLrskpGkyesdMQJpuOqCjgrds0801jxBJswNt8LBS2X0z%2BHCfay5MG2j2uIPjkAVckyBOkQvh96gSjBZBnxchDhupG9HgbaXeFS88sZ1pK%2Ba6kW4uPFIvY5DGZ6cY4bJaMdJ0mQFzQvob%2Fy5o%2BM%2FLvYHiVxdL9s5Np2X%2B1i7lZV428CUE8aRxJhEhvsCk6ye4MWjNegk4DCzDw53XT0gTG81aW6WCNAJNDMpWX%2B9wRvP1MD8UxB0leiXzpvsqbSwQSRjA%3D%3D";
}

@end
