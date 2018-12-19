//
//  NSString+HMStringBuilder.m
//  MiFit
//
//  Created by dingdaojun on 15/12/25.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "NSString+HMStringBuilder.h"
@import HMCategory;

@implementation NSString (HMStringBuilder)

+ (NSString *)hourLongCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle {
    if (forceUseEnglishStyle) {
        return @"h";
    } else {
        return @"小时";
    }
}

+ (NSString *)hourCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle {
    if (forceUseEnglishStyle) {
        return @"h";
    } else {
        return @"时";
    }
}

+ (NSString *)minuteCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle {
    if (forceUseEnglishStyle) {
        return @"m";
    } else {
        return @"分";
    }
}

+ (NSString *)minutesCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle {
    if (forceUseEnglishStyle) {
        return @"m";
    } else {
        return @"分钟";
    }
}

+ (NSString *)hourLongCountString {
    return [self hourLongCountStringWithForceUseEnglishStyle:NO];
}

+ (NSString *)hourCountString {
    return [self hourCountStringWithForceUseEnglishStyle:NO];
}

+ (NSString *)minuteCountString {
    return [self minuteCountStringWithForceUseEnglishStyle:NO];
}

+ (NSString *)minutesCountString {
    return [self minutesCountStringWithForceUseEnglishStyle:NO];
}

+ (void)hmCountMinutes:(NSInteger *)minutes withTimeSeconds:(NSInteger)timeSeconds {
    NSInteger formattedSeconds;
    if (timeSeconds >= 0) {
        formattedSeconds = timeSeconds;
    } else {
        formattedSeconds = 0;
    }
    
    NSInteger countMinutes = formattedSeconds / 60;
    
    *minutes = countMinutes;
}

+ (void)hmCountHours:(NSInteger *)hours minutes:(NSInteger *)minutes withTimeMinutes:(NSInteger)timeMinutes {
    NSInteger formattedMinutes;
    if (timeMinutes >= 0) {
        formattedMinutes = timeMinutes;
    } else {
        formattedMinutes = 0;
    }
    
    *hours = formattedMinutes / 60;
    *minutes = formattedMinutes % 60;
}

+ (void)hmCountHoursInOneDay:(NSInteger *)hours minutes:(NSInteger *)minutes withTimeMinutes:(NSInteger)timeMinutes {
    NSInteger formattedMinutes;
    if (timeMinutes >= 0) {
        formattedMinutes = timeMinutes % 1440;
    } else {
        formattedMinutes = 1440 - ((- timeMinutes) % 1440);
    }
    
    *hours = ((formattedMinutes / 60) == 24) ? 0 : (formattedMinutes / 60);
    *minutes = formattedMinutes % 60;
}

+ (NSString *)hmTimeCountStringForPickerWithMinutes:(NSInteger)minutes {
    return [self hmTimeCountStringForPickerWithMinutes:minutes inOneDay:YES];
}

+ (NSString *)hmTimeCountStringWithMinutes:(NSInteger)minutes {
    return [self hmTimeCountStringWithMinutes:minutes inOneDay:YES];
}

+ (void)hmCountMinutes:(NSInteger *)minutes seconds:(NSInteger *)seconds withTotalSeconds:(NSInteger)totalSeconds {
    NSInteger formattedSeconds;
    if (totalSeconds >= 0) {
        formattedSeconds = totalSeconds;
    } else {
        formattedSeconds = 0;
    }

    *minutes = formattedSeconds / 60;
    *seconds = formattedSeconds % 60;
}

+ (NSString *)hmTimeCountMinutesAndSeconds:(NSInteger)totalSeconds {
    NSInteger minutes;
    NSInteger seconds;
    [self hmCountMinutes:&minutes seconds:&seconds withTotalSeconds:totalSeconds];
    return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
}

+ (NSString *)hmTimeCountStringForPickerWithMinutes:(NSInteger)minutes inOneDay:(BOOL)inOneDay {
    NSInteger hours;
    NSInteger minute;
    
    if (inOneDay) {
        [self hmCountHoursInOneDay:&hours minutes:&minute withTimeMinutes:minutes];
    } else {
        [self hmCountHours:&hours minutes:&minute withTimeMinutes:minutes];
    }

    if (minutes == 60) {
        return [NSString stringWithFormat:[self nonChineseSensitiveFormatString], [@(minutes) stringValue], [self minutesCountString]];
    } else if (hours == 0) {
        return [NSString stringWithFormat:[self nonChineseSensitiveFormatString], [@(minute) stringValue], [self minutesCountString]];
    } else {
        if (minute == 0) {
            return [NSString stringWithFormat:[self nonChineseSensitiveFormatString], [@(hours) stringValue], [self hourLongCountString]];
        } else {
            return [NSString stringWithFormat:[self nonChineseSensitiveFormatStringWithCount:4], [@(hours) stringValue], [NSString hourLongCountString], [NSString stringWithFormat:@"%02ld", (long)minute], [NSString minutesCountString]];
        }
    }
}

