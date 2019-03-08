//
//  UIDevice+HMVersion.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "UIDevice+HMVersion.h"


@implementation UIDevice (HMVersion)


#pragma mark 获取当前系统版本
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark 当前系统是否低于指定系统
+ (BOOL)systemVersionLessThanVersion:(NSString *)version{
    return [[self systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending;
}

#pragma mark 当前系统是否等于指定系统
+ (BOOL)systemVersionEqualToVersion:(NSString *)version{
    return [[self systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame;
}

#pragma mark 当前系统是否高于指定系统
+ (BOOL)systemVersionGreaterThanVersion:(NSString *)version{
    return [[self systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending;
}

#pragma mark 当前版本是否不低于iOS8_2
+ (BOOL)isIOS8_2Version{
    return NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_8_2;
}

#pragma mark 当前版本是否低于iOS9_0
+ (BOOL)isIOS9_LowVserion {
    return NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_0? YES : NO;
}
@end
