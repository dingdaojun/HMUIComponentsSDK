//
//  HMPERegisterRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"
#import "HMPEAccessToken.h"

/**
 API-3
 注册接口 @see 303
 email
 202 Accepted
 Phone
 200 OK
 
 400 (Bad Request @see HMPERegisterStatusCode)
     1- Email address / phone # confirmed
     2-Invalid password if clear text, or invalid salt/hash or missing iterations
     3-Invalid name including blank
     4-Missing/invalid/expired security code for phone # registration
     5-Invalid region
     6-Email address / phone # bounced / permanently complained before
     9-prohibited area，can not be Register
 413 (Payload Too Large)
 429 (Too Many Requests, see Content-Type/Content-Language for captcha)
 500 (Internal Server Error such as storage or remote regions)

 */
@interface HMPERegisterRequestTask : HMPEBaseRequestTask

/**
 创建一个手机号注册请求

 @param areaCode 手机区号 eg +86
 @param phone 手机号
 @param region 国家地区码
 @param securityCode 手机验证码
 @param password 密码
 @param state 服务器状态HMPEStateOptionsKey
 @return HMPERegisterRequestTask实例
 */
+ (nonnull HMPERegisterRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                     phone:(nonnull NSString *)phone
                                                    region:(nonnull NSString *)region
                                              securityCode:(nonnull NSString *)securityCode
                                                  password:(nonnull NSString *)password
                                                     tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes;


/**
 创建一个邮箱注册请求

 @param email 邮箱
 @param region 国家地区码
 @param name 昵称
 @param password 密码
 @param tokes 获取token的形式  @see HMPETokenOptionsKey
 @param captcha 图片验证码
 @return HMPERegisterRequestTask实例
 */
+ (nonnull HMPERegisterRequestTask *)emialTaskWithEmail:(nonnull NSString *)email
                                                 region:(nonnull NSString *)region
                                                   name:(nonnull NSString *)name
                                               password:(nonnull NSString *)password
                                                  tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes
                                                captcha:(nullable NSString *)captcha;

@end
