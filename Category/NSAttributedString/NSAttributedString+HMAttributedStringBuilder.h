//
//  NSAttributedString+HMAttributedStringBuilder.h
//  MiFit
//
//  Created by dingdaojun on 15/11/26.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (HMAttributedStringBuilder)

#pragma mark - Convenient attributed string constructor -

+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes strings:(NSString *)strings, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes string:(NSString *)string;
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes string:(NSString *)string stringEscapedFromText:(NSString *)stringEscapedFromText;


#pragma mark - Time count attributed string -

// e.g. 34分钟.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutesWithSeconds:(NSInteger)seconds;
    
// e.g. 1h34m or 1小时34分 or 34分钟 for parameter "forceUseEnglishStyle" which passed as YES or NO.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutes:(NSInteger)minutes forceUseEnglishStyle:(BOOL)forceUseEnglishStyle;
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutes:(NSInteger)minutes forceUseEnglishStyle:(BOOL)forceUseEnglishStyle inOneDay:(BOOL)inOneDay;

// Call above method for for parameter "forceUseEnglishStyle" which passed as NO.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutes:(NSInteger)minutes;

// e.g. if minutes < 60   return  55分钟 or 55min ;  if minutes >= 60 return  03:15
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeCountMinutesUse24HourFormat:(NSInteger)timeCountMinutes;

#pragma mark - Date and time formatted attributed string with  NSDate -

// e.g. 凌晨11:11 for chinese and 11:11 pm for english
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes time:(NSDate *)time;

// e.g. 下午11:11~下午12:12, no special am/pm symbol for chinese, used for alarm clock and long sit function
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes time:(NSDate *)time forceUseSystemFormat:(BOOL)forceUseSystemFormat;

#pragma mark - Date and time formatted attributed string with time minutes -

// Like hmAttributedString:time:, but for time minutes
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes timeMinutes:(NSInteger)timeMinutes;

#pragma mark - Date and time formatted string -

// For date components.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes monthStringWithDate:(NSDate *)date;
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes monthDayStringWithDate:(NSDate *)date;

#pragma mark - Date and time short style string -

// e.g. 2015
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortYearStringWithDate:(NSDate *)date;

// e.g. 11/11
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortMonthDayStringWithDate:(NSDate *)date;

// e.g. 11/11 and 2015/11/11 for year at 2015.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortDateStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive;

// e.g. 11/11~12/12
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortRangeStringWithDateStart:(NSDate *)startDate stop:(NSDate *)stopDate;

// e.g. 11/11 上午8:20
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortDateAndTimeStringWithDate:(NSDate *)date;

// e.g. 11/11 上午8:20 and 2016/11/11 上午8:20 for year at 2016.
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes shortDateAndTimeStringWithDate:(NSDate *)date yearSensitive:(BOOL)yearSensitive;

#pragma mark - Datas presentation -

// Unit is not shown for parameter "needShowUnit" which passed as NO.

// e.g. 3,455千卡
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes calories:(NSInteger)calories needShowUnit:(BOOL)needShowUnit;
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes calories:(NSInteger)calories;

// e.g. 48天
+ (NSAttributedString *)hmAttributedString:(NSDictionary *)attributes dayCount:(NSInteger)dayCount;

@end


