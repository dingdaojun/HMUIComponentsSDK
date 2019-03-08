//
//  @fileName  NSData+HexDump.h
//  @abstract  NSData
//  @author    余彪 创建于 2017/5/10.
//  @revise    余彪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSData (HexDump)


/**
 转字符串

 @return NSString
 */
- (NSString *)hexval;

@end
