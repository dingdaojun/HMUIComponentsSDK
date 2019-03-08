//
//  HMAccountConfig.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 邮箱和手机号服务器环境变量
 
 - HMIDServerEnvironmentTest: 测试服务
 - HMIDServerEnvironmentLive: 线上服务
 - HMIDServerEnvironmentCount: 计数使用,不代表任何操作
 */
typedef NS_ENUM(NSInteger, HMIDServerEnvironment) {
    HMIDServerEnvironmentTest = 0,
    HMIDServerEnvironmentLive = 1,
    HMIDServerEnvironmentCount = 2,
};

/**
 对账号系统的通用配置
 */
@interface HMAccountConfig : NSObject

/**
 获取自定义请求Header
 */
+ (NSDictionary *)customHeader;

/**
 自定义请求Header

 @note
 一下情况自定义的key会被忽略：
 1、包含Content-Type、User-Agent、Accept-Language、app_name
 2、其他标准key暂时还未定夺的
 @param value 值
 @param field key
 */
+ (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 设置业务环境变量
 
 @param serverEnvironment HMServerEnvironment
 */
+ (void)setServerEnvironment:(HMIDServerEnvironment)serverEnvironment;

/**
 获取当前的业务环境
 
 @return HMIDServerEnvironment
 */
+ (HMIDServerEnvironment)getCurrentServerEnvironment;

/**
 返回通用接口域名

 @return NSString
 */
+ (NSString *)idAccountServerHost;

/**
 返回账号系统中国域名

 @return NSString
 */
+ (NSString *)idAccountCNServerHost;

/**
 返回账号系统美国域名

 @return NSString
 */
+ (NSString *)idAccountUSServerHost;

/**
 获取邮箱/手机号服务域名
 
 @return NSString
 */
+ (NSString *)phoneEmailAccountServerHost;

@end
