//  HMStatisticsTools+Encrypt.m
//  Created on 2018/3/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsTools+Encrypt.h"
#include <CommonCrypto/CommonCrypto.h>

static const char HMStatisticsBase64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static NSInteger const hmStatisticsSHA1Rounds = 10;     // 加密
static NSString * const hmStatisticsSHA1Salt = @"thisisasaltfor2018huami";

@implementation HMStatisticsTools (Encrypt)

/**
 将 content 进行 PBKDF2 加密
 
 @param content 待加密内容
 @return 加密后的内容
 */
+ (NSString *)generatePBKDF2Content:(NSData *)content {
    // Salt
    NSData *saltData = [hmStatisticsSHA1Salt dataUsingEncoding:NSUTF8StringEncoding];
    
    //哈希 KEY CC_SHA1_BLOCK_BYTES、CC_SHA1_DIGEST_LENGTH
    NSMutableData *hashKeyData = [NSMutableData dataWithLength:32];
    //按 PBKDF2 标准生成
    CCKeyDerivationPBKDF(kCCPBKDF2, content.bytes, content.length, saltData.bytes, saltData.length, kCCPRFHmacAlgSHA1, hmStatisticsSHA1Rounds, hashKeyData.mutableBytes, hashKeyData.length);
    
    NSString *hashKey = [self base64EncodedStringWithData:hashKeyData];
    
    return hashKey;
}

#pragma mark - 加密操作的辅助函数

+ (NSString *)md5StringWithData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)base64EncodedStringWithData:(NSData *)data {
    NSUInteger length = data.length;
    if (length == 0)
    return @"";

    NSUInteger out_length = ((length + 2) / 3) * 4;
    uint8_t *output = malloc(((out_length + 2) / 3) * 4);
    if (output == NULL)
    return nil;

    const char *input = data.bytes;
    NSInteger i, value;
    for (i = 0; i < length; i += 3) {
        value = 0;
        for (NSInteger j = i; j < i + 3; j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = HMStatisticsBase64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = HMStatisticsBase64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = ((i + 1) < length)
        ? HMStatisticsBase64EncodingTable[(value >> 6) & 0x3F]
        : '=';
        output[index + 3] = ((i + 2) < length)
        ? HMStatisticsBase64EncodingTable[(value >> 0) & 0x3F]
        : '=';
    }

    NSString *base64 = [[NSString alloc] initWithBytes:output
                                                length:out_length
                                              encoding:NSASCIIStringEncoding];
    free(output);
    return base64;
}

@end