+ (NSString *)nonChineseSensitiveFormatString
{
    return @"%@ %@";
}

+ (NSString *)nonChineseSensitiveFormatStringWithCount:(NSInteger)count
{
    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSInteger index = 0; index < count; index++) {
        [string appendString:@"%@"];
    }
    return string;
}

+ (NSString *)hmTimeCountStringWithMinutes:(NSInteger)minutes forceUseEnglishStyle:(BOOL)forceUseEnglishStyle inOneDay:(BOOL)inOneDay
{
    NSInteger hours;
    NSInteger minute;
    
    if (inOneDay) {
        [self hmCountHoursInOneDay:&hours minutes:&minute withTimeMinutes:minutes];
    } else {
        [self hmCountHours:&hours minutes:&minute withTimeMinutes:minutes];
    }
    
    if (hours == 0) {
        return [NSString stringWithFormat:[self nonChineseSensitiveFormatString], [@(minute) stringValue], [self minutesCountStringWithForceUseEnglishStyle:forceUseEnglishStyle]];
    } else {
        
        if (minute == 0) {
            return [NSString stringWithFormat:[self nonChineseSensitiveFormatStringWithCount:4], [@(hours) stringValue], [self hourCountStringWithForceUseEnglishStyle:forceUseEnglishStyle], @"00", [self minuteCountStringWithForceUseEnglishStyle:forceUseEnglishStyle]];
        } else {
            return [NSString stringWithFormat:[self nonChineseSensitiveFormatStringWithCount:4], [@(hours) stringValue], [NSString hourCountStringWithForceUseEnglishStyle:forceUseEnglishStyle], [NSString stringWithFormat:@"%02ld", (long)minute], [NSString minuteCountStringWithForceUseEnglishStyle:forceUseEnglishStyle]];
        }
    }
}

+ (NSString *)hmTimeCountStringWithMinutes:(NSInteger)minutes inOneDay:(BOOL)inOneDay
{
    return [self hmTimeCountStringWithMinutes:minutes forceUseEnglishStyle:NO inOneDay:inOneDay];
}

+ (void)hmHours:(NSInteger *)hours minutes:(NSInteger *)minutes withTimeMinutes:(NSInteger)timeMinutes {
    NSInteger mod;
    if (timeMinutes >= 0) {
        mod = timeMinutes % 1440;
    } else {
        mod = 1440 - ((- timeMinutes) % 1440);
    }
    
    NSInteger hoursValue = mod / 60;
    NSInteger minutesValue = mod % 60;
    
    if (hoursValue == 24) {
        hoursValue = 0;
    }
    *hours = hoursValue;
    *minutes = minutesValue;
}

+ (NSInteger)hmTimeMinutesWithHours:(NSInteger)hours minutes:(NSInteger)minutes {
    NSInteger timeMinutesValue;
    
    if (hours == 24) {
        hours = 0;
    }
    timeMinutesValue = hours * 60 + minutes;
    return timeMinutesValue;
}

+ (NSString *)hmRangeSymbol {
    return @"~";
}

+ (NSString *)hmShortDateAndTimeStringWithDate:(NSDate *)date {
    NSString *dateString = [NSString hmShortDateStringWithDate:date yearSensitive:YES];
    NSString *timeString = [NSString hmTimeStringWithDate:date];
    
    NSString *dateAndTimeString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
    
    return dateAndTimeString;
}

+ (NSString *)hmYearMonthDayStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *formatterString = [NSDateFormatter dateFormatFromTemplate:@"yyyyMMMMd" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    
    [dateFormatter setDateFormat:formatterString];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)hmMonthStringWithDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *formatterString;
    formatterString = @"MMM";
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:formatterString options:0 locale:[NSLocale autoupdatingCurrentLocale]]];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)hmMonthDayTimeStringWithDate:(NSDate *)date {
    return [NSString stringWithFormat:@"%@ %@", [self hmMonthDayStringWithDate:date], [self hmTimeStringWithDate:date]];
}

+ (NSString *)hmYearMonthStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    NSString *template;
    if (date.year != [NSDate date].year) {
        template = @"yyyyMMMM";
    } else {
        template = @"MMMM";
    }
    
    NSString *formatterString = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:[NSLocale autoupdatingCurrentLocale]];

    [dateFormatter setDateFormat:formatterString];
    NSString *timeString = [dateFormatter stringFromDate:date];

    return timeString;
}

