//
//  @fileName  NSString+HMURL.h
//  @abstract  URL地址类字符串编码
//  @author    余彪 创建于 2017/5/17.
//  @revise    余彪 最后修改于 2017/5/17.
//  @version   当前版本号 1.0(2017/5/17).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (HMURL)


/**
 URL地址编码
 
 @return NSString
 */
- (NSString *)encodeToPercentEscapeString;

/**
 URL地址解码
 
 @return NSString
 */
- (NSString *)decodeFromPercentEscapeString;


@end
