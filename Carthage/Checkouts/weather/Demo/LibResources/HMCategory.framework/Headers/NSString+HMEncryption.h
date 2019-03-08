//
//  @fileName  NSString+HMEncryption.h
//  @abstract  加密、解密: MD5、Base64
//  @author    余彪 创建于 2017/5/17.
//  @revise    余彪 最后修改于 2017/5/17.
//  @version   当前版本号 1.0(2017/5/17).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (HMEncryption)


/**
 字符串MD5加密(32位 小写)

 @return NSString
 */
- (NSString *)md5ForLower32Bate;

/**
 字符串MD5加密(32位 大写)

 @return NSString
 */
- (NSString *)md5ForUpper32Bate;

/**
 字符串MD5加密(16位 大写)

 @return NSString
 */
- (NSString *)md5ForUpper16Bate;

/**
 字符串MD5加密(16位 小写)

 @return NSString
 */
- (NSString *)md5ForLower16Bate;

/**
 字符串Base64加密
 
 @return NSString
 */
- (NSString *)base64Encode;

/**
 base64字符串解密
 
 @return NSString
 */
- (NSString *)base64Decode;


@end
