//
//  HMIDBindAccountListRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDRequestTask.h"

/**
 API-1015
 获取当前绑定的所有账号接口
 error_code: // 0100/0102/0108/0114/0115
 */
@interface HMIDBindAccountListRequestTask : HMIDRequestTask

/**
 创建一个获取已绑定的账请求

 @param appToken 当前登录使用的apptoken
 @return HMIDBindAccountListRequestTask
 */
- (instancetype)initWithAppToken:(NSString *)appToken;

@end