+ (NSString *)hmMonthDayStringWithDate:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSMutableString *formatterString;
    formatterString = [@"MMMMd" mutableCopy];
    
    if (date.year != [NSDate date].year) {
        [formatterString insertString:@"yyyy" atIndex:0];
    }
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:formatterString options:0 locale:[NSLocale autoupdatingCurrentLocale]]];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)hmShortMonthDayStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *formatterString;
    formatterString = [NSString stringWithFormat:@"M%@d", @"/"];
    
    [dateFormatter setDateFormat:formatterString];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)hmShortYearStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableString *formatterString;
    formatterString = [@"yyyy" mutableCopy];

    [dateFormatter setDateFormat:formatterString];
    NSString *timeString = [dateFormatter stringFromDate:date];

    return timeString;
}

+ (NSString *)hmShortDateStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive {
    return [self hmShortDateStringWithDate:date yearSensitive:yearSensitive separator:@"/"];
}

+ (NSString *)hmShortDateStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive separator:(NSString *)separator {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *formatterString;
    if (yearSensitive && (date.year == [NSDate date].year)) {
        formatterString = [NSString stringWithFormat:@"M%@d", separator];
    } else {
        formatterString = [NSString stringWithFormat:@"yyyy%@M%@d", separator, separator];
    }
    
    [dateFormatter setDateFormat:formatterString];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)hmDateShortRangeStringWithDateStart:(NSDate *)startDate stop:(NSDate *)stopDate {
    return [NSString stringWithFormat:@"%@%@%@", [self hmShortMonthDayStringWithDate:startDate], [self hmRangeSymbol], [self hmShortMonthDayStringWithDate:stopDate]];
}

+ (NSString *)hmTimeRangeStringWithTimeMinutesStart:(NSInteger)startTimeMinutes stop:(NSInteger)stopTimeMinutes {
    return [NSString stringWithFormat:@"%@%@%@", [self hmTimeStringWithTimeMinutes:startTimeMinutes], [self hmRangeSymbol], [self hmTimeStringWithTimeMinutes:stopTimeMinutes]];
}

+ (NSString *)hmTimeRangeStringWithDateStart:(NSDate *)startDate stop:(NSDate *)stopDate {
    return [NSString stringWithFormat:@"%@%@%@", [self hmTimeStringWithDate:startDate], [self hmRangeSymbol], [self hmTimeStringWithDate:stopDate]];
}

+ (NSString *)hmTimeStringWithTimeMinutes:(NSInteger)timeMinutes {
    NSInteger hours;
    NSInteger minutes;
    [NSString hmHours:&hours minutes:&minutes withTimeMinutes:timeMinutes];
    
    NSDate *time = [NSDate dateWithHours:hours minutes:minutes];
    return [self hmTimeStringWithDate:time];
}

+ (NSString *)hmTimeStringWithDate:(NSDate *)date
{
    NSRange amRange;
    NSRange pmRange;
    NSString *timeString;
    timeString = [NSString hmChineseCustomTimeStringWithDate:date amRange:&amRange pmRange:&pmRange];
    
    return timeString;
}

+ (NSString *)hmChineseCustomTimeStringWithTimeMinutes:(NSInteger)timeMinutes amRange:(NSRange *)amRange pmRange:(NSRange *)pmRange {
    NSInteger hours;
    NSInteger minutes;

    [NSString hmHours:&hours minutes:&minutes withTimeMinutes:timeMinutes];
    return [self hmChineseCustomTimeStringWithDate:[NSDate dateWithHours:hours minutes:minutes] amRange:amRange pmRange:pmRange];
}

+ (NSString *)hmChineseCustomTimeStringWithDate:(NSDate *)date amRange:(NSRange *)amRange pmRange:(NSRange *)pmRange {

    NSInteger hours = date.hour;
    NSString *hmSystemTimeString = [NSString hmSystemTimeStringWithDate:date amRange:amRange pmRange:pmRange];
    
    NSString *hmChineseCustomTimeString = hmSystemTimeString;
    NSString *hmChineseCustomAMPMSymbol;
    
    NSRange chineseCustomAMRange = *amRange;
    NSRange chineseCustomPMRange = *pmRange;
    
    if ((chineseCustomAMRange.location != NSNotFound) || (chineseCustomPMRange.location != NSNotFound)) {
        switch (hours) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            {
                hmChineseCustomAMPMSymbol = @"凌晨";
            }
                break;
            case 5:
            case 6:
            case 7:
            {
                hmChineseCustomAMPMSymbol = @"早上";
            }
                break;
            case 8:
            case 9:
            case 10:
            {
                hmChineseCustomAMPMSymbol = @"上午";
            }
                break;
            case 11:
            case 12:
            {
                hmChineseCustomAMPMSymbol = @"中午";
            }
                break;
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            {
                hmChineseCustomAMPMSymbol = @"下午";
            }
                break;
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            case 23:
            {
                hmChineseCustomAMPMSymbol = @"晚上";
            }
                break;
            default:
                break;
        }
        if (chineseCustomAMRange.location != NSNotFound) {
            hmChineseCustomTimeString = [hmSystemTimeString stringByReplacingCharactersInRange:chineseCustomAMRange withString:hmChineseCustomAMPMSymbol];
            *amRange = [hmChineseCustomTimeString rangeOfString:hmChineseCustomAMPMSymbol];
        }
        if (chineseCustomPMRange.location != NSNotFound) {
            hmChineseCustomTimeString = [hmSystemTimeString stringByReplacingCharactersInRange:chineseCustomPMRange withString:hmChineseCustomAMPMSymbol];
            *pmRange = [hmChineseCustomTimeString rangeOfString:hmChineseCustomAMPMSymbol];
        }
    }
    return hmChineseCustomTimeString;
}

