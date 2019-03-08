//
//  @fileName  NSDate+HMAdjust.h
//  @abstract  NSDate调整
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDate (HMAdjust)

/**
 追加年数
 
 @param years 年数
 @return NSDate
 */
- (NSDate *)dateByAddingYears:(NSInteger)years;

/**
 减少年数
 
 @param years 年数
 @return NSDate
 */
- (NSDate *)dateBySubtractingYears:(NSInteger)years;

/**
 追加月数
 
 @param months 月数
 @return NSDate
 */
- (NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 减少月数
 
 @param months 月数
 @return NSDate
 */
- (NSDate *)dateBySubtractingMonths:(NSInteger)months;

/**
 追加天数
 
 @param days 天数
 @return NSDate
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;

/**
 减少天数
 
 @param days 天数
 @return NSDate
 */
- (NSDate *)dateBySubtractingDays:(NSInteger)days;

/**
 追加小时
 
 @param hours 小时
 @return NSDate
 */
- (NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 减少小时
 
 @param hours 小时
 @return NSDate
 */
- (NSDate *)dateBySubtractingHours:(NSInteger)hours;

/**
 追加分钟数
 
 @param minutes 分钟数
 @return NSDate
 */
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 减少分钟数
 
 @param minutes 分钟数
 @return NSDate
 */
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes;

/**
 追加秒数
 
 @param seconds 秒数
 @return NSDate
 */
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

/**
 减少秒数
 
 @param seconds 秒数
 @return NSDate
 */
- (NSDate *)dateBySubtractingSeconds:(NSInteger)seconds;


@end
