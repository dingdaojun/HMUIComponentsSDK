//
//  HMIDRenewLoginTokenRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"
#import "HMIDLoginTokenItem.h"

/**
 API-1005
 重新生成一个LoginToken
 error_code: // 0100/0105/0108/0114/0115
 */
@interface HMIDRenewLoginTokenRequestTask : HMIDRequestTask

/**
 创建一个更新Logintoken接口
 
 @param loginToken 获取的LoginToken
 @return HMIDLogoutRequestTask 实例
 */
- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken;

@end
