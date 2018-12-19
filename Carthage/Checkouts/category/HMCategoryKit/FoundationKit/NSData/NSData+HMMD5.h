//
//  @fileName  NSData+HMMD5.h
//  @abstract  MD5加密
//  @author    李宪 创建于 2017/8/7.
//  @revise    余彪 最后修改于 2017/8/11.
//  @version   当前版本号 1.1(2017/8/11).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSData (MD5)


/**
 获取MD5加密字符串
 */
@property (nonatomic, copy, readonly) NSString *md5;

@end
