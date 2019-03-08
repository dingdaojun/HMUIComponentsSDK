//
//  HMAccountTools.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2016/12/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "HMAccountTools.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

NSString * const HMAccountSDKVersion = @"1.5.0";

@implementation HMAccountTools

+ (NSString *)systemLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage hasPrefix:@"zh-Hans"]){
        return @"zh_CN";
    } else if ([currentLanguage hasPrefix:@"zh-Hant"]){
        return @"zh_TW";
    } else if ([currentLanguage hasPrefix:@"zh-Hant-HK"]){
        return @"zh_HK";
    }
    return currentLanguage;
}

+ (NSString *)countryCode {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    if (!countryCode) {
        return @"unkwon";
    }
    return countryCode;
}

+ (NSString *)deviceModel{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return @"phone";
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return @"pad";
    } else {
        return @"unkwon";
    }
}

+ (NSString *)appVersion{
    NSString *appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appShortVersion;
}

+ (BOOL)isEmptyString:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]] ||
        ![string isKindOfClass:[NSString class]] ||
        !string) {
        return YES;
    }
    return NO;
}

+ (BOOL)insensitiveCompareString1:(NSString *)string1 string2:(NSString *)string2{
    return [string1 compare:string2 options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

+ (NSString *)md5HexDigestWithOriginString:(NSString*)originString digestLength:(NSInteger)digestLength{
    if ([originString length] == 0 || !originString) {
        return @"";
    }
    const char *str = [originString UTF8String];
    unsigned char result[digestLength];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *md5String = [NSMutableString stringWithCapacity:digestLength];
    for(int i = 0; i < digestLength; i++) {
        [md5String appendFormat:@"%02X",result[i]];
    }
    return md5String;
}

@end
