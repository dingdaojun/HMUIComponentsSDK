//
//  NSDate+HMSystemTime.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "NSDate+HMSystemTime.h"
#import "NSDateFormatter+HMGenerate.h"

@implementation NSDate (HMSystemTime)


#pragma mark 是否是24小时制
+ (BOOL)is24hourTimeSystem {
    NSDateFormatter *formatter = [NSDateFormatter formatter];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    return is24h;
}

@end
