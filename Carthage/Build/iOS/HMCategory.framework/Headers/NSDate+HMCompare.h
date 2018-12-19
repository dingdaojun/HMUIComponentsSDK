//
//  @fileName  NSDate+HMCompare.h
//  @abstract  NSDate日期时间比较
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDate (HMCompare)


/**
 是否同一天
 
 @param anotherDate NSDate
 @return YES ? 同一天 : 不是同一天
 */
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)anotherDate;

/**
 是否今天
 
 @return YES ? 是 : 不是
 */
- (BOOL)isToday;

/**
 是否明天的日期
 
 @return YES ? 是 : 不是
 */
- (BOOL)isTomorrow;

/**
 是否昨天日期
 
 @return YES ? 是 : 不是
 */
- (BOOL)isYesterday;

/**
 是否在同一个礼拜
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
- (BOOL)isSameWeekAsDate:(NSDate *)anotherDate;

/**
 和当前日期是否在一个礼拜
 
 @return YES ? 是 : 不是
 */
- (BOOL)isThisWeek;

/**
 是否是当前日期所在礼拜的下个礼拜
 
 @return YES ? 是 : 不是
 */
- (BOOL)isNextWeek;

/**
 是否是当前日期所在礼拜的上个礼拜
 
 @return YES ? 是 : 不是
 */
- (BOOL)isLastWeek;

/**
 是否在同一个月
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
- (BOOL)isSameMonthAsDate:(NSDate *)anotherDate;

/**
 是否和当前日期是在同一个月
 
 @return YES ? 是 : 不是
 */
- (BOOL)isThisMonth;

/**
 是否是当前日期的下个月
 
 @return YES ? 是 : 不是
 */
- (BOOL)isNextMonth;

/**
 是否是当前日期的上个月
 
 @return YES ? 是 : 不是
 */
- (BOOL)isLastMonth;

/**
 是否同一年
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
- (BOOL)isSameYearAsDate:(NSDate *)anotherDate;

/**
 是否与当前日期为同一年
 
 @return YES ? 是 : 不是
 */
- (BOOL)isThisYear;

/**
 是否是当前日期下一年
 
 @return YES ? 是 : 不是
 */
- (BOOL)isNextYear;

/**
 是否当前日期上一年
 
 @return YES ? 是 : 不是
 */
- (BOOL)isLastYear;

/**
 是否早于anotherDate
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
- (BOOL)isEarlierThanDate:(NSDate *)anotherDate;

/**
 是否迟于anotherDate
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
- (BOOL)isLaterThanDate:(NSDate *)anotherDate;


/**
 是否是以后的时间
 
 @return YES ? 是 : 不是
 */
- (BOOL)isInFuture;

/**
 是否是过去的时间
 
 @return YES ? 是 : 不是
 */
- (BOOL)isInPast;

/**
 是否在两个日期之间，不考虑时间
 
 @param dateStart 开始NSDate
 @param dateEnd 结束NSDate
 @return YES ? 是 ： 不是
 */
- (BOOL)isBetweenDatesIgnoringTime:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

/**
 是否在两个日期时间之间
 
 @param dateStart 开始NSDate
 @param dateEnd 结束NSDate
 @return YES ? 是 ： 不是
 */
- (BOOL)isBetweenDates:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

/**
 当前时间与格林尼治时间的差值
 
 @return 小时
 */
- (NSInteger)hoursFromGMTDate;

@end
