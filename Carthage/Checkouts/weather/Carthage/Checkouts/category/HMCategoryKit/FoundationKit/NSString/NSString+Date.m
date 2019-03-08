//
//  NSString+Date.m
//  HMCategorySourceCodeExample
//
//  Created by zhanggui on 2017/10/19.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "NSString+Date.h"
#import "NSDate+HMDetail.h"

@implementation NSString (Date)

- (BOOL)isGregorianDateString {
    NSArray *components = [self componentsSeparatedByString:@"-"];
    if (components.count == 0) {
        return false;
    }

    NSInteger year = ((NSString *)components.firstObject).integerValue;

    return (year >= 2014 && year <= 2019);
}

#pragma mark 用于数据库层切换日历生成的错误日期数据转成正确公元纪年方法-【旧版错误数据格式均为yyyy-MM-dd]
- (NSDate *)unGregorianDateStringToDate {

    NSInteger length = 0;
    NSCalendarIdentifier identifier = [self detectIdentifierWithYearLength:&length];

    if (identifier == nil) {
        return nil;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [NSCalendar calendarWithIdentifier:identifier];
    NSMutableString *year = @"".mutableCopy;
    for (int i = 0; i < length; i++) {
        [year appendString:@"y"];
    }

    dateFormatter.dateFormat = [[NSString alloc] initWithFormat:@"%@-MM-dd",year];
    NSDate *date = [dateFormatter dateFromString:self];

    return [date adjustUnGregorianDate];
}

#pragma mark Privated
- (NSCalendarIdentifier)detectIdentifierWithYearLength:(NSInteger *)length {

    NSArray *components = [self componentsSeparatedByString:@"-"];
    if (components.count == 0) {
        return nil;
    }

    NSString *year = components.firstObject;
    NSInteger yearNumber  =  year.integerValue;
    *length = year.length;

    NSAssert(yearNumber > 0, @"The year must be digitals.");

    if (yearNumber > 25 && yearNumber < 33) {

        return NSCalendarIdentifierJapanese;

    }  else if (yearNumber > 2556 && yearNumber < 2562) {

        return NSCalendarIdentifierBuddhist;

    } else {

        return NSCalendarIdentifierGregorian;
    }
}
@end
