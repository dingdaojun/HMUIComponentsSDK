//
//  HMPESendConfirmationRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/8/24.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMPEBaseRequestTask.h"

/**
 API-5
 发送确认邮件
 400: confirmed already, or not Email address such as phone
 404: wrong Email address / phone # or missing/wrong Oauth id "sub" for multiple registrations
 451: complained/permanently bounced before
 429: Too many requests
 500: Internal Server Error such as storage or remote regions
 */
@interface HMPESendConfirmationRequestTask : HMPEBaseRequestTask

/**
 创建一个发送确认邮件的请求
 
 @param email 邮箱
 @param region 国家地区码
 @return HMPESendConfirmationRequestTask 实例
 */
+ (nonnull HMPESendConfirmationRequestTask *)emailTaskWithEmail:(nonnull NSString *)email
                                                         region:(nonnull NSString *)region;

@end
