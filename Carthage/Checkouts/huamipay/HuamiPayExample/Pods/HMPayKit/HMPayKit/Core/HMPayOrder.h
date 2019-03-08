//  HMPayOrder.h
//  Created on 2018/3/14
//  Description 订单信息协议

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>

@protocol HMPayOrder <NSObject>

#pragma mark - 微信支付订单参数
/** 微信开放平台审核通过的应用APPID*/
@property (nonatomic, readonly) NSString  *wx_PayAppId;
/** 微信支付分配的商户号 */
@property (nonatomic, readonly) NSString  *wx_partnerId;
/** 微信返回的支付交易会话ID */
@property (nonatomic, readonly) NSString  *wx_prepayId;
/** 随机串，防重发 */
@property (nonatomic, readonly) NSString  *wx_nonceStr;
/** 时间戳，防重发 */
@property (nonatomic, readonly) NSString  *wx_timeStamp;
/** 扩展字段,暂填写固定值Sign=WXPay */
@property (nonatomic, readonly) NSString  *wx_package;
/** 签名 */
@property (nonatomic, readonly) NSString  *wx_sign;


#pragma mark - 支付宝订单参数
/** app URLScheme */
@property (nonatomic, readonly) NSString  *ali_urlScheme;
/** 订单签名字符串 */
@property (nonatomic, readonly) NSString  *ali_signChargeStr;

@end
