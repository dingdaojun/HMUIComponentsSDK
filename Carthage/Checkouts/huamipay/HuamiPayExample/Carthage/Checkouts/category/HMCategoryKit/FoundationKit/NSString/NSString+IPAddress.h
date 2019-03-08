//
//  @fileName  NSString+IPAddress.h
//  @abstract  IP地址
//  @author    李宪 创建于 2017/5/9.
//  @revise    李宪 最后修改于 2017/5/9.
//  @version   当前版本号 1.0(2017/5/9).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (IPAddress)


/**
 IP地址

 @return IP地址
 */
+ (NSString *)ipAddress;

/**
 MAC地址

 @return NSString
 */
+ (NSString *)getMacAddress;

@end
