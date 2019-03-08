//
//  HMPEConfig.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/20.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPEConfig : NSObject

+ (nonnull HMPEConfig *)sharedInstance;

/**
 固定的账号系统分配给三方应用的唯一ID，对大小写敏感,eg HuaMi
 */
@property (nonnull, readonly) NSString *clientId;

/**
 账号系统申请的appName
 */
@property (nonnull, readonly) NSString *appName;

/**
 重定向URI
 */
@property (nonnull, nonatomic, copy) NSString *redirectURI;

/**
 Query 尽可能的避免冲突参数，实现为phone/device id MD5 hash as 32 digit hexadecimal string
 */
@property (nonnull, readonly) NSString *r;

/**
 手机唯一ID
 */
@property (nullable, nonatomic, copy) NSString *deviceId;

@end
