//
//  HMIDBindAccountRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDRequestTask.h"

/**
 API-1013
 绑定三方账号
 error_code: // 0100/0102/0106/0108/0111/0112/0114/0115
 0111 绑定关系已存在
 0112 解绑/绑定失败（绑定失败的原因：用户区域(contry_code)与账号id不在同一个区域
 解绑失败的原因：只有一个绑定账号或者不存在绑定关系（可能也被其他app抢先解绑））
 */
@interface HMIDBindAccountRequestTask : HMIDRequestTask

/**
 创建一个绑定三方账号的请求

 @param thirdName 三方在账号系统中的名字
 @param code 三方授权获取的code
 @param region 国家代码
 @param grantType HMIDTokenGrantTypeOptionKey类型
 @param appToken 当前使用的apptoken
 @return HMIDBindAccountRequestTask
 */
- (instancetype)initWithThirdName:(NSString *)thirdName
                             code:(NSString *)code
                           region:(NSString *)region
                        grantType:(HMIDTokenGrantTypeOptionKey)grantType
                         appToken:(NSString *)appToken;
@end
