//
//  HMPEChangePasswordRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"

/**
 API-7
 修改密码接口
 200 (OK)
 400 (Bad Request of invalid new password such as blank or used before if clear text is provided)
 401 (wrong old password / password reset / Email address / phone #, or missing/wrong Oauth id "sub" if unconfirmed multiple registrations)
 413 (Payload Too Large)
 429 (Too Many attempts)
 500 (Internal Server Error such as storage or remote regions)
 */
@interface HMPEChangePasswordRequestTask : HMPEBaseRequestTask


/**
 创建一个修改手机账号密码接口

 @param areaCode 手机区号 eg +86
 @param phone 手机号
 @param oldPassword 旧密码
 @param newPassword 新密码
 @return HMPEChangePasswordRequestTask 实例
 */
+ (nonnull HMPEChangePasswordRequestTask *)phoneChangeTaskWithAreaCode:(nonnull NSString *)areaCode
                                                                 phone:(nonnull NSString *)phone
                                                           oldPassword:(nonnull NSString *)oldPassword
                                                           newPassword:(nonnull NSString *)newPassword;

/**
 创建一个重置手机账号密码接口
 
 @param areaCode 手机区号 eg +86
 @param phone 手机号
 @param securityCode 手机验证码(重置密码调用必填，修改密码不必填)
 @param newPassword 新密码
 @return HMPEChangePasswordRequestTask 实例
 */
+ (nonnull HMPEChangePasswordRequestTask *)phoneResetTaskWithAreaCode:(nonnull NSString *)areaCode
                                                                phone:(nonnull NSString *)phone
                                                         securityCode:(nonnull NSString *)securityCode
                                                          newPassword:(nonnull NSString *)newPassword;

/**
 创建一个修改邮箱账号密码的接口

 @param email 邮箱
 @param securityCode 邮箱验证码
 @param oldPassword 旧密码
 @param newPassword 新密码
 @return HMPEChangePasswordRequestTask 实例
 */
+ (nonnull HMPEChangePasswordRequestTask *)emailChangeTaskWithEmail:(nonnull NSString *)email
                                                        oldPassword:(nonnull NSString *)oldPassword
                                                        newPassword:(nonnull NSString *)newPassword;

@end
