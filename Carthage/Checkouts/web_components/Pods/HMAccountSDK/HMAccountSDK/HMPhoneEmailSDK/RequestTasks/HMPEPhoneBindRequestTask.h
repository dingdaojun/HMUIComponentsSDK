//
//  HMPEPhoneBindRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/9/13.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMPEBaseRequestTask.h"

/**
 绑定发送验证码接口
 200: 手机号已经绑定
     0: 发送成功
 400：
     9: 用户所选区域，暂不支持注册
     10: 手机号已经绑定
     11: 请求参数错误
     12: 请求过于频繁，稍后重试
     99: 内部服务出错，稍后重试
 */
@interface HMPEPhoneBindRequestTask : HMPEBaseRequestTask

/**
 创建一个手机号绑定的请求
 
 @param areaCode 手机区号
 @param phone 手机号
 @param region 国家地区码
 @return HMPEPhoneBindRequestTask 实例
 */
+ (nonnull HMPEPhoneBindRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                      phone:(nonnull NSString *)phone
                                                     region:(nonnull NSString *)region;

@end
