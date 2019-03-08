//
//  HMAccountTools.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2016/12/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

//SDK 版本号
FOUNDATION_EXTERN NSString * const HMAccountSDKVersion;

@interface HMAccountTools : NSObject

/**
 转换后的语言
 
 @return NSString
 */
+ (NSString *)systemLanguage;

/**
 获取当前手机的国家区域码,国家代码参加https://en.wikipedia.org/wiki/ISO_3166-1，采用国际标准
 @warning 不存在或读取不到则返回unkwon
 @return NSString
 */
+ (NSString *)countryCode;

/**
 设备类型 phone or pad ..
 
 @return NSString
 */
+ (NSString *)deviceModel;

/**
 当前应用的版本号
 
 @return NSString
 */
+ (NSString *)appVersion;

/**
 判断字符串是否为空
 
 @param string 需要判断的字符串
 @return YES ? 空 : 不空
 */
+ (BOOL)isEmptyString:(NSString *)string;

/**
 忽略大小小比较两个字符串的是否相等
 
 @param string1 字符串1
 @param string2 字符串2
 @return YES ？ 相等 ：不相等
 */
+ (BOOL)insensitiveCompareString1:(NSString *)string1 string2:(NSString *)string2;

/**
 字符串MD5加密
 
 @param originString 原始字符串
 @param digestLength 加密数字的长度 16 32 ...
 @return 加密后的字符串
 */
+ (NSString *)md5HexDigestWithOriginString:(NSString*)originString digestLength:(NSInteger)digestLength;


@end
