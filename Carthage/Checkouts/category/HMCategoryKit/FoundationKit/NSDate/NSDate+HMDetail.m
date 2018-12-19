//
//  NSDate+HMDetail.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDate+HMDetail.h"
#import "NSDate+HMGenerate.h"
#import "NSCalendar+HMGenerate.h"

 HMWeekDayType const kHMWeekdayMonday    = @"HMWeekday_Monday";
 HMWeekDayType const kHMWeekdayTuesday   = @"HMWeekday_Tuesday";
 HMWeekDayType const kHMWeekdayWednesday = @"HMWeekday_Wednesday";
 HMWeekDayType const kHMWeekdayThursday  = @"HMWeekday_Thursday";
 HMWeekDayType const kHMWeekdayFriday    = @"HMWeekday_Friday";
 HMWeekDayType const kHMWeekdaySaturday  = @"HMWeekday_Saturday";
 HMWeekDayType const kHMWeekdaySunday    = @"HMWeekday_Sunday";

@implementation NSDate (HMDetail)


#pragma mark 接近的小时
- (NSInteger)nearestHour {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + HMSecondsInMinute * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

#pragma mark 小时
- (NSInteger)hour {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

#pragma mark 分钟
- (NSInteger)minute {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

#pragma mark 秒钟
- (NSInteger)seconds {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.second;
}

#pragma mark 天
- (NSInteger)day {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.day;
}

#pragma mark 月
- (NSInteger)month {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.month;
}

#pragma mark 当前月的第几周
- (NSInteger)weekOfMonth {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

#pragma mark 星期几
- (HMWeekDayType)weekday {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    NSInteger weekday = components.weekday;
    switch (weekday) {
        case 1:         return kHMWeekdaySunday;
        case 2:         return kHMWeekdayMonday;
        case 3:         return kHMWeekdayTuesday;
        case 4:         return kHMWeekdayWednesday;
        case 5:         return kHMWeekdayThursday;
        case 6:         return kHMWeekdayFriday;
        case 7:         return kHMWeekdaySaturday;
    }
    return nil;
}

#pragma mark 年
- (NSInteger)year {
    NSDateComponents *components = [[NSCalendar gregorianCalendar] components:componentFlags fromDate:self];
    return components.year;
}

#pragma mark 时间戳
- (long long)milliSecondsSince1970 {
    return (self.timeIntervalSince1970 * 1000);
}

#pragma mark 由weekdayType得到integer
+ (NSInteger)integerWithWeekdayType:(HMWeekDayType)weekdayType format:(HMWeekDayFormat)format {
    NSInteger integer = -1;
    switch (format) {
        case HMWeekDayFormat0_6:
            integer = [self stringFromRange0_6WithWeekdayType:weekdayType];
            break;
        case HMWeekDayFormat1_7:
            integer = [self stringFromRange1_7WithWeekdayType:weekdayType];
            break;
    }
    return integer;
}

#pragma mark - Privated
+ (NSInteger)stringFromRange0_6WithWeekdayType:(HMWeekDayType)weekdayType {

    NSInteger integer = -1;

    if ([weekdayType isEqualToString:kHMWeekdayMonday]) {
        integer = 0;
    } else if ([weekdayType isEqualToString:kHMWeekdayTuesday]) {
        integer = 1;
    } else if ([weekdayType isEqualToString:kHMWeekdayWednesday]) {
        integer = 2;
    } else if ([weekdayType isEqualToString:kHMWeekdayThursday]) {
        integer = 3;
    } else if ([weekdayType isEqualToString:kHMWeekdayFriday]) {
        integer = 4;
    } else if ([weekdayType isEqualToString:kHMWeekdaySaturday]) {
        integer = 5;
    } else {
        integer = 6;
    }

    return integer;
}

+ (NSInteger)stringFromRange1_7WithWeekdayType:(HMWeekDayType)weekdayType {

    NSInteger integer = -1;

    if ([weekdayType isEqualToString:kHMWeekdayMonday]) {
        integer = 1;
    } else if ([weekdayType isEqualToString:kHMWeekdayTuesday]) {
        integer = 2;
    } else if ([weekdayType isEqualToString:kHMWeekdayWednesday]) {
        integer = 3;
    } else if ([weekdayType isEqualToString:kHMWeekdayThursday]) {
        integer = 4;
    } else if ([weekdayType isEqualToString:kHMWeekdayFriday]) {
        integer = 5;
    } else if ([weekdayType isEqualToString:kHMWeekdaySaturday]) {
        integer = 6;
    } else {
        integer = 7;
    }

    return integer;
}

#pragma mark 调整旧版本数据库中的错误日期转成正确的公历日期
- (NSDate *)adjustUnGregorianDate {
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDateComponents *comps = [calendar components:componentFlags fromDate:self];
    //2014-2017当成佛历转成公元年份为1471-1474
    if (self.year >= 1471 && self.year <= 1474) {
        comps.year = self.year + 543;
    }

    //2014-2017当成日本平成历转成公元年份为4002-4005
    if (self.year >= 4002 && self.year <= 4005) {
        comps.year = self.year - 1988;
    }

    return [calendar dateFromComponents:comps];
}

@end
