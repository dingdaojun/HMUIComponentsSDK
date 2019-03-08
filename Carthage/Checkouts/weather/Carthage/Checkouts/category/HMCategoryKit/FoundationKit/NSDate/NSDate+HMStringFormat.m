//
//  NSDate+HMStringFormat.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDate+HMStringFormat.h"


@implementation NSDate (HMStringFormat)


#pragma mark 字符串 eg: 2019-10-19
- (NSString *)stringWithFormat_yyyyMMdd {
    return [self stringWithFormat:HMDateFormatyyyy_MM_dd];
}

#pragma mark 字符串 eg: 2019-10
- (NSString *)stringWithFormat_yyyyMM {
    return [self stringWithFormat:HMDateFormatyyyy_MM];
}

#pragma mark 字符串 eg: 10-11
- (NSString *)stringWithFormat_MMdd {
    return [self stringWithFormat:HMDateFormatMM_dd];
}

#pragma mark 根据日期格式，获取格式化字符串
- (NSString *)stringWithFormat:(HMDateFormat)dateFormate {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar = [NSDate currentCalendar];
    formatter.dateFormat = dateFormate;
    NSString *formatString = [formatter stringFromDate:self];
    return formatString;
}

@end
