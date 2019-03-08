//
//  HMIDLoginTokenItem.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMIDLoginTokenItem : NSObject

/**
 用户登录的主要票据loginToken
 */
@property (nullable, readonly) NSString *loginToken;

/**
 loginToken的有效时间
 */
@property (readonly) NSInteger loginTokenTTL;

/**
 loginToken过期时间
 */
@property (readonly) NSInteger loginTokenExpiresIn;

/**
 初始化
 
 @param dictionary loginToken信息
 @return HMIDLoginTokenItem 对象
 */
- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary;

/**
 loginToken 是否登录？
 
 @return YES ？ 已登录 ： 未登录
 */
- (BOOL)hasLogin;

/**
 保存到本地
 
 @param error  错误信息
 @return YES ？ 保存成功 ： 保存失败
 */
- (BOOL)save:(NSError *_Nullable *_Nullable)error;

/**
 判断本地Token是否有效

 @return YES ？ 有效 ：无效
 */
- (BOOL)isValided;

/**
 清除本地缓存的loginToken
 */
- (void)clear;

/**
 内容copy
 
 @param item HMIDLoginTokenItem对象
 */
- (void)copyFromItem:(HMIDLoginTokenItem * _Nonnull)item;

@end
