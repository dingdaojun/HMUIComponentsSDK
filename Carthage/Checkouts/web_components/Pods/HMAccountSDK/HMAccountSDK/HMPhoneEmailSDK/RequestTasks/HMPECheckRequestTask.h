//
//  HMPECheckRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"


/**
 API-1
 检查账号状态是否可用
 
 200 (has already registered and confirmed)
 202 (registered already without confirmed)
 400 (wrong format of phone # or out of country)
 404 (not found, send code message)
 451 (complained / permanently bounced before)
 429 (Too Many Requests)
 500 (Internal Server Error such as storage or remote regions)
 */
@interface HMPECheckRequestTask : HMPEBaseRequestTask

/**
 创建一个检查手机号的请求

 @param areaCode 手机区号
 @param phone 手机号
 @param region 国家地区码
 @return HMPECheckRequestTask 实例
 */
+ (nonnull HMPECheckRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                  phone:(nonnull NSString *)phone
                                                 region:(nonnull NSString *)region;

/**
 创建一个检查邮件的请求
 
 @param email 邮箱
 @param region 国家地区码
 @return HMPECheckRequestTask 实例
 */
+ (nonnull HMPECheckRequestTask *)emailTaskWithEmail:(nonnull NSString *)email
                                              region:(nonnull NSString *)region;

@end
