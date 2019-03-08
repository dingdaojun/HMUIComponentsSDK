//
//  NSAttributedString+HMAttributedStringBuilder.m
//  MiFit
//
//  Created by dingdaojun on 15/11/26.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "NSAttributedString+HMAttributedStringBuilder.h"
#import "NSString+HMStringBuilder.h"
#import "NSDictionary+HMAttributes.h"
@import HMCategory;
@implementation NSAttributedString (HMAttributedStringBuilder)

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes strings:(NSString *)strings, ... NS_REQUIRES_NIL_TERMINATION {

    if (strings != nil) {

        NSDictionary *numberAttributesDictionary = attributes[HMNumberAttributesKey];
        NSDictionary *textAttributesDictionary = attributes[HMTextAttributesKey];
        
        BOOL needToBeCenteredAttribute = [attributes[HMNeedToBeCenteredAttributesKey] boolValue];
        NSDictionary *textClearedAttributesDictionary = attributes[HMTextClearedAttributesKey];
        
        NSMutableArray *stringsArray = nil;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

        va_list args;
        va_start(args, strings);
        stringsArray = [[NSMutableArray alloc] initWithObjects:strings, nil];
        NSString *obj;
        while ((obj = va_arg(args, id)) != nil) {

            [stringsArray addObject:obj];
        }

        [stringsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSDictionary *attributes;
            BOOL endWithText = NO;
            
            NSString *string = [obj stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];

            if (string.length > 0) {

                NSString *escapeString = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":.,-"]];
                if (escapeString.length > 0) {
                    attributes = textAttributesDictionary;
                    endWithText = YES;
                } else {
                    attributes = numberAttributesDictionary;
                }
            } else {
                attributes = numberAttributesDictionary;
            }
            NSMutableAttributedString *objAttributedString = [[NSMutableAttributedString alloc] initWithString:obj attributes:attributes];
            NSAttributedString *spaceAttributedString = [[NSAttributedString alloc] initWithString:@" " attributes:[NSDictionary spaceAttribute]];

            [attributedString appendAttributedString:objAttributedString];

            if (idx < stringsArray.count - 1) {
                [attributedString appendAttributedString:spaceAttributedString];
            } else {
                if (needToBeCenteredAttribute && endWithText) {
                    NSMutableAttributedString *textClearedAttributedString = [[NSMutableAttributedString alloc] initWithString:obj attributes:textClearedAttributesDictionary];
                    [textClearedAttributedString appendAttributedString:spaceAttributedString];
                    
                    [attributedString insertAttributedString:textClearedAttributedString atIndex:0];
                }
            }
        }];

        va_end(args);
        return attributedString;
    } else {
        return nil;
    }
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes string:(NSString *)string {
    NSAttributedString *attributedString = [self hmAttributedString:attributes string:string stringEscapedFromText:nil];
    return attributedString;
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes string:(NSString *)string stringEscapedFromText:(NSString *)stringEscapedFromText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes[HMTextAttributesKey]];
    
    for (NSInteger i = 0; i < string.length; i ++) {
        
        NSRange subStringRange = NSMakeRange(i, 1);
        NSString *subString = [string substringWithRange:subStringRange];
        if ([subString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
            [attributedString addAttributes:attributes[HMNumberAttributesKey] range:subStringRange];
        }
        
        if (stringEscapedFromText.length > 0) {
            NSRange escapeStringRange = NSMakeRange(i, 1);
            NSString *escapeString = [string substringWithRange:escapeStringRange];
            if ([escapeString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:stringEscapedFromText]].location != NSNotFound) {
                [attributedString addAttributes:attributes[HMNumberAttributesKey] range:escapeStringRange];
            }
        }
    }
    
    return attributedString;
}

+ (void)addTextAttributesToAttributedString:(NSMutableAttributedString *)attributedString attributes:(NSDictionary *)attributes amRange:(NSRange)amRange pmRange:(NSRange)pmRange {
    if ([NSDate is24hourTimeSystem]) {
        return;
    }
    if (amRange.location != NSNotFound) {
        [attributedString addAttributes:attributes range:amRange];
    }
    if (pmRange.location != NSNotFound) {
        [attributedString addAttributes:attributes range:pmRange];
    }
    
    NSRange spaceRange = [attributedString.string rangeOfString:@" "];
    if (spaceRange.location != NSNotFound) {
        [attributedString addAttributes:[NSDictionary spaceAttribute] range:spaceRange];
    }
}

#pragma mark - Date and time formatted string -

// For date components.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes monthStringWithDate:(NSDate *)date {
    NSString *monthString = [NSString hmMonthStringWithDate:date];
    
    return [self hmAttributedString:attributes string:monthString];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes monthDayStringWithDate:(NSDate *)date {
    NSString *monthDayString = [NSString hmMonthDayStringWithDate:date];
    
    return [self hmAttributedString:attributes string:monthDayString];
}

