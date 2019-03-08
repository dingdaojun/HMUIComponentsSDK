//
//  HMIDLogoutRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"

/**
 API-1004
 退出登录接口
 error_code: // 0100/0105/0108/0114/0115
 */
@interface HMIDLogoutRequestTask : HMIDRequestTask

/**
 创建一个退出登录接口

 @param loginToken 获取的LoginToken
 @return HMIDLogoutRequestTask 实例
 */
- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken;

@end
