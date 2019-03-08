//  HMAliPayResult.m
//  Created on 2018/3/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMAliPayResult.h"

@implementation HMAliPayResult

- (instancetype)initWithPayDict:(NSDictionary *)payResultDict {
    self = [super init];
    if (self) {
        self.result = [payResultDict objectForKey:@"result"];
        self.memo = [payResultDict objectForKey:@"memo"];
        self.resultStatus = [[payResultDict objectForKey:@"resultStatus"] integerValue];
    }
    return self;
}

- (void)setResult:(NSString *)result {
    _result = result;
    
    NSData *JSONData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    self.resultItem = [[HMAliPayResultItem alloc] init];
    [self.resultItem setValuesForKeysWithDictionary:resultDic];
    NSDictionary *payResponeDic = self.resultItem.alipay_trade_app_pay_response;
    self.payRespone = [[HMAliPayRespone alloc] initWithPayDict:payResponeDic];
}

@end

@implementation HMAliPayRespone
/*{
    "app_id" = 2015052200084920;
    "auth_app_id" = 2015052200084920;
    charset = "utf-8";
    code = 10000;
    msg = Success;
    "out_trade_no" = 00287311551012018032111544575061;
    "seller_id" = 2088311705309955;
    timestamp = "2018-03-21 11:55:37";
    "total_amount" = "0.01";
    "trade_no" = 2018032121001004410577752410;
} */

- (instancetype)initWithPayDict:(NSDictionary *)payDict {
    self = [super init];
    if (self) {
        self.app_id = [payDict objectForKey:@"app_id"];
        self.charset = [payDict objectForKey:@"charset"];
        self.code = [[payDict objectForKey:@"code"] integerValue];
        self.msg = [payDict objectForKey:@"msg"];
        self.out_trade_no = [payDict objectForKey:@"out_trade_no"];
        self.seller_id = [payDict objectForKey:@"seller_id"];
        self.timestamp = [payDict objectForKey:@"timestamp"];
        self.total_amount = [payDict objectForKey:@"total_amount"];
        self.trade_no = [payDict objectForKey:@"trade_no"];
        self.sub_msg = [payDict objectForKey:@"sub_msg"];
        self.sub_code = [[payDict objectForKey:@"sub_code"] integerValue];
    }
    return self;
}

@end

@implementation HMAliPayResultItem

@end
