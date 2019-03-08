//  HMAliPayResult.h
//  Created on 2018/3/15
//  Description 支付宝回调信息

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
@class HMAliPayResultItem, HMAliPayRespone;

@interface HMAliPayResult : NSObject

@property (strong, nonatomic) NSString *memo;

@property (strong, nonatomic) NSString *result;

@property (assign, nonatomic) NSInteger resultStatus;

// extra object item.
@property (strong, nonatomic) HMAliPayResultItem *resultItem;
@property (strong, nonatomic) HMAliPayRespone *payRespone;

- (instancetype)initWithPayDict:(NSDictionary *)payResultDict;
@end

#pragma mark - result item
@interface HMAliPayResultItem : NSObject

// 签名结果
@property (strong, nonatomic) NSString *sign;
// 签名类型
@property (strong, nonatomic) NSString *sign_type;
// pay respone
@property (strong, nonatomic) NSDictionary *alipay_trade_app_pay_response;

@end

#pragma mark - alipay_trade_app_pay_response
@interface HMAliPayRespone : NSObject

//商户网站唯一订单号
@property (strong, nonatomic) NSString *out_trade_no;
//该交易在支付宝系统中的交易流水号。最长64位
@property (strong, nonatomic) NSString *trade_no;
//支付宝分配给开发者的应用Id
@property (strong, nonatomic) NSString *app_id;
//该笔订单的资金总额
@property (strong, nonatomic) NSString *total_amount;
//收款支付宝账号对应的支付宝唯一用户号。以2088开头的纯16位数字
@property (strong, nonatomic) NSString *seller_id;
//处理结果的描述，信息来自于code返回结果的描述 eg. success
@property (strong, nonatomic) NSString *msg;
//编码格式
@property (strong, nonatomic) NSString *charset;
//时间
@property (strong, nonatomic) NSString *timestamp;
//结果码
@property (assign, nonatomic) NSInteger code;
//明细返回码
@property (assign, nonatomic) NSInteger sub_code;
//明细返回码描述
@property (strong, nonatomic) NSString *sub_msg;

- (instancetype)initWithPayDict:(NSDictionary *)payDict;

@end
