//  HMWxPay.m
//  Created on 2018/3/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWxPay.h"
#import "WXApi.h"

@interface HMWxPay () <WXApiDelegate>

@end

@implementation HMWxPay

- (BOOL)isAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

- (BOOL)registerApp:(NSString *)appId {
    return [WXApi registerApp:appId];
}

- (BOOL)handlerOpenUrl:(NSURL *)openUrl {
    NSString *urlString = [openUrl absoluteString];
    BOOL canHandler = [urlString rangeOfString:@"wx"].location != NSNotFound;
    if (canHandler && [urlString rangeOfString:@"pay"].location != NSNotFound) {
        return [WXApi handleOpenURL:openUrl delegate:self];
    }
    return NO;
}

/**
 *  微信支付
 *  success：YES,去后端验证，否则提示用户支付失败信息
 *  注意：不能success=YES，作为用户支付成功的结果，应以服务器端的接收的支付通知或查询API返回的结果为准
 */
- (void)jumpToPay:(id<HMPayOrder>)order callBack:(HMPayResultHandler)handler {
    if (!handler) {
        return;
    }
    if (![self isAppInstalled]) {
        handler(HMPayResultStatusUnInstall, nil, @"应用未安装");
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        handler(HMPayResultStatusCancel, nil, @"该版本微信不支持支付");
        return;
    }
    // register wxAppId.
    NSAssert((order.wx_PayAppId || [order.wx_PayAppId isEqualToString:@""]), @"微信支付下，appId不可以为空!");
    [self registerApp:order.wx_PayAppId];
    
    PayReq *req = [[PayReq alloc] init];
    req.openID = order.wx_PayAppId;
    req.partnerId = order.wx_partnerId;
    req.prepayId = order.wx_prepayId;
    req.nonceStr = order.wx_nonceStr;
    req.timeStamp = [order.wx_timeStamp intValue];
    req.package = order.wx_package;
    req.sign = order.wx_sign;
    [WXApi sendReq:req];
    
#ifdef DEBUG
    NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@", req.partnerId, req.prepayId, req.nonceStr, (long)req.timeStamp, req.package, req.sign);
#endif
    self.payResultHandler = handler;
}

#pragma mark - delegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        HMPayResultStatus payResultStatus = HMPayResultStatusFailure;
        switch (resp.errCode) {
            case WXSuccess:
                payResultStatus = HMPayResultStatusSuccess;
                break;
            case WXErrCodeCommon: {
                //可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
                payResultStatus = HMPayResultStatusFailure;
            }
                break;
            case WXErrCodeUserCancel: {
                payResultStatus = HMPayResultStatusCancel;
            }
            default:
                break;
        }
        
        NSDictionary *errorDic = [self errorMessage];
        NSString *errorStr = resp.errStr;
        if (!errorStr) {
            errorStr = errorDic[@(resp.errCode)];
        }
        if (payResultStatus != HMPayResultStatusSuccess) {
#ifdef DEBUG
            NSLog(@"微信支付失败, status: %d, message: %@",resp.errCode,errorStr);
#endif
        }
        self.payResultHandler(payResultStatus, errorDic, errorStr);
    }
}

- (NSDictionary *)errorMessage {
    return @{@(WXSuccess):              kPaySuccessMessage,
             @(WXErrCodeCommon):        kPayFailureMessage,
             @(WXErrCodeUserCancel):    kPayCancelMessage,
             @(WXErrCodeAuthDeny):      kPayAuthFailMessage
             };
}
@end
