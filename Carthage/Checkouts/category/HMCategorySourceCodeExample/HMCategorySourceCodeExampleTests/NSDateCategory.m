//
//  NSDateCategory.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/18.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HMCategoryKit.h"


@interface NSDateCategory : XCTestCase

@end

@implementation NSDateCategory

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testDetail {
    NSDate *date = [NSDate dateFromFormateString:@"2017-10-16 11:18:44" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    
    NSLog(@"date====%@", date);
    NSLog(@"qwqwqw=====%li-%li-%li %li:%li:%li", (long)date.year, (long)date.month, (long)date.day, (long)date.hour, (long)date.minute, (long)date.seconds);
    NSLog(@"weekOfMonth===%li\nweekday====%@\nnearestHour===%li", date.weekOfMonth, date.weekday, date.nearestHour);
    XCTAssertTrue(date.year == 2017);
    XCTAssertTrue(date.month == 10);
    XCTAssertTrue(date.day == 16);
    XCTAssertTrue(date.hour == 11);
    XCTAssertTrue(date.minute == 18);
    XCTAssertTrue(date.seconds == 44);
    XCTAssertTrue(date.weekOfMonth == 3);
    XCTAssertTrue([date.weekday isEqualToString:kHMWeekdayMonday]);
    XCTAssertTrue(date.nearestHour == 11);
}

- (void)testCompare {
    NSDate *date = [NSDate dateFromFormateString:@"2017-05-15 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *anotherDate = [NSDate dateFromFormateString:@"2017-05-21 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    
    XCTAssertFalse([date isEqualToDateIgnoringTime:[NSDate date]]);
    XCTAssertFalse([date isToday]);
    XCTAssertFalse([date isTomorrow]);
    XCTAssertFalse([date isYesterday]);
    
    XCTAssertTrue([date isSameWeekAsDate:anotherDate]);
    XCTAssertTrue([date isSameMonthAsDate:anotherDate]);
    XCTAssertTrue([date isSameYearAsDate:anotherDate]);
    
    NSDate *nowDate = [NSDate date];
    
    if (nowDate.year == 2017 && nowDate.month == 5 && nowDate.day == 22) {
        XCTAssertFalse([date isThisWeek]);
        XCTAssertTrue([date isLastWeek]);
        XCTAssertFalse([date isNextWeek]);
        
        XCTAssertTrue([date isThisMonth]);
        XCTAssertFalse([date isLastMonth]);
        XCTAssertFalse([date isNextMonth]);
        
        XCTAssertTrue([date isThisYear]);
        XCTAssertFalse([date isLastYear]);
        XCTAssertFalse([date isNextYear]);
        
        XCTAssertTrue([date isInPast]);
        XCTAssertFalse([date isInFuture]);
    }
    
    NSDate *thirdDate = [NSDate dateFromFormateString:@"2017-05-18 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    
    XCTAssertTrue([thirdDate isBetweenDates:date dateEnd:anotherDate]);
    
    if ([NSLocale isChinaRegion]) {
        XCTAssertEqual([thirdDate hoursFromGMTDate], 8);
    }
}

- (void)testAdjust {
    NSDate *date = [NSDate dateFromFormateString:@"2017-05-18 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *nextYearDate = [date dateByAddingYears:1];
    XCTAssertEqual(nextYearDate.year, date.year + 1);
    XCTAssertEqual(nextYearDate.month, date.month);
    XCTAssertEqual(nextYearDate.day, date.day);
    XCTAssertEqual(nextYearDate.hour, date.hour);
    XCTAssertEqual(nextYearDate.minute, date.minute);
    XCTAssertEqual(nextYearDate.seconds, date.seconds);
    
    NSDate *lastYearDate = [date dateBySubtractingYears:1];
    XCTAssertEqual(lastYearDate.year, date.year - 1);
    XCTAssertEqual(lastYearDate.month, date.month);
    XCTAssertEqual(lastYearDate.day, date.day);
    XCTAssertEqual(lastYearDate.hour, date.hour);
    XCTAssertEqual(lastYearDate.minute, date.minute);
    XCTAssertEqual(lastYearDate.seconds, date.seconds);
    
    NSDate *nextMouthDate = [date dateByAddingMonths:1];
    XCTAssertEqual(nextMouthDate.year, date.year);
    XCTAssertEqual(nextMouthDate.month, date.month + 1);
    XCTAssertEqual(nextMouthDate.day, date.day);
    XCTAssertEqual(nextMouthDate.hour, date.hour);
    XCTAssertEqual(nextMouthDate.minute, date.minute);
    XCTAssertEqual(nextMouthDate.seconds, date.seconds);
    
    NSDate *lastMouthDate = [date dateBySubtractingMonths:1];
    XCTAssertEqual(lastMouthDate.year, date.year);
    XCTAssertEqual(lastMouthDate.month, date.month - 1);
    XCTAssertEqual(lastMouthDate.day, date.day);
    XCTAssertEqual(lastMouthDate.hour, date.hour);
    XCTAssertEqual(lastMouthDate.minute, date.minute);
    XCTAssertEqual(lastMouthDate.seconds, date.seconds);
    
    NSDate *nextDayDate = [date dateByAddingDays:1];
    XCTAssertEqual(nextDayDate.year, date.year);
    XCTAssertEqual(nextDayDate.month, date.month);
    XCTAssertEqual(nextDayDate.day, date.day + 1);
    XCTAssertEqual(nextDayDate.hour, date.hour);
    XCTAssertEqual(nextDayDate.minute, date.minute);
    XCTAssertEqual(nextDayDate.seconds, date.seconds);
    
    NSDate *lastDayDate = [date dateBySubtractingDays:1];
    XCTAssertEqual(lastDayDate.year, date.year);
    XCTAssertEqual(lastDayDate.month, date.month);
    XCTAssertEqual(lastDayDate.day, date.day - 1);
    XCTAssertEqual(lastDayDate.hour, date.hour);
    XCTAssertEqual(lastDayDate.minute, date.minute);
    XCTAssertEqual(lastDayDate.seconds, date.seconds);
    
    NSDate *nextHourDate = [date dateByAddingHours:1];
    XCTAssertEqual(nextHourDate.year, date.year);
    XCTAssertEqual(nextHourDate.month, date.month);
    XCTAssertEqual(nextHourDate.day, date.day);
    XCTAssertEqual(nextHourDate.hour, date.hour + 1);
    XCTAssertEqual(nextHourDate.minute, date.minute);
    XCTAssertEqual(nextHourDate.seconds, date.seconds);
    
    NSDate *lastHourDate = [date dateBySubtractingHours:1];
    XCTAssertEqual(lastHourDate.year, date.year);
    XCTAssertEqual(lastHourDate.month, date.month);
    XCTAssertEqual(lastHourDate.day, date.day);
    XCTAssertEqual(lastHourDate.hour, date.hour - 1);
    XCTAssertEqual(lastHourDate.minute, date.minute);
    XCTAssertEqual(lastHourDate.seconds, date.seconds);
    
    NSDate *nextMinDate = [date dateByAddingMinutes:1];
    XCTAssertEqual(nextMinDate.year, date.year);
    XCTAssertEqual(nextMinDate.month, date.month);
    XCTAssertEqual(nextMinDate.day, date.day);
    XCTAssertEqual(nextMinDate.hour, date.hour);
    XCTAssertEqual(nextMinDate.minute, date.minute + 1);
    XCTAssertEqual(nextMinDate.seconds, date.seconds);
    
    NSDate *lastMinDate = [date dateBySubtractingMinutes:1];
    XCTAssertEqual(lastMinDate.year, date.year);
    XCTAssertEqual(lastMinDate.month, date.month);
    XCTAssertEqual(lastMinDate.day, date.day);
    XCTAssertEqual(lastMinDate.hour, date.hour);
    XCTAssertEqual(lastMinDate.minute, date.minute - 1);
    XCTAssertEqual(lastMinDate.seconds, date.seconds);
    
    NSDate *nextSecondDate = [date dateByAddingSeconds:1];
    XCTAssertEqual(nextSecondDate.year, date.year);
    XCTAssertEqual(nextSecondDate.month, date.month);
    XCTAssertEqual(nextSecondDate.day, date.day);
    XCTAssertEqual(nextSecondDate.hour, date.hour);
    XCTAssertEqual(nextSecondDate.minute, date.minute);
    XCTAssertEqual(nextSecondDate.seconds, date.seconds + 1);
    
    NSDate *lastSecondDate = [date dateBySubtractingSeconds:1];
    XCTAssertEqual(lastSecondDate.year, date.year);
    XCTAssertEqual(lastSecondDate.month, date.month);
    XCTAssertEqual(lastSecondDate.day, date.day);
    XCTAssertEqual(lastSecondDate.hour, date.hour);
    XCTAssertEqual(lastSecondDate.minute, date.minute);
    XCTAssertEqual(lastSecondDate.seconds, date.seconds - 1);
    
    // 极限值测试
    NSDate *extremeNextMonthDate = [NSDate dateFromFormateString:@"2017-12-18 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([extremeNextMonthDate dateByAddingMonths:1].year, extremeNextMonthDate.year + 1);
    
    NSDate *extremeLastMonthDate = [NSDate dateFromFormateString:@"2017-01-18 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([extremeLastMonthDate dateBySubtractingMonths:1].year, extremeLastMonthDate.year - 1);
    
    NSDate *extremeDayDate = [NSDate dateFromFormateString:@"2017-01-31 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeNextDayDate = [extremeDayDate dateByAddingDays:1];
    XCTAssertEqual(extremeNextDayDate.month, extremeDayDate.month + 1);
    XCTAssertEqual(extremeNextDayDate.day, 1);
    
    extremeDayDate = [NSDate dateFromFormateString:@"2017-02-01 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeLastDayDate = [extremeDayDate dateBySubtractingDays:1];
    XCTAssertEqual(extremeLastDayDate.month, extremeDayDate.month - 1);
    XCTAssertEqual(extremeLastDayDate.day, 31);
    
    NSDate *extremeHourDate = [NSDate dateFromFormateString:@"2017-01-18 23:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeNextHourDate = [extremeHourDate dateByAddingHours:1];
    XCTAssertEqual(extremeNextHourDate.day, extremeHourDate.day + 1);
    XCTAssertEqual(extremeNextHourDate.hour, 0);
    
    extremeHourDate = [NSDate dateFromFormateString:@"2017-02-02 00:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeLastHourDate = [extremeHourDate dateBySubtractingHours:1];
    XCTAssertEqual(extremeLastHourDate.day, extremeHourDate.day - 1);
    XCTAssertEqual(extremeLastHourDate.hour, 23);
    
    NSDate *extremeMinDate = [NSDate dateFromFormateString:@"2017-01-18 18:59:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeNextMinDate = [extremeMinDate dateByAddingMinutes:1];
    XCTAssertEqual(extremeNextMinDate.hour, extremeMinDate.hour + 1);
    XCTAssertEqual(extremeNextMinDate.minute, 0);
    
    extremeMinDate = [NSDate dateFromFormateString:@"2017-02-02 12:00:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeLastMinDate = [extremeMinDate dateBySubtractingMinutes:1];
    XCTAssertEqual(extremeLastMinDate.hour, extremeMinDate.hour - 1);
    XCTAssertEqual(extremeLastMinDate.minute, 59);
    
    NSDate *extremeSecondsDate = [NSDate dateFromFormateString:@"2017-01-18 18:22:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeNextSecondsDate = [extremeSecondsDate dateByAddingSeconds:1];
    XCTAssertEqual(extremeNextSecondsDate.minute, extremeSecondsDate.minute + 1);
    XCTAssertEqual(extremeNextSecondsDate.seconds, 0);
    
    extremeSecondsDate = [NSDate dateFromFormateString:@"2017-02-02 12:27:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeLastSecondsDate = [extremeSecondsDate dateBySubtractingSeconds:1];
    XCTAssertEqual(extremeLastSecondsDate.minute, extremeSecondsDate.minute - 1);
    XCTAssertEqual(extremeLastSecondsDate.seconds, 59);
    
    // 特极限值测试
    NSDate *extremeDate = [NSDate dateFromFormateString:@"2017-12-31 23:59:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *extremeNextDate = [extremeDate dateByAddingSeconds:1];
    XCTAssertEqual(extremeNextDate.year, extremeDate.year + 1);
    XCTAssertEqual(extremeNextDate.month, 1);
    XCTAssertEqual(extremeNextDate.day, 1);
    XCTAssertEqual(extremeNextDate.hour, 0);
    XCTAssertEqual(extremeNextDate.minute, 0);
    XCTAssertEqual(extremeNextDate.seconds, 0);
}

- (void)testExtremes {
    NSDate *extremeDate = [NSDate dateFromFormateString:@"2017-5-18 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    
    XCTAssertEqual([extremeDate startOfDay], [NSDate dateFromFormateString:@"2017-5-18 00:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    XCTAssertEqual([extremeDate endOfDay], [NSDate dateFromFormateString:@"2017-5-18 23:59:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    
    XCTAssertEqual([extremeDate startOfMonth], [NSDate dateFromFormateString:@"2017-5-01 00:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    XCTAssertEqual([extremeDate endOfMonth], [NSDate dateFromFormateString:@"2017-5-31 23:59:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    
    XCTAssertEqual([extremeDate startOfCurrentHour], [NSDate dateFromFormateString:@"2017-5-18 17:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    XCTAssertEqual([extremeDate endOfCurrentHour], [NSDate dateFromFormateString:@"2017-5-18 17:59:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    
    XCTAssertEqual([extremeDate startOfCurrentMinute], [NSDate dateFromFormateString:@"2017-5-18 17:21:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    XCTAssertEqual([extremeDate endOfCurrentMinute], [NSDate dateFromFormateString:@"2017-5-18 17:21:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    
    XCTAssertEqual([extremeDate startOfWeek], [NSDate dateFromFormateString:@"2017-5-15 00:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    XCTAssertEqual([extremeDate endOfWeek], [NSDate dateFromFormateString:@"2017-5-21 23:59:59" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
}

- (void)testRetrieving {
    NSDate *secondsDate = [NSDate dateFromFormateString:@"2017-5-18 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *secondsAnotherDate = [NSDate dateFromFormateString:@"2017-5-18 17:21:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    
    XCTAssertEqual([secondsDate secondsAfterDate:secondsAnotherDate], 21);
    XCTAssertEqual([secondsDate secondsBeforeDate:secondsAnotherDate], -21);
    
    NSDate *minDate = [NSDate dateFromFormateString:@"2017-5-18 17:20:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *minAnotherDate = [NSDate dateFromFormateString:@"2017-5-18 17:25:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([minDate minutesAfterDate:minAnotherDate], -4);
    XCTAssertEqual([minDate minutesBeforeDate:minAnotherDate], 4);
    XCTAssertEqual([minDate distanceInMinutesToDate:minAnotherDate], 4);
    
    NSDate *hourDate = [NSDate dateFromFormateString:@"2017-5-18 17:20:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *hourAnotherDate = [NSDate dateFromFormateString:@"2017-5-18 18:25:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([hourDate hoursAfterDate:hourAnotherDate], -1);
    XCTAssertEqual([hourDate hoursBeforeDate:hourAnotherDate], 1);
    
    NSDate *dayDate = [NSDate dateFromFormateString:@"2017-5-18 17:20:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *dayAnotherDate = [NSDate dateFromFormateString:@"2017-5-19 18:25:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([dayDate daysAfterDate:dayAnotherDate], -1);
    XCTAssertEqual([dayDate daysBeforeDate:dayAnotherDate], 1);

    NSDate *fuzzyDayDate = [NSDate dateFromFormateString:@"2017-5-18 00:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *fuzzyDayAnotherDate = [NSDate dateFromFormateString:@"2017-5-19 23:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([fuzzyDayDate fuzzyDaysAfterDate:fuzzyDayAnotherDate], -1);
    XCTAssertEqual([fuzzyDayDate fuzzyDaysBeforeDate:fuzzyDayAnotherDate], 2);
    
    XCTAssertEqual([fuzzyDayDate timeZoneOffsetToDate], 8);
    
    NSDate *monthDate = [NSDate dateFromFormateString:@"2017-5-18 00:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSDate *monthAnotherDate = [NSDate dateFromFormateString:@"2017-6-19 23:00:00" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([monthDate distanceInMonthsToDate:monthAnotherDate], 1);

    NSInteger currentYear = [NSDate date].year;
    NSString *sut = [NSString stringWithFormat:@"%ld-5-18 00:00:00", (long)currentYear];
    NSDate *date = [NSDate dateFromFormateString:sut dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    XCTAssertEqual([date preMonthDate].month, date.month - 1);
    XCTAssertEqual([date nextMonthDate].month, date.month + 1);
    XCTAssertEqual([date preWeekDate].day, 11);
    XCTAssertEqual([date nextWeekDate].day, 25);
    XCTAssertEqual([date preDayDate].day, date.day - 1);
    XCTAssertEqual([date nextDayDate].day, date.day + 1);
    XCTAssertNotNil([NSDate tomorrow]);
    XCTAssertNotNil([NSDate yesterday]);
    
    XCTAssertEqual([date age], 0);
    XCTAssertEqual([[NSDate dateFromFormateString:@"2010-01-01"] ageFromDate:[NSDate dateFromFormateString:@"2017-01-01"]], 7);
}

- (void)testStringFormat {
    // 这里这么转换是多余的，唯一的是做测试用的，实际使用过程中不建议这么干
    NSDate *date = [NSDate dateFromFormateString:@"2010-01-01"];
    XCTAssertTrue([[date stringWithFormat_yyyyMMdd] isEqualToString:@"2010-01-01"]);
    XCTAssertTrue([[date stringWithFormat_yyyyMM] isEqualToString:@"2010-01"]);
    XCTAssertTrue([[date stringWithFormat_MMdd] isEqualToString:@"01-01"]);
}

- (void)testGenerate {
    NSDate *date = [NSDate dateFromFormateString:@"2017-05-17 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    
    NSLog(@"date====%@", date);
    NSLog(@"qwqwqw=====%li-%li-%li %li:%li:%li", (long)date.year, (long)date.month, (long)date.day, (long)date.hour, (long)date.minute, (long)date.seconds);
    
    XCTAssertTrue(date.year == 2017);
    XCTAssertTrue(date.month == 5);
    XCTAssertTrue(date.day == 17);
    XCTAssertTrue(date.hour == 17);
    XCTAssertTrue(date.minute == 21);
    XCTAssertTrue(date.seconds == 21);
    
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017-05-17 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017-05-17 17:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmm]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017-05-17" dateFormat:HMDateFormatyyyy_MM_dd]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017-05" dateFormat:HMDateFormatyyyy_MM]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"05-17" dateFormat:HMDateFormatMM_dd]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017/05/17 17:21" dateFormat:HMDateFormatyyyybMMbddsHHcmm]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017/05/17" dateFormat:HMDateFormatyyyybMMbdd]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017/05" dateFormat:HMDateFormatyyyybMM]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"05/17 17:21" dateFormat:HMDateFormatMMbddsHHcmm]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"05/17" dateFormat:HMDateFormatMMbdd]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"17:21" dateFormat:HMDateFormatHHcmm]);
    
    XCTAssertNotNil([NSDate dateFromFormateString:@"2017-05-17 17:21 P" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmsa]);
    XCTAssertNotNil([NSDate dateFromFormateString:@"17:21 P" dateFormat:HMDateFormatHHcmmsa]);
    
    NSDate *ymdDate = [NSDate dateFromFormateString:@"2017-05-15"];
    XCTAssertTrue(ymdDate.year == 2017);
    XCTAssertTrue(ymdDate.month == 5);
    XCTAssertTrue(ymdDate.day == 15);
    XCTAssertNil([NSDate dateFromFormateString:@"2017-05-15 17:21"]);
    
    NSDate *dateFromTime = [NSDate dateWithTimeIntervalSince1970:1495161856];
    
    NSLog(@"dateFromTime=====%li-%li-%li %li:%li:%li", (long)dateFromTime.year, (long)dateFromTime.month, (long)dateFromTime.day, (long)dateFromTime.hour, (long)dateFromTime.minute, (long)dateFromTime.seconds);
    XCTAssertTrue(dateFromTime.year == 2017);
    XCTAssertTrue(dateFromTime.month == 5);
    XCTAssertTrue(dateFromTime.day == 19);
    XCTAssertTrue(dateFromTime.hour == 10);
    XCTAssertTrue(dateFromTime.minute == 44);
    XCTAssertTrue(dateFromTime.seconds == 16);
    
}

- (void)testSystemTime {
    // 如果切换24小时制，这里就会报错
    XCTAssertFalse([NSDate is24hourTimeSystem]);
}

- (void)testWeekday {
    NSDate *date = [NSDate dateFromFormateString:@"2017-10-15 17:21:21" dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    NSInteger format0_6 = [NSDate integerWithWeekdayType:date.weekday format:HMWeekDayFormat0_6];
    XCTAssert(format0_6 == 6);

    NSInteger format1_7 = [NSDate integerWithWeekdayType:date.weekday format:HMWeekDayFormat1_7];
    XCTAssert(format1_7 == 7);
}

/**
 日本平和历法年份UT
 */
- (void)testYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierJapanese];
    formatter.dateFormat = @"yy-MM-dd";
    NSDate *date = [formatter dateFromString:@"29-10-18"];
    XCTAssertEqual(date.year, 2017);
    XCTAssertTrue([[date stringWithFormat_yyyyMMdd] isEqualToString:@"2017-10-18"]);
}

/**
 公元纪年按日本历法读取年份UT
-NSCalendar
 --currentCalendar:从用户配置中读取当前历法
 --autoupdatingCurrentCalendar:随当前系统历法切换更新
 */
- (void)testJapaneseCalendarYear {

    NSString *dateString = @"2017-10-19";
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierJapanese];

    NSDate *date1 = [NSDate dateFromFormateString:dateString];
    NSDateComponents *comps = [calendar components:componentFlags fromDate:date1];
    XCTAssertTrue(comps.year == 29);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = calendar;
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:@"2017-10-19"];
    XCTAssertTrue(date.year == 4005);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
