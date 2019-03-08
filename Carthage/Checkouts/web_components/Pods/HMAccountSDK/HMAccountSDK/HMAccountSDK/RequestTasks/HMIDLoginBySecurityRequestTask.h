//
//  HMIDLoginBySecurityRequestTask.h
//  HMAuthDemo
//
//  Created by 李林刚 on 2017/4/25.
//  Copyright © 2017年 李林刚. All rights reserved.
//

#import "HMIDRequestTask.h"
#import "HMIDLoginItem.h"
#import "HMIDLoginTokenItem.h"

/**
 API-1011
 针对小米运动设计接口
 error_code: // 0100/0101/0106/0108/0114/0115
 */
@interface HMIDLoginBySecurityRequestTask : HMIDRequestTask

@property (nullable, readonly) HMIDLoginItem *loginItem;
@property (nullable, readonly) HMIDLoginTokenItem *loginTokenItem;

- (nonnull instancetype)initWithAppName:(nonnull NSString *)appName
                              thirdName:(nonnull NSString *)thirdName
                               security:(nonnull NSString *)security
                                thirdId:(nonnull NSString *)thirdId
                           deviceIdType:(nullable NSString *)deviceIdType
                               deviceId:(nullable NSString *)deviceId;
@end
