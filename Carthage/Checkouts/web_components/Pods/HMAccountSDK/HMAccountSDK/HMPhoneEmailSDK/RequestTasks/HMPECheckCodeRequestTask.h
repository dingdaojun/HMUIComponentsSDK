//
//  HMPECheckCodeRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2018/1/10.
//  Copyright © 2018年 LiLingang. All rights reserved.
//

#import "HMPEBaseRequestTask.h"

/**
 API-16
 短信验证码校验
 200: OK
 400: 错误的验证码
 */
@interface HMPECheckCodeRequestTask : HMPEBaseRequestTask

/**
 创建一个验证手机验证码的请求

 @param areaCode 手机区号
 @param phone 手机号
 @param codeType 验证码类型
 @param code 验证码
 @return HMPECheckCodeRequestTask 实例
 */
+ (nonnull HMPECheckCodeRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                      phone:(nonnull NSString *)phone
                                                   codeType:(nonnull HMPECodeType *)codeType
                                                       code:(nonnull NSString *)code;

@end
