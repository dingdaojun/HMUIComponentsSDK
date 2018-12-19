//
//  NSDate+HMRetrieving.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDate+HMRetrieving.h"
#import "NSDate+HMGenerate.h"
#import "NSDate+HMAdjust.h"
#import "NSCalendar+HMGenerate.h"

@implementation NSDate (HMRetrieving)


#pragma mark 秒数差
- (NSInteger)secondsAfterDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:anotherDate];
    return (NSInteger) ti;
}

#pragma mark 秒数差
- (NSInteger)secondsBeforeDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [anotherDate timeIntervalSinceDate:self];
    return (NSInteger) ti;
}

#pragma mark 分钟差
- (NSInteger)minutesAfterDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:anotherDate];
    NSInteger min = (NSInteger) (ti / HMSecondsInMinute);
    return min;
}

#pragma mark 分钟差
- (NSInteger)minutesBeforeDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [anotherDate timeIntervalSinceDate:self];
    NSInteger min = (NSInteger) (ti / HMSecondsInMinute);
    return min;
}

#pragma mark 小时差
- (NSInteger)hoursAfterDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:anotherDate];
    return (NSInteger) (ti / HMSecondsInHour);
}

#pragma mark 小时差
- (NSInteger)hoursBeforeDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [anotherDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / HMSecondsInHour);
}

#pragma mark 天数差
- (NSInteger)daysAfterDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:anotherDate];
    return (NSInteger) (ti / HMSecondsInDay);
}

#pragma mark 天数差
- (NSInteger)daysBeforeDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [anotherDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / HMSecondsInDay);
}

#pragma mark 模糊天数差
- (NSInteger)fuzzyDaysAfterDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:anotherDate];
    double fuzzy = (ti / HMSecondsInDay);
    
    return (NSInteger)((fuzzy * 10.0 + 0.5) / 10.0);
}

#pragma mark 模糊天数差
- (NSInteger)fuzzyDaysBeforeDate:(NSDate *)anotherDate {
    NSTimeInterval ti = [anotherDate timeIntervalSinceDate:self];
    double fuzzy = (ti / HMSecondsInDay);
    
    return (NSInteger)((fuzzy * 10.0 + 0.5) / 10.0);
}

#pragma mark 时区差
- (NSInteger)timeZoneOffsetToDate {
    NSTimeZone * timezone = [NSTimeZone systemTimeZone];
    NSInteger ti = [timezone secondsFromGMTForDate:self];
    return (NSInteger)(ti / HMSecondsInHour);
}

#pragma mark 分钟差
- (NSInteger)distanceInMinutesToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMinute fromDate:self toDate:anotherDate options:0];
    return components.minute;
}

#pragma mark 天数差
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark 月数差
- (NSInteger)distanceInMonthsToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMonth fromDate:self toDate:anotherDate options:0];
    return components.month;
}

#pragma mark 上个月
- (NSDate *)preMonthDate {
    return [self dateBySubtractingMonths:1];
}

#pragma mark 下个月
- (NSDate *)nextMonthDate {
    return [self dateByAddingMonths:1];
}

#pragma mark 上个星期
- (NSDate *)preWeekDate {
    NSDate *preWeek = [NSDate dateWithTimeInterval:-7 * HMSecondsInDay sinceDate:self];
    return preWeek;
}

#pragma mark 下个星期
- (NSDate *)nextWeekDate {
    NSDate *nextWeek = [NSDate dateWithTimeInterval:7 * HMSecondsInDay sinceDate:self];
    return nextWeek;
}

#pragma mark 昨天
- (NSDate *)preDayDate {
    NSDate *preDate = [NSDate dateWithTimeInterval:-HMSecondsInDay sinceDate:self];
    return preDate;
}

#pragma mark 明天
- (NSDate *)nextDayDate {
    NSDate *nextDate = [NSDate dateWithTimeInterval:HMSecondsInDay sinceDate:self];
    return nextDate;
}

#pragma mark 明天日期
+ (NSDate *)tomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

#pragma mark 昨天日期
+ (NSDate *)yesterday {
    return [NSDate dateWithDaysBeforeNow:1];
}

#pragma mark 在当前时间比，年龄是多少
- (NSInteger)age {
    return [self ageFromDate:[NSDate date]];
}

#pragma mark 与一个NSDate比，年龄多少
- (NSInteger)ageFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDate *nowDate = date;
    NSDate *birthDay = self;
    NSDateComponents *dc = [calendar components:componentFlags fromDate:birthDay toDate:nowDate options:0];
    
    return labs([dc year]);
}

#pragma mark - Private Method
#pragma mark 在当前日期增加天数的日期
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] dateByAddingDays:days];
}

#pragma mark 在当前日期减少天数的日期
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] dateBySubtractingDays:days];
}

@end
