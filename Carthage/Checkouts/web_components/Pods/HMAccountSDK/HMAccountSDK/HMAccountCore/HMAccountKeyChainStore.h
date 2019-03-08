//
//  HMAccountKeyChainStore.h
//  HMAuthDemo
//
//  Created by 李林刚 on 2017/4/21.
//  Copyright © 2017年 李林刚. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于对keychain的操作
 */
@interface HMAccountKeyChainStore : NSObject

/**@brief  设备唯一标识，账号系统使用*/
+ (NSString *)uniqueDeviceIdentifier;

/**
 根据指定的account的key返回一个password
 
 @param account 唯一的账号key
 @param error 错误信息
 @return 账号对应的内容
 */
+ (NSString *)passwordForAccount:(NSString *)account error:(NSError **)error;

/**
 删除指定account的内容
 
 @param account 唯一的账号key
 @param error 错误信息
 @return YES ？成功 ：失败
 */
+ (BOOL)deletePasswordForAccount:(NSString *)account error:(NSError **)error;

/**
 保存一个内容
 
 @param password 内容
 @param account 唯一的account
 @param error 错误信息
 @return YES ？成功 ：失败
 */
+ (BOOL)setPassword:(NSString *)password forAccount:(NSString *)account error:(NSError **)error;

/**
 返回一组数据
 
 @param error 错误信息
 @return 该应用在keychain中
 */
+ (NSArray<NSDictionary<NSString *, id> *> *)allAccounts:(NSError **)error;

@end
