//
//  NSDate+HMAdjust.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDate+HMAdjust.h"
#import "NSDate+HMGenerate.h"
#import "NSDate+HMExtremes.h"
#import "NSCalendar+HMGenerate.h"

@implementation NSDate (HMAdjust)

#pragma mark 追加年数
- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:years];
    NSDate *newDate = [[NSCalendar gregorianCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

#pragma mark 减少年数
- (NSDate *)dateBySubtractingYears:(NSInteger)years {
    return [self dateByAddingYears:-years];
}

#pragma mark 追加月数
- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:months];
    NSDate *newDate = [[NSCalendar gregorianCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

#pragma mark 减少月数
- (NSDate *)dateBySubtractingMonths:(NSInteger)months {
    return [self dateByAddingMonths:-months];
}

#pragma mark 追加天数
- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];
    NSDate *newDate = [[NSCalendar gregorianCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

#pragma mark 减少天数
- (NSDate *)dateBySubtractingDays:(NSInteger)days {
    return [self dateByAddingDays:-days];
}

#pragma mark 追加小时
- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + HMSecondsInHour * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark 减少小时
- (NSDate *)dateBySubtractingHours:(NSInteger)hours {
    return [self dateByAddingHours:-hours];
}

#pragma mark 追加分钟数
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + HMSecondsInMinute * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark 减少分钟数
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes {
    return [self dateByAddingMinutes:-minutes];
}

#pragma mark 追加秒数
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark 减少秒数
- (NSDate *)dateBySubtractingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] - seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

@end
