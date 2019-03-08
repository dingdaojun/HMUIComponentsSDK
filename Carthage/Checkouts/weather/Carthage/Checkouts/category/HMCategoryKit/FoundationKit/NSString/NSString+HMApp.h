//
//  @fileName  NSString+HMApp.h
//  @abstract  获取app相关数据: App名称、App版本号、App Build版本号、Documents目录地址、Cache目录、临时目录等
//  @author    余彪 创建于 2017/5/9.
//  @revise    余彪 最后修改于 2017/5/9.
//  @version   当前版本号 1.0(2017/5/9).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (HMApp)

/**
 App显示名称

 @return NSString
 */
+ (NSString *)appDisplayName;

/**
 App版本号

 @return NSString
 */
+ (NSString *)appVersion;

/**
 App构建版本号

 @return NSString
 */
+ (NSString *)appBuildVersion;

/**
 沙盒Documents目录

 @return NSString
 */
+ (NSString *)documentsPath;

/**
 沙盒Cache目录

 @return NSString
 */
+ (NSString *)cachesPath;

/**
 沙盒临时目录

 @return NSString
 */
+ (NSString *)tmpPath;

/**
 沙盒Documents下的文件路径地址

 @param fileName 文件名
 @return NSString
 */
+ (NSString *)documentPathWithFileName:(NSString *)fileName;

@end
