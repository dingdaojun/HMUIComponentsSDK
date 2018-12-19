//
//  @fileName  UIDevice+HMVersion.h
//  @abstract  系统版本
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIDevice (HMVersion)


/**
 获取当前系统版本
 
 @return NSString
 */
+ (NSString *)systemVersion;

/**
 当前系统是否低于指定系统
 
 @param version 指定系统版本号
 
 @return YES ？ 低于指定系统 ： 不低于指定系统
 */
+ (BOOL)systemVersionLessThanVersion:(NSString *)version;

/**
 当前系统是否等于指定系统
 
 @param version 指定系统版本号
 
 @return YES ？ 等于指定系统 ： 不等于指定系统
 */
+ (BOOL)systemVersionEqualToVersion:(NSString *)version;

/**
 当前系统是否高于指定系统
 
 @param version 指定系统版本号
 
 @return YES ？ 高于指定系统 ： 不高于指定系统
 */
+ (BOOL)systemVersionGreaterThanVersion:(NSString *)version;

/**
 当前版本是否不低于iOS8_2

 @return BOOL
 */
+ (BOOL)isIOS8_2Version;

/**
 当前版本是否低于iOS9_0

 @return BOOL
 */
+ (BOOL)isIOS9_LowVserion;

@end
