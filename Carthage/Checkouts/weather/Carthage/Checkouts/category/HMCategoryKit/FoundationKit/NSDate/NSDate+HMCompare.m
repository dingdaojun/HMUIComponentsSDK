//
//  NSDate+HMCompare.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDate+HMCompare.h"
#import "NSDate+HMGenerate.h"
#import "NSDate+HMAdjust.h"
#import "NSDate+HMRetrieving.h"


@implementation NSDate (HMCompare)


#pragma mark 是否同一天
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)anotherDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:anotherDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

#pragma mark 是否今天
- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

#pragma mark 是否明天的日期
- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate tomorrow]];
}

#pragma mark 是否昨天日期
- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate yesterday]];
}

#pragma mark 是否在同一个礼拜
- (BOOL)isSameWeekAsDate:(NSDate *)anotherDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSTimeInterval dist = [self timeIntervalSinceDate:anotherDate];
    
    if ((fabs(dist) < HMSecondsInWeek)) {
        // 1..7
        NSDate *firstDate = nil;
        NSDate *lastDate = nil;
        
        if (components1.weekday == 1) {
            firstDate = [self dateBySubtractingDays:6];
            lastDate = self;
        } else if (components1.weekday > 1 && components1.weekday <= 7) {
            firstDate = [self dateBySubtractingDays:components1.weekday - 2];
            lastDate = [self dateByAddingDays:8 - components1.weekday];
        }
        
        if ([anotherDate isEqualToDateIgnoringTime:firstDate]
            || [anotherDate isEqualToDateIgnoringTime:lastDate]) {
            return YES;
        }
        
        if ([anotherDate isEarlierThanDate:firstDate] || [anotherDate isLaterThanDate:lastDate]) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark 和当前日期是否在一个礼拜
- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

#pragma mark 是否是当前日期所在礼拜的下个礼拜
- (BOOL)isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + HMSecondsInWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

#pragma mark 是否是当前日期所在礼拜的上个礼拜
- (BOOL)isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - HMSecondsInWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

#pragma mark 是否在同一个月
- (BOOL)isSameMonthAsDate:(NSDate *)anotherDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:anotherDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

#pragma mark 是否和当前日期是在同一个月
- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

#pragma mark 是否是当前日期的上个月
- (BOOL)isLastMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

#pragma mark 是否是当前日期的下个月
- (BOOL)isNextMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

#pragma mark 是否同一年
- (BOOL)isSameYearAsDate:(NSDate *)anotherDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:anotherDate];
    return (components1.year == components2.year);
}

#pragma mark 是否与当前日期为同一年
- (BOOL)isThisYear {
    return [self isSameYearAsDate:[NSDate date]];
}

#pragma mark 是否是当前日期下一年
- (BOOL)isNextYear {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}

#pragma mark 是否当前日期上一年
- (BOOL)isLastYear {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

#pragma mark 是否早于anotherDate
- (BOOL)isEarlierThanDate:(NSDate *)anotherDate {
    return ([self compare:anotherDate] == NSOrderedAscending);
}

#pragma mark 是否迟于anotherDate
- (BOOL)isLaterThanDate:(NSDate *)anotherDate {
    return ([self compare:anotherDate] == NSOrderedDescending);
}

#pragma mark 是否是以后的时间
- (BOOL)isInFuture {
    return ([self isLaterThanDate:[NSDate date]]);
}

#pragma mark 是否是过去的时间
- (BOOL)isInPast {
    return ([self isEarlierThanDate:[NSDate date]]);
}

#pragma mark 是否在两个日期之间，不考虑时间
- (BOOL)isBetweenDatesIgnoringTime:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    if (!dateStart|| !dateEnd) {
        return false;
    }
    
    if ([self isEqualToDateIgnoringTime:dateStart] || [self isEqualToDateIgnoringTime:dateEnd]) {
        return true;
    }
    
    if ([self isLaterThanDate:dateStart] && [self isEarlierThanDate:dateEnd]) {
        return true;
    } else {
        return false;
    }
}

#pragma mark 是否在两个日期时间之间
- (BOOL)isBetweenDates:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd {
    if (!dateStart || !dateEnd) {
        return false;
    }
    
    if ([self isLaterThanDate:dateStart] && [self isEarlierThanDate:dateEnd]) {
        return true;
    } else {
        return false;
    }
}

#pragma mark 当前时间与格林尼治时间的差值
- (NSInteger)hoursFromGMTDate {
    NSTimeZone *timezone = [NSTimeZone systemTimeZone];
    NSInteger ti = [timezone secondsFromGMTForDate:self];
    return (NSInteger)(ti / 3600);
}

@end
