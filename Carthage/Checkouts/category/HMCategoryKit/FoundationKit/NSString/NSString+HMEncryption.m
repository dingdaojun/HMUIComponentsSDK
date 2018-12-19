//
//  NSString+HMEncryption.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/17.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSString+HMEncryption.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+HMJudge.h"


@implementation NSString (HMEncryption)


#pragma mark 字符串MD5加密(32位 小写)
- (NSString *)md5ForLower32Bate {
    if ([NSString isEmpty:self]) {
        NSLog(@"md5加密，字符串不能为空: %@", self);
        return @"";
    }
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",digest[i]];
    }
    
    return ret;
}

#pragma mark 字符串MD5加密(32位 大写)
- (NSString *)md5ForUpper32Bate {
    if ([NSString isEmpty:self]) {
        NSLog(@"md5加密，字符串不能为空: %@", self);
        return @"";
    }
    
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark 字符串MD5加密(16位 大写)
- (NSString *)md5ForUpper16Bate {
    NSString *md5Str = [self md5ForUpper32Bate];
    NSString  *string;
    
    for (int i = 0; i < 24; i++) {
        string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    
    return string;
}

#pragma mark 字符串MD5加密(16位 小写)
- (NSString *)md5ForLower16Bate {
    NSString *md5Str = [self md5ForLower32Bate];
    NSString *string;
    
    for (int i = 0; i < 24; i++) {
        string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    
    return string;
}

#pragma mark 字符串Base64加密
- (NSString *)base64Encode {
    if ([NSString isEmpty:self]) {
        NSLog(@"base64加密，字符串不能为空: %@", self);
        return @"";
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark base64字符串解密
- (NSString *)base64Decode {
    if ([NSString isEmpty:self]) {
        NSLog(@"base64解密，字符串不能为空: %@", self);
        return @"";
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
