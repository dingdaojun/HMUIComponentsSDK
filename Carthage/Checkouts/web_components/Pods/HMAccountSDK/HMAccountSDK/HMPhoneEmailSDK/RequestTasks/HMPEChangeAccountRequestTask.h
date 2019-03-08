//
//  HMPEChangeAccountRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"


/**
 API-9
 修改用户账号
 202 OK
 400 (Bad Request of new Email address / phone # confirmed already or same as old, or missing/wrong phone security code for new phone #)
 401 (wrong old Email address / phone # / password, or missing/wrong Oauth id "sub" if unconfirmed multiple registrations)
 451 (new Email address / phone # complained / permanently bounced before)
 413 (Payload Too Large)
 429 (Too Many attempts, see Content-Type/Content-Language for captcha; or too many passwords)
 500 (Internal Server Error such as storage or remote regions)
 */
@interface HMPEChangeAccountRequestTask : HMPEBaseRequestTask

/**
 创建一个修改手机号的请求

 @param areaCode 当前手机区号 eg +86
 @param phone 当前手机号
 @param region 国家地区码
 @param newAreaCode 新的手机区号 eg +86
 @param newPhone 新手机号
 @param securityCode    手机验证码
 @param captcha 图片语音验证码
 @return HMPEChangeAccountRequestTask 实例
 */
+ (nonnull HMPEChangeAccountRequestTask *)phoneTaskWithAreaCode:(nullable NSString *)areaCode
                                                          phone:(nonnull NSString *)phone
                                                         region:(nonnull NSString *)region
                                                    newAreaCode:(nullable NSString *)newAreaCode
                                                       newPhone:(nonnull NSString *)newPhone
                                                   securityCode:(nonnull NSString *)securityCode
                                                        captcha:(nullable NSString *)captcha;


/**
 创建一个修改邮箱的请求

 @param email 当前的邮箱
 @param region 国家地区码
 @param newEmail 新的邮箱
 @param password 密码
 @param securityCode  邮箱验证码
 @param captcha 图片语音验证码
 @return HMPEChangeAccountRequestTask 实例
 */
+ (nonnull HMPEChangeAccountRequestTask *)emialTaskWithEmail:(nonnull NSString *)email
                                                      region:(nonnull NSString *)region
                                                    newEmail:(nonnull NSString *)newEmail
                                                    password:(nonnull NSString *)password
                                                     captcha:(nullable NSString *)captcha ;

@end
