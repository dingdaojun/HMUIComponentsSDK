//
//  NSString+Pinyin.m
//  VeryZhun
//
//  Created by xianli on 15/8/14.
//  Copyright (c) 2015年 listener~. All rights reserved.
//


#import "NSString+Pinyin.h"


@implementation NSString (Pinyin)


#pragma mark 转拼音
- (NSString *)pinyin {
    if (self.length == 0) {
        return self;
    }
    
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO);
    
    [pinyin replaceOccurrencesOfString:@" "
                            withString:@""
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, pinyin.length)];
    return pinyin;
}

@end
