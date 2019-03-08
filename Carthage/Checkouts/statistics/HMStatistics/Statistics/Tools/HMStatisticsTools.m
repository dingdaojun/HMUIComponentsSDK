//  HMStatisticsTools.m
//  Created on 11/01/2018
//  Description 工具类

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsTools.h"
#import <zlib.h>

@implementation HMStatisticsTools

#pragma mark - 数据转化
// NSDictionary 转换为 NSString
+ (NSString * _Nullable)convertDicToJSONStr:(NSDictionary *)dictionary {

    // 参数检查
    if (!dictionary) {
        return nil;
    }

    if (dictionary.count == 0) {
        return @"";
    }

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];

    if (!jsonData || error) {
        return nil;
    }

    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

// NSString 转换为 NSDictionary
+ (NSDictionary *_Nullable)convertJSONStrToDic:(NSString *)content {

    // 参数检查
    if (!content) {
        return nil;
    }

    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }

    return dic;
}

/**
 将可空字符串转化为安全字符串

 @param unsafeString 可能为空的字符串
 @return 转换后的安全字符串
 */
+ (NSString *)convertToSafeString:(NSString * _Nullable)unsafeString {
    if (unsafeString == nil) {
        return @"";
    }

    return unsafeString;
}

#pragma mark - 数据压缩
/**
 按照指定压缩率进行数据压缩

 @param data 待压缩对象
 @param level 压缩率，详见 zlib 库中 Z_DEFAULT_COMPRESSION 等定义
 @return 压缩后对象
 */
+ (nullable NSData *)gzippedData:(NSData *)data withCompressionLevel:(float)level {
    if (data.length == 0 || [HMStatisticsTools isGzippedData:data]) {
        return data;
    }

    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)(void *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    static const NSUInteger ChunkSize = 16384;

    NSMutableData *output = nil;
    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));

    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }

    return output;
}

/**
 按照默认压缩率进行数据压缩

 @param data 待压缩对象
 @return 压缩对象
 */
+ (nullable NSData *)gzippedData:(NSData *)data {
    return [HMStatisticsTools gzippedData:data withCompressionLevel:-1.0f];
}

/**
 对压缩对象进行解压操作

 @param data 待解压对象
 @return 解压后对象
 */
+ (nullable NSData *)gunzippedData:(NSData *)data {
    if (data.length == 0 || ![HMStatisticsTools isGzippedData:data]) {
        return data;
    }

    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK) {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:data.length * 2];
        while (status == Z_OK) {
            if (stream.total_out >= output.length) {
                output.length += data.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }

        if (inflateEnd(&stream) == Z_OK) {
            if (status == Z_STREAM_END) {
                output.length = stream.total_out;
            }
        }
    }

    return output;
}

/**
 检查数据是否进行过压缩

 @param data 待检查数据
 @return 是否进行过压缩
 */
+ (BOOL)isGzippedData:(NSData*)data {
    const UInt8 *bytes = (const UInt8 *)data.bytes;
    return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

@end
