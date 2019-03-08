//
//  @fileName  NSString+HMAdjust.h
//  @abstract  字符串调整
//  @author    余彪 创建于 2017/5/17.
//  @revise    余彪 最后修改于 2017/5/17.
//  @version   当前版本号 1.0(2017/5/17).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (HMAdjust)


/**
 去除字符串两端的空格
 
 @return NSString
 */
- (NSString *)trimEndsSpace;

/**
 去除字符串所有的空格
 
 @return NSString
 */
- (NSString *)trimAllSpace;

/**
 去除字符串特殊符号 \n \t \r
 
 @return NSString
 */
- (NSString *)trimSpecialCode;

/**
 字符串转字典
 
 @param error 错误信息
 @return NSDictionary
 */
- (NSDictionary *)toDictionaryWithError:(NSError **)error;

/**
 字符串转数组
 
 @param error 错误信息
 @return NSArray
 */
- (NSArray *)toArrayWithError:(NSError **)error;


@end
