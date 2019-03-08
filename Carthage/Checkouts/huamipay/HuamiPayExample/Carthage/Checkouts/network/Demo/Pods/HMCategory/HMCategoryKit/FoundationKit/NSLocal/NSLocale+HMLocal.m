//
//  NSLocale+HMLocal.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/17.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSLocale+HMLocal.h"


@implementation NSLocale (HMLocal)


#pragma mark 判断是不是中国地区
+ (BOOL)isChinaRegion {
    BOOL isChina = YES;
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    if (!countryCode) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        
        if ([currentLanguage hasPrefix:@"zh-Hans"]) {
            isChina = YES;
        } else {
            isChina = NO;
        }
    } else {
        if ([countryCode isEqualToString:@"CN"] ||
            [countryCode isEqualToString:@"HK"] ||
            [countryCode isEqualToString:@"MO"]) {
            isChina = YES;
        } else {
            isChina = NO;
        }
    }
    
    return isChina;
}

#pragma mark 判断是不是中文语言
+ (BOOL)isChinaLanguage {
    NSString *firstLanguage = [[NSLocale preferredLanguages] firstObject];
    NSString *language = [[firstLanguage componentsSeparatedByString:@"-"] firstObject];
    
    if ([language caseInsensitiveCompare:@"zh"] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}


@end
