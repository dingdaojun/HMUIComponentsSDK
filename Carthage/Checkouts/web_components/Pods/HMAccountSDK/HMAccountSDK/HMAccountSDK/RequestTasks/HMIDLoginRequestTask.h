//
//  HMIDLoginRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"
#import "HMIDLoginItem.h"
#import "HMIDLoginTokenItem.h"

/**
 API-1017
 登录账号系统API
 error_code: // 0100/0101/0106/0108/0113/0114/0115
 */
@interface HMIDLoginRequestTask : HMIDRequestTask

@property (nullable, readonly) HMIDLoginItem *loginItem;
@property (nullable, readonly) HMIDLoginTokenItem *loginTokenItem;
@property (nonnull, readonly) NSString *domain;

/**
 登录账号系统接口请求

 @param grantType 登录模式 @see HMIDTokenGrantTypeOptionKey
 @param appName   账号系统线下分配给的appname
 @param thirdName 账号系统线下分配给第三方授权的名字
 @param code 三方授权获取的Code or token
 @param region   国家区域码，eg,US CN ....
 @param deviceIdType 手机唯一标示类型,最大长度10 eg uuid/imei/mac/unkown
 @param deviceId    手机唯一标示,最大长度100获取不到可传unkown
 @return HMIDLoginRequestTask 实例
 */

- (nonnull instancetype)initWithGrantType:(nonnull HMIDTokenGrantTypeOptionKey)grantType
                                  appName:(nonnull NSString *)appName
                                thirdName:(nonnull NSString *)thirdName
                                     code:(nonnull NSString *)code
                                   region:(nonnull NSString *)region
                             deviceIdType:(nullable NSString *)deviceIdType
                                 deviceId:(nullable NSString *)deviceId;
@end
