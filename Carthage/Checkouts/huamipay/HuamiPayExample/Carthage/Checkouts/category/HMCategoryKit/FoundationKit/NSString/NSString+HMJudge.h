//
//  @fileName  NSString+HMJudge.h
//  @abstract  对字符串的各种判断
//  @author    余彪 创建于 2017/5/8.
//  @revise    余彪 最后修改于 2017/5/8.
//  @version   当前版本号 1.0(2017/5/8).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (HMJudge)


/**
 字符串是否为空(如果string==nil， 则返回YES)

 @param string 要判断的字符串
 @return YES ? 空 : 不为空
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 字符串是否为有效邮箱地址

 @return YES ? 是 : 不是
 */
- (BOOL)isValidEmail;

/**
 字符串是否为整型

 @return YES ? 是 : 不是
 */
- (BOOL)isPureInt;

/**
 字符串是否为浮点型

 @return YES ? 是 : 不是
 */
- (BOOL)isPureFloat;

/**
 字符串是否只包含数字

 @return YES ? 是 : 不是
 */
- (BOOL)isOnlyContainNumber;

/**
 字符串是否为有效URL地址

 @return YES ? 是 : 不是
 */
- (BOOL)isValidURL;

@end