#pragma mark - Date and time short style string -

// e.g. 2015

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortYearStringWithDate:(NSDate *)date {
    NSString *dateString = [NSString hmShortYearStringWithDate:date];

    return [[NSAttributedString alloc] initWithString:dateString attributes:attributes[HMNumberAttributesKey]];
}

// e.g. 11/11
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortMonthDayStringWithDate:(NSDate *)date {
    NSString *dateString = [NSString hmShortMonthDayStringWithDate:date];
    return [[NSAttributedString alloc] initWithString:dateString attributes:attributes[HMNumberAttributesKey]];
}

// e.g. 11/11 and 2015/11/11 for year at 2015.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortDateStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive {
    NSString *dateString = [NSString hmShortDateStringWithDate:date yearSensitive:yearSensitive];
    return [[NSAttributedString alloc] initWithString:dateString attributes:attributes[HMNumberAttributesKey]];
}

// e.g. 11/11~12/12
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortRangeStringWithDateStart:(NSDate *)startDate stop:(NSDate *)stopDate {
    NSString *dateString = [NSString hmDateShortRangeStringWithDateStart:startDate stop:stopDate];
    return [[NSAttributedString alloc] initWithString:dateString attributes:attributes[HMNumberAttributesKey]];
}

// e.g. 11/11 上午8:20
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortDateAndTimeStringWithDate:(NSDate *)date {
    return [NSAttributedString hmAttributedString:attributes shortDateAndTimeStringWithDate:date yearSensitive:YES];
}

