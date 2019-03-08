//
//  HMIDUserItem.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMIDUserItem : NSObject

/**
 昵称
 */
@property (nonnull, readonly) NSString *nickname;

/**
 头像URL
 */
@property (nullable, readonly) NSString *avatarURL;

/**
 大头像URL
 */
@property (nullable, readonly) NSString *largeAvatarURL;

/**
 三方唯一ID
 */
@property (nullable, readonly) NSString *thirdId;


/**
 初始化

 @param dictionary 用户信息
 @return HMIDUserItem 实例
 */
- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary;

@end
