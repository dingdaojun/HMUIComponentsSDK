//
//  NSString+HMApp.m
//  HMCategorySourceCodeExample
//

//  Created by 余彪 on 2017/5/9.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "NSString+HMApp.h"


@implementation NSString (HMApp)


#pragma mark App显示名称
+ (NSString *)appDisplayName {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
}

#pragma mark App版本号
+ (NSString *)appVersion {
    NSString *appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appShortVersion;
}

#pragma mark App构建版本号
+ (NSString *)appBuildVersion {
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return buildVersion;
}

#pragma mark 沙盒Documents目录
+ (NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

#pragma mark 沙盒Cache目录
+ (NSString *)cachesPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

#pragma mark 沙盒临时目录
+ (NSString *)tmpPath {
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

#pragma mark 沙盒Documents下的文件路径地址
+ (NSString *)documentPathWithFileName:(NSString *)fileName {
    return [[NSString documentsPath] stringByAppendingString:fileName];
}

@end
