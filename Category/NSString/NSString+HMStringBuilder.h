//
//  NSString+HMStringBuilder.h
//  MiFit
//
//  Created by dingdaojun on 15/12/25.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMStringBuilder)

#pragma mark - Time count string -

// Only for HMAppAttributedString.

+ (void)hmCountMinutes:(NSInteger *)minutes withTimeSeconds:(NSInteger)timeSeconds;
    
+ (void)hmCountHours:(NSInteger *)hours minutes:(NSInteger *)minutes withTimeMinutes:(NSInteger)timeMinutes;

+ (void)hmCountHoursInOneDay:(NSInteger *)hours minutes:(NSInteger *)minutes withTimeMinutes:(NSInteger)timeMinutes;

// e.g. 01:34
+ (NSString *)hmTimeCountMinutesAndSeconds:(NSInteger)seconds;

// e.g. 1小时25分钟
+ (NSString *)hmTimeCountStringForPickerWithMinutes:(NSInteger)minutes inOneDay:(BOOL)inOneDay;
+ (NSString *)hmTimeCountStringForPickerWithMinutes:(NSInteger)minutes;
    
// e.g. 1时25分
+ (NSString *)hmTimeCountStringWithMinutes:(NSInteger)minutes inOneDay:(BOOL)inOneDay;
+ (NSString *)hmTimeCountStringWithMinutes:(NSInteger)minutes;

#pragma mark - Date and time formatted string with  NSDate -

// e.g. 凌晨11:11 for chinese and 11:11 pm for english
+ (NSString *)hmTimeStringWithDate:(NSDate *)date;

// e.g. 凌晨11:11~凌晨12:12
+ (NSString *)hmTimeRangeStringWithDateStart:(NSDate *)startDate stop:(NSDate *)stopDate;

// e.g. 下午11:11~下午12:12, no special am/pm symbol for chinese, used for alarm clock and long sit function
+ (NSString *)hmSystemTimeStringWithDate:(NSDate *)date amRange:(NSRange *)amRange pmRange:(NSRange *)pmRange;

// e.g. 凌晨11:11 for chinese only, use hmTimeStringWithDate: instead. Only for HMAppAttributedString
+ (NSString *)hmChineseCustomTimeStringWithDate:(NSDate *)date amRange:(NSRange *)amRange pmRange:(NSRange *)pmRange;

#pragma mark - Date and time formatted string with time minutes -

// Only for HMAppAttributedString.
+ (void)hmHours:(NSInteger *)hours minutes:(NSInteger *)minutes withTimeMinutes:(NSInteger)timeMinutes;
+ (NSInteger)hmTimeMinutesWithHours:(NSInteger)hours minutes:(NSInteger)minutes;

// Like hmTimeStringWithDate:, but for time minutes
+ (NSString *)hmTimeStringWithTimeMinutes:(NSInteger)timeMinutes;

// Like hmTimeRangeStringWithDateStart:stop:, but for time minutes
+ (NSString *)hmTimeRangeStringWithTimeMinutesStart:(NSInteger)startTimeMinutes stop:(NSInteger)stopTimeMinutes;

#pragma mark - Date and time formatted string -

// For date components.
+ (NSString *)hmMonthDayStringWithDate:(NSDate *)date;
+ (NSString *)hmYearMonthDayStringWithDate:(NSDate *)date;
+ (NSString *)hmMonthStringWithDate:(NSDate *)date;
+ (NSString *)hmMonthDayTimeStringWithDate:(NSDate *)date;
+ (NSString *)hmYearMonthStringWithDate:(NSDate *)date;

#pragma mark - Date and time short style string -

// e.g. 2015
+ (NSString *)hmShortYearStringWithDate:(NSDate *)date;

// e.g. 11/11
+ (NSString *)hmShortMonthDayStringWithDate:(NSDate *)date;

// e.g. 11/11 and 2015/11/11 for year at 2015.
+ (NSString *)hmShortDateStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive;

// e.g. 11/11 or 11-11 and 2015/11/11 or 2015-11-11 for year at 2015.
+ (NSString *)hmShortDateStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive separator:(NSString *)separator;
    
// e.g. 11/11~12/12
+ (NSString *)hmDateShortRangeStringWithDateStart:(NSDate *)startDate stop:(NSDate *)stopDate;

// e.g. 11/11 上午8:20
+ (NSString *)hmShortDateAndTimeStringWithDate:(NSDate *)date;

#pragma mark - Common app strings -
// Separate integers to string with ",", e.g. 2,593
+ (NSString *)hmSeparatorStringOfInteger:(NSInteger)integer;

// Time count units, if you pass forceUseEnglishStyle for YES, it will return "h" or "m"
+ (NSString *)hourCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle;
+ (NSString *)minuteCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle;
+ (NSString *)minutesCountStringWithForceUseEnglishStyle:(BOOL)forceUseEnglishStyle;

+ (NSString *)hm_CurrencyStringInCurrentLocaleWithDecimalNumber:(NSDecimalNumber *)decimalNumber;
- (NSInteger)hm_DayCountsIfItIsTimeSpanFormat;

@end