+ (NSString *)hmSystemTimeStringWithTimeMinutes:(NSInteger)timeMinutes amRange:(NSRange *)amRange pmRange:(NSRange *)pmRange {
    NSInteger hours;
    NSInteger minutes;
    [NSString hmHours:&hours minutes:&minutes withTimeMinutes:timeMinutes];
    return [self hmSystemTimeStringWithDate:[NSDate dateWithHours:hours minutes:minutes] amRange:amRange pmRange:amRange];
}
    
+ (NSString *)hmSystemTimeStringWithDate:(NSDate *)date amRange:(NSRange *)amRange pmRange:(NSRange *)pmRange {
    BOOL is24Hour = [NSDate is24hourTimeSystem];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *formatterString;
    if (is24Hour) {
        formatterString = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    } else {
        formatterString = [NSDateFormatter dateFormatFromTemplate:@"hh:mm a" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
        
//        formatterString = @"aHH:mm";
//        formatterString = @"HH:mma";
        
        NSRange hourRange = [formatterString rangeOfString:@"hh"];
        
        NSRange spaceRange = [formatterString rangeOfString:@" "];
        if (spaceRange.location == NSNotFound) {
            NSRange symbolRange = [formatterString rangeOfString:@"a"];
            NSUInteger spaceLocation;
            if (symbolRange.location == 0) {
                spaceLocation = symbolRange.length;
            } else {
                spaceLocation = symbolRange.location;
            }
            NSMutableString *mutableFormatterString = [NSMutableString stringWithString:formatterString];
            [mutableFormatterString insertString:@" " atIndex:spaceLocation];
            formatterString = [mutableFormatterString copy];
        }

        if (hourRange.location == NSNotFound) {
            NSRange noZeroHourRange = [formatterString rangeOfString:@"h"];
            if (noZeroHourRange.location != NSNotFound) {
                NSMutableString *mutableFormatterString = [NSMutableString stringWithString:formatterString];
                [mutableFormatterString insertString:@"h" atIndex:noZeroHourRange.location];
                formatterString = [mutableFormatterString copy];
            }
        }
    }
    
    [dateFormatter setDateFormat:formatterString];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    *amRange = [timeString rangeOfString:[dateFormatter AMSymbol]];
    *pmRange = [timeString rangeOfString:[dateFormatter PMSymbol]];
    
    return timeString;
}

+ (NSString *)hmSeparatorStringOfInteger:(NSInteger)integer {
    NSString *separatorStringOfInteger = nil;
    if (integer >= 1000) {
        separatorStringOfInteger = [NSString stringWithFormat:@"%ld,%03ld", (long)integer / 1000, (long)integer % 1000];
    } else {
        separatorStringOfInteger = [NSString stringWithFormat:@"%ld", (long)integer];
    }
    return separatorStringOfInteger;
}

+ (NSString *)hm_CurrencyStringInCurrentLocaleWithDecimalNumber:(NSDecimalNumber *)decimalNumber {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    return [formatter stringFromNumber:decimalNumber];
}

- (NSInteger)hm_DayCountsIfItIsTimeSpanFormat {

    NSArray *timeSpans = [self componentsSeparatedByString:@"."];
    if ([timeSpans count] != 2) {
        return 0;
    }

    NSArray *daySpans = [timeSpans.firstObject componentsSeparatedByString:@"-"];
    if ([daySpans count] != 4) {
        return 0;
    }

    NSInteger dayCounts = 0;

    NSInteger year = [daySpans[0] integerValue];
    if (year > 0) {
        dayCounts += year * 365;
    }

    NSInteger month = [daySpans[1] integerValue];
    if (month > 0) {
        dayCounts += month * 30;
    }

    NSInteger week = [daySpans[2] integerValue];
    if (week > 0) {
        dayCounts += week * 7;
    }

    NSInteger day = [daySpans[3] integerValue];
    if (day > 0) {
        dayCounts += day;
    }

    return dayCounts;
}

@end
