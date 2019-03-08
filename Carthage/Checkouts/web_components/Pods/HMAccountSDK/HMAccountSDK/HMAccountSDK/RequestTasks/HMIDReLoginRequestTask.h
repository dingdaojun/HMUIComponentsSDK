//
//  HMIDReLoginRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"
#import "HMIDLoginTokenItem.h"
#import "HMIDAppTokenItem.h"


/**
 API-1006
 重新登录账号系统接口
 error_code: // 0100/0101/0105/0114/0115
 */
@interface HMIDReLoginRequestTask : HMIDRequestTask

@property (nullable, readonly) HMIDLoginTokenItem *loginTokenItem;
@property (nullable, readonly) HMIDAppTokenItem *appTokenItem;

/**
 创建一个重新登录的请求

 @param loginToken  现有的登录票据
 @param appName     账号系统线下分配给的appname
 @param deviceIdType 手机唯一标示类型,最大长度10 eg uuid/imei/mac/unkown
 @param deviceId    手机唯一标示,最大长度100获取不到可传unkown
 @return HMIDReLoginRequestTask 实例
 */
- (nonnull instancetype)initWithLoginToken:(nonnull NSString *)loginToken
                                   appName:(nonnull NSString *)appName
                              deviceIdType:(nonnull NSString *)deviceIdType
                                  deviceId:(nonnull NSString *)deviceId;

@end
