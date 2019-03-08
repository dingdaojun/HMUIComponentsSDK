//
//  HMPEAccessToken.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPEAccessToken : NSObject

/**
 登录的token
 */
@property (nullable, nonatomic, copy) NSString *accessToken;

/**
 用于刷新accessToken
 */
@property (nullable, nonatomic, copy) NSString *refreshToken;

/**
 accessToken过期时间
 */
@property (nonatomic, assign) NSTimeInterval expiration;

/**
 用户注册的区域
 */
@property (nonnull, nonatomic, copy) NSString *region;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
