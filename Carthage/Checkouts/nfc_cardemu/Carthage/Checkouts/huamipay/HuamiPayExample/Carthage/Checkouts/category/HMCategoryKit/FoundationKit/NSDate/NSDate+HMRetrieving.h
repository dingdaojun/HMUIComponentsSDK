//
//  @fileName  NSDate+HMRetrieving.h
//  @abstract  NSDate检索
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSDate+HMDetail.h"

@interface NSDate (HMRetrieving)

/**
 得到当前日期在给定日期之后的秒钟数
 
 @param anotherDate NSDate
 @return 秒数
 */
- (NSInteger)secondsAfterDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之前的秒钟数
 
 @param anotherDate NSDate
 @return 秒数
 */
- (NSInteger)secondsBeforeDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之后的分钟数
 
 @param anotherDate NSDate
 @return 分钟数
 */
- (NSInteger)minutesAfterDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之前的分钟数
 
 @param anotherDate NSDate
 @return 分钟数
 */
- (NSInteger)minutesBeforeDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之后的小时数
 
 @param anotherDate NSDate
 @return 小时数
 */
- (NSInteger)hoursAfterDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之前的小时数
 
 @param anotherDate NSDate
 @return 小时数
 */
- (NSInteger)hoursBeforeDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之后的天数
 
 @param anotherDate NSDate
 @return 天数
 */
- (NSInteger)daysAfterDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之前的天数
 
 @param anotherDate NSDate
 @return 天数
 */
- (NSInteger)daysBeforeDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之后的模糊天数(eg：相差1.95天，就返回2天)
 
 @param anotherDate NSDate
 @return 天数
 */
- (NSInteger)fuzzyDaysAfterDate:(NSDate *)anotherDate;

/**
 得到当前日期在给定日期之前的秒钟数(eg：相差1.95天，就返回2天)
 
 @param anotherDate NSDate
 @return 天数
 */
- (NSInteger)fuzzyDaysBeforeDate:(NSDate *)anotherDate;

/**
 时区差
 
 @return 小时
 */
- (NSInteger)timeZoneOffsetToDate;

/**
 两日期之间的分钟差
 
 @param anotherDate NSDate
 @return 分钟
 */
- (NSInteger)distanceInMinutesToDate:(NSDate *)anotherDate;

/**
 两日期之间的天数差
 
 @param anotherDate NSDate
 @return 天
 */
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

/**
 两日期之间的月数差
 
 @param anotherDate NSDate
 @return 月
 */
- (NSInteger)distanceInMonthsToDate:(NSDate *)anotherDate;

/**
 上个月
 
 @return NSDate
 */
- (NSDate *)preMonthDate;

/**
 下个月
 
 @return NSDate
 */
- (NSDate *)nextMonthDate;

/**
 上个星期
 
 @return NSDate
 */
- (NSDate *)preWeekDate;

/**
 下个星期
 
 @return NSDate
 */
- (NSDate *)nextWeekDate;

/**
 昨天
 
 @return NSDate
 */
- (NSDate *)preDayDate;

/**
 明天
 
 @return NSDate
 */
- (NSDate *)nextDayDate;

/**
 明天日期
 
 @return NSDate
 */
+ (NSDate *)tomorrow;

/**
 昨天日期
 
 @return NSDate
 */
+ (NSDate *)yesterday;

/**
 在当前时间比，年龄是多少
 
 @return 年龄
 */
- (NSInteger)age;

/**
 与一个NSDate比，年龄多少
 
 @param date NSDate
 @return 年龄
 */
- (NSInteger)ageFromDate:(NSDate *)date;

@end