// e.g. 11/11 上午8:20 and 2016/11/11 上午8:20 for year at 2016.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortDateAndTimeStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive {
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString hmAttributedString:attributes shortDateStringWithDate:date yearSensitive:yearSensitive]];
    NSAttributedString *timeString = [NSAttributedString hmAttributedString:attributes time:date];
    [dateString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" " attributes:[NSDictionary spaceAttribute]]];
    [dateString appendAttributedString:timeString];
    return dateString;
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes dayCount:(NSInteger)dayCount {
    NSString *dayCountString = [NSString hmSeparatorStringOfInteger:dayCount];
    return [NSAttributedString hmAttributedString:attributes strings:dayCountString, @"天", nil];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutesWithSeconds:(NSInteger)seconds {
    NSInteger minutes;
    
    [NSString hmCountMinutes:&minutes withTimeSeconds:seconds];
    
    return [NSAttributedString hmAttributedString:attributes strings:[@(minutes) stringValue], [NSString minutesCountStringWithForceUseEnglishStyle:NO], nil];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutes:(NSInteger)minutes forceUseEnglishStyle:(BOOL)forceUseEnglishStyle {
    return [self hmAttributedString:attributes timeCountMinutes:minutes forceUseEnglishStyle:forceUseEnglishStyle inOneDay:YES];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutes:(NSInteger)minutes forceUseEnglishStyle:(BOOL)forceUseEnglishStyle inOneDay:(BOOL)inOneDay {
    NSInteger hours;
    NSInteger minute;
    
    if (inOneDay) {
        [NSString hmCountHoursInOneDay:&hours minutes:&minute withTimeMinutes:minutes];
    } else {
        [NSString hmCountHours:&hours minutes:&minute withTimeMinutes:minutes];
    }
    
    if (hours == 0) {
        return [NSAttributedString hmAttributedString:attributes strings:[@(minute) stringValue], [NSString minutesCountStringWithForceUseEnglishStyle:forceUseEnglishStyle], nil];
    } else {
        
        return [NSAttributedString hmAttributedString:attributes strings:[@(hours) stringValue], [NSString hourCountStringWithForceUseEnglishStyle:forceUseEnglishStyle],
                [NSString stringWithFormat:@"%02ld", (long)minute], [NSString minuteCountStringWithForceUseEnglishStyle:forceUseEnglishStyle], nil];
    }
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutes:(NSInteger)minutes
{
    return [self hmAttributedString:attributes timeCountMinutes:minutes forceUseEnglishStyle:NO];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutesUse24HourFormat:(NSInteger)timeCountMinutes
{
    if(timeCountMinutes >= 60){
        NSInteger hours;
        NSInteger minutes;
        [NSString hmCountHoursInOneDay:&hours minutes:&minutes withTimeMinutes:timeCountMinutes];
        NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld",(long)hours,(long)minutes];
        return [NSAttributedString hmAttributedString:attributes strings:durationString,nil];
    } else{
        return [NSAttributedString hmAttributedString:attributes timeCountMinutes:timeCountMinutes];
    }
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes steps:(NSInteger)steps {
    return [self hmAttributedString:attributes steps:steps needToShowUnits:NO];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes steps:(NSInteger)steps needToShowUnits:(BOOL)needToShowUnits
{
    NSString *stepsString = [NSString hmSeparatorStringOfInteger:steps];

    if (needToShowUnits) {
        return [NSAttributedString hmAttributedString:attributes strings:stepsString, @"步", nil];
    } else {
        return [NSAttributedString hmAttributedString:attributes strings:stepsString, nil];
    }
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes calories:(NSInteger)calories {
    return [self hmAttributedString:attributes calories:calories needShowUnit:YES];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes calories:(NSInteger)calories needShowUnit:(BOOL)needShowUnit
{
    NSString *caloriesString = [NSString hmSeparatorStringOfInteger:calories];
    if (needShowUnit) {
        return [NSAttributedString hmAttributedString:attributes strings:caloriesString, @"千卡", nil];
    } else {
        return [NSAttributedString hmAttributedString:attributes strings:caloriesString, nil];
    }
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes percent:(NSInteger)percent
{
    NSInteger percentInt = percent % 100;
    return [NSAttributedString hmAttributedString:attributes strings:[@(percentInt) stringValue], @"%", nil];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes time:(NSDate *)time {
    return [self hmAttributedString:attributes time:time forceUseSystemFormat:NO];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes time:(NSDate *)time forceUseSystemFormat:(BOOL)forceUseSystemFormat {
    NSString *timeString;
    NSDictionary *numberAttributes = attributes[HMNumberAttributesKey];
    NSDictionary *textAttributes = attributes[HMTextAttributesKey];
    BOOL needToBeCenteredAttribute = [attributes[HMNeedToBeCenteredAttributesKey] boolValue];
    NSDictionary *textClearedAttributesDictionary = attributes[HMTextClearedAttributesKey];
    
    NSRange amRange;
    NSRange pmRange;
    
    timeString = [NSString hmChineseCustomTimeStringWithDate:time amRange:&amRange pmRange:&pmRange];
    
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:numberAttributes];
    [self addTextAttributesToAttributedString:timeAttributedString attributes:textAttributes amRange:amRange pmRange:pmRange];
    
    if (needToBeCenteredAttribute && ![NSDate is24hourTimeSystem]) {
        NSMutableAttributedString *amOrPmAttributedString;
        
        NSUInteger location = 0;
        if (amRange.location != NSNotFound) {
            amOrPmAttributedString = [[NSMutableAttributedString alloc] initWithString:[timeString substringWithRange:amRange] attributes:textClearedAttributesDictionary];
            location = amRange.location;
        }
        if (pmRange.location != NSNotFound) {
            amOrPmAttributedString = [[NSMutableAttributedString alloc] initWithString:[timeString substringWithRange:pmRange] attributes:textClearedAttributesDictionary];
            location = pmRange.location;
        }
        NSAttributedString *spaceAttributedString = [[NSAttributedString alloc] initWithString:@" " attributes:[NSDictionary spaceAttribute]];
        
        if (location == 0) {
            [amOrPmAttributedString insertAttributedString:spaceAttributedString atIndex:0];
            [timeAttributedString appendAttributedString:amOrPmAttributedString];
        } else {
            [amOrPmAttributedString appendAttributedString:spaceAttributedString];
            [timeAttributedString insertAttributedString:amOrPmAttributedString atIndex:0];
        }
    }
    
    return timeAttributedString;
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeMinutes:(NSInteger)timeMinutes
{
    NSInteger hours;
    NSInteger minutes;
    [NSString hmHours:&hours minutes:&minutes withTimeMinutes:timeMinutes];
    
    NSDate *time = [NSDate dateWithHours:hours minutes:minutes];
    return [self hmAttributedString:attributes time:time];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes bmi:(CGFloat)bmi {
    NSString *format = nil;
    if (bmi > 0) {
        format = @"%.1f";
    } else {
        format = @"%ld";
    }
    NSString *bmiString = [NSString stringWithFormat:format, bmi];
    return [NSAttributedString hmAttributedString:attributes strings:bmiString, nil];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes score:(NSInteger)score
{
    NSString *scoreStr = [NSString stringWithFormat:@"%@",@(score)];
    return [NSAttributedString hmAttributedString:attributes strings:scoreStr, @"分", nil];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes litre:(CGFloat)litre
{
    NSString *litreStr = [NSString stringWithFormat:@"%.2f",litre];
    return [NSAttributedString hmAttributedString:attributes strings:litreStr, @"升", nil];
}

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes grams:(CGFloat)grams
{
    NSString *gramsStr = [NSString stringWithFormat:@"%.1f",grams];
    return [NSAttributedString hmAttributedString:attributes strings:gramsStr, @"克", nil];
}

@end

