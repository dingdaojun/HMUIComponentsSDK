//
//  HMIDGetPhoneNumberRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/9/13.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDRequestTask.h"

@interface HMIDGetPhoneNumberRequestTask : HMIDRequestTask

@property (readonly) NSString *phoneNumber;

/**
 创建一个获取手机号的请求

 @param userId 当前的用户ID
 @param appToken 当前登录使用的apptoken
 @return HMIDGetPhoneNumberRequestTask
 */
- (instancetype)initWithUserId:(NSString *)userId
                      appToken:(NSString *)appToken;
@end
