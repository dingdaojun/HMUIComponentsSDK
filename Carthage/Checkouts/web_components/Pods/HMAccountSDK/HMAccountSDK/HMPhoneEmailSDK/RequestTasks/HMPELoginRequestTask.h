//
//  HMPELoginRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"
#import "HMPEAccessToken.h"

/**
 API-4
 登录接口 @see 303
 400 ("token" neither "access" nor "refresh", or missing/wrong Oauth id "sub" if unconfirmed multiple registrations)
 401 (wrong Email address / phone # / password)
 429 (Too Many attempts)
 500 (Internal Server Error such as storage or remote regions)
 */
@interface HMPELoginRequestTask : HMPEBaseRequestTask

/**
 创建一个手机号登录请求

 @param areaCode 手机区号
 @param phone 手机号
 @param region 国家地区编码
 @param password 密码
 @param tokes 获取token的形式  @see HMPETokenOptionsKey
 @return  @return HMPELoginRequestTask 实例
 */
+ (nonnull HMPELoginRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                  phone:(nonnull NSString *)phone
                                                 region:(nonnull NSString *)region
                                               password:(nonnull NSString *)password
                                                  tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes;

/**
 创建一个邮箱登录请求
 
 @param email 邮箱
 @param region 国家地区编码
 @param password 密码
 @param tokes 获取token的形式  @see HMPETokenOptionsKey
 @return HMPELoginRequestTask 实例
 */
+ (nonnull HMPELoginRequestTask *)emailTaskWithEmail:(nonnull NSString *)email
                                              region:(nonnull NSString *)region
                                            password:(nonnull NSString *)password
                                               tokes:(nonnull NSArray <HMPETokenOptionsKey> *)tokes;


@end
