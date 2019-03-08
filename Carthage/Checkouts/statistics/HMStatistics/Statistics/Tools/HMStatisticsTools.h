//  HMStatisticsTools.h
//  Created on 11/01/2018
//  Description 工具类

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMStatisticsTools : NSObject

#pragma mark - 数据转化

/**
 将字典转化为字符串

 @param dictionary 待转化的字典
 @return 转化结果
 */
+ (NSString * _Nullable)convertDicToJSONStr:(NSDictionary *)dictionary;

/**
 将字符串转化为字典

 @param content 待转化的字符串
 @return 转化结果
 */
+ (NSDictionary *_Nullable)convertJSONStrToDic:(NSString *)content;

/**
 将可空字符串转化为安全字符串

 @param unsafeString 可能为空的字符串
 @return 转换后的安全字符串
 */
+ (NSString *)convertToSafeString:(NSString * _Nullable)unsafeString;

#pragma mark - 数据压缩

/**
 按照指定压缩率进行数据压缩

 @param data 待压缩对象
 @param level 压缩率，详见 zlib 库中 Z_DEFAULT_COMPRESSION 等定义
 @return 压缩后对象
 */
+ (nullable NSData *)gzippedData:(NSData *)data withCompressionLevel:(float)level;

/**
 按照默认压缩率进行数据压缩

 @param data 待压缩对象
 @return 压缩对象
 */
+ (nullable NSData *)gzippedData:(NSData *)data;

/**
 对压缩对象进行解压操作

 @param data 待解压对象
 @return 解压后对象
 */
+ (nullable NSData *)gunzippedData:(NSData *)data;

/**
 检查数据是否进行过压缩

 @param data 待检查数据
 @return 是否进行过压缩
 */
+ (BOOL)isGzippedData:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
