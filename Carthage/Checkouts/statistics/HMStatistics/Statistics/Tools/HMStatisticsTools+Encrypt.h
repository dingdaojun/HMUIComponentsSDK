//  HMStatisticsTools+Encrypt.h
//  Created on 2018/3/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMStatisticsTools (Encrypt)

#pragma mark - 加解密和校验

/**
 将 content 进行 PBKDF2 加密

 @param content 待加密内容
 @return 加密后的内容
 */
+ (NSString *)generatePBKDF2Content:(NSData *)content;

#pragma mark - 加密操作的辅助函数
/**
 获取 MD5 校验字符串

 @param data 输入的数据
 @return 校验字符串
 */
+ (NSString *)md5StringWithData:(NSData *)data;

/**
 获取 Base64 字符串

 @param data 待操作数据
 @return base64 字符串
 */
+ (NSString *)base64EncodedStringWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
