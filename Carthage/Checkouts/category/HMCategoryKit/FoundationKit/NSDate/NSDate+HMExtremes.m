//
//  NSDate+HMExtremes.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "NSDate+HMExtremes.h"
#import "NSDate+HMGenerate.h"
#import "NSDate+HMAdjust.h"
#import "NSDate+HMDetail.h"
#import "NSCalendar+HMGenerate.h"

@implementation NSDate (HMExtremes)

#pragma mark 开始于分钟，秒数为0 eg: 2019-10-18 18:19:00
- (NSDate *)startOfCurrentMinute {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.second = 0;
    return [calendar dateFromComponents:components];
}

#pragma mark 结束于分钟，秒数为59 eg: 2019-10-18 18:19:59
- (NSDate *)endOfCurrentMinute {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.second = 59;
    return [calendar dateFromComponents:components];
}

#pragma mark 开始于小时，分钟为0 eg: 2019-10-18 18:00:00
- (NSDate *)startOfCurrentHour {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

#pragma mark 结束于小时，分钟秒钟都为59 eg: 2019-10-18 18:59:59
- (NSDate *)endOfCurrentHour {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

#pragma mark 开始于天，小时分钟秒数都为0，eg: 2019-10-18 00:00:00
- (NSDate *)startOfDay {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

#pragma mark 结束于天，小时分钟秒数都为极值，eg: 2019-10-18 23:59:59
- (NSDate *)endOfDay {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

#pragma mark 开始于星期
- (NSDate *)startOfWeek {
    NSInteger dayCount = [NSDate integerWithWeekdayType:self.weekday format:HMWeekDayFormat0_6];
    NSDate *startDate = [self dateBySubtractingDays:dayCount];
    return [startDate startOfDay];
}

#pragma mark 结束于星期，6天以后
- (NSDate *)endOfWeek {
    return [[[self startOfWeek] dateByAddingDays:6] endOfDay];
}

#pragma mark 开始于月, eg: 2019-10-01 00:00:00
- (NSDate *)startOfMonth {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:componentFlags fromDate:self];
    [dateComponents setDay:1];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *date = [calendar dateFromComponents:dateComponents];
    
    return date;
}

#pragma mark 结束于月, eg: 20119-10-31 23:59:59
- (NSDate *)endOfMonth {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:componentFlags fromDate:self];
    [dateComponents setDay:1];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *date = [calendar dateFromComponents:dateComponents];
    NSDate *nextMonthDate = [date dateByAddingMonths:1];
    return [nextMonthDate dateBySubtractingSeconds:1];
}

@end
