//
//  HMIDRenewAppTokenRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"
#import "HMIDAppTokenItem.h"

/**
 API-1002
 重新生成appToken
 error_code: // 0100/0101/0105/0108/0114/0115
 */
@interface HMIDRenewAppTokenRequestTask : HMIDRequestTask

/**
 创建一个重新生成appToken的接口

 @param loginToken 当前的loginToken
 @param appName    账号系统线下分配给的appname
 @return HMIDRenewAppTokenRequestTask 实例
 */
- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken
                                   appName:(nonnull NSString *)appName;


@end
