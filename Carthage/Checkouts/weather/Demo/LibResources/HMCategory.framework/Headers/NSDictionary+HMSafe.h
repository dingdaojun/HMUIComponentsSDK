//
//  @fileName  NSDictionary+HMSafe.h
//  @abstract  安全获取和设置object
//  @author    余彪 创建于 2017/5/10.
//  @revise    余彪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDictionary (HMSafe)


/**
 获取字符串
 
 @param key key
 @return NSString
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 获取整型
 
 @param key key
 @return NSInteger
 */
- (NSInteger)integerForKey:(NSString *)key;

/**
 获取浮点型
 
 @param key key
 @return float
 */
- (float)floatForKey:(NSString *)key;

/**
 获取bool型
 
 @param key key
 @return BOOL
 */
- (BOOL)boolForKey:(NSString*)key;

/**
 获取字典
 
 @param key key
 @return NSDictionary
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key;

/**
 获取数组
 
 @param key key
 @return NSArray
 */
- (NSArray *)arrayForKey:(NSString *)key;

@end


@interface NSMutableDictionary (HMSafe)

/**
 设置Bool
 
 @param value boolValue
 @param keyName key
 */
- (void)setBool:(BOOL)value forKey:(NSString *)keyName;

/**
 设置Float
 
 @param value floatValue
 @param keyName key
 */
- (void)setFloat:(float)value forKey:(NSString *)keyName;

/**
 设置Integer
 
 @param value integerValue
 @param keyName key
 */
- (void)setInteger:(NSInteger)value forKey:(NSString *)keyName;

/**
 设置安全Value
 
 @param object value
 @param keyName key
 */
- (void)setSafeObject:(id)object forKey:(NSString *)keyName;

@end
