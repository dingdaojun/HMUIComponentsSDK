//
//  HMIDForceLogoutRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2017/4/12.
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"

typedef NSString HMIDForceLogoutScopeKey;
FOUNDATION_EXTERN HMIDForceLogoutScopeKey * _Nonnull const HMIDForceLogoutScopeKeyAll;
FOUNDATION_EXTERN HMIDForceLogoutScopeKey * _Nonnull const HMIDForceLogoutScopeKeyOne;


/**
 API-1016
 强制退出登录
 error_code: // 0100/0105/0114/0115
 */
@interface HMIDForceLogoutRequestTask : HMIDRequestTask

- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken appName:(nonnull NSString *)appName scope:(nonnull HMIDForceLogoutScopeKey *)scope;

@end
