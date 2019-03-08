//
//  HMIDAppTokenItem.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMIDAppTokenItem : NSObject

/**
 具体业务需要的appToken
 */
@property (nullable, readonly) NSString *appToken;

/**
 apptoken的有效时间
 */
@property (readonly) NSInteger appTokenTTL;

/**
 apptoken过期时间
 */
@property (readonly) NSInteger appTokenExpiresIn;

/**
 账号系统中用户的唯一标识
 */
@property (nullable, readonly) NSString *userId;


/**
 初始化

 @param dictionary apptoken信息
 @return HMIDAppTokenItem 对象
 */
- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary;

/**
 apptoken 是否登录？

 @return YES ？ 已登录 ： 未登录
 */
- (BOOL)hasLogin;

/**
 保存到本地

 @return YES ？ 保存成功 ： 保存失败
 */
- (BOOL)save;

/**
 判断本地Token是否有效
 
 @return YES ？ 有效 ：无效
 */
- (BOOL)isValided;


/**
 清除本地缓存的apptoken
 */
- (void)clear;

/**
 内容copy

 @param item HMIDAppTokenItem对象
 */
- (void)copyFromItem:( HMIDAppTokenItem * _Nonnull )item;

@end
