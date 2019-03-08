//
//  HMPEResetPasswordRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"


/**
 API-8
 重置密码接口
 202 - Accepted
 400 (Bad Request @see HMPERegisterStatusCode)
    4-Missing/invalid/expired security code for phone # registration
 404 (Not Found Email address / phone #, or missing/wrong Oauth id "sub" if unconfirmed multiple registrations)
 451 (complained / permanently bounced before)
 429 (Too Many Requests)
 500 (Internal Server Error such as storage or remote regions)
 */
@interface HMPEResetPasswordRequestTask : HMPEBaseRequestTask


/**
 创建一个重置手机账号密码请求

 @param areaCode 手机区号 eg +86
 @param phone 手机号
 @return HMPEResetPasswordRequestTask 实例
 */
+ (nonnull HMPEResetPasswordRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                          phone:(nonnull NSString *)phone;


/**
 创建一个重置邮箱账号密码请求

 @param email 邮箱
 @param captcha 图片验证码
 @return HMPEResetPasswordRequestTask 实例
 */
+ (nonnull HMPEResetPasswordRequestTask *)emailTaskWithEmal:(nonnull NSString *)email
                                                    captcha:(nullable NSString *)captcha;

@end
