//
//  HMIDUnBindAccountRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDRequestTask.h"

/**
 API-1014
 解绑第三方账号
 error_code: // 0100/0102/0108/0112/0114/0115
 0112 解绑/绑定失败（绑定失败的原因：用户区域(contry_code)与账号id不在同一个区域
 解绑失败的原因：只有一个绑定账号或者不存在绑定关系（可能也被其他app抢先解绑））
 */
@interface HMIDUnBindAccountRequestTask : HMIDRequestTask

/**
 创建一个解绑三方账号的请求

 @param thirdName 第三方在账号系统中的名字
 @param thirdId 第三方的id
 @param appToken 当前登录的apptoken
 @return HMIDUnBindAccountRequestTask
 */
- (instancetype)initWithThirdName:(NSString *)thirdName
                          thirdId:(NSString *)thirdId
                         appToken:(NSString *)appToken;

@end
