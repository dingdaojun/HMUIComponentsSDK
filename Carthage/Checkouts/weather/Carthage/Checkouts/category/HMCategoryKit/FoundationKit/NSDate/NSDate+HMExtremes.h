//
//  @fileName  NSDate+HMExtremes.h
//  @abstract  NSDate极端区间操作
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDate (HMExtremes)


/**
 开始于分钟，秒数为0 eg: 2019-10-18 18:19:00
 
 @return NSDate
 */
- (NSDate *)startOfCurrentMinute;

/**
 结束于分钟，秒数为59 eg: 2019-10-18 18:19:59
 
 @return NSDate
 */
- (NSDate *)endOfCurrentMinute;

/**
 开始于小时，分钟为0 eg: 2019-10-18 18:00:00
 
 @return NSDate
 */
- (NSDate *)startOfCurrentHour;

/**
 结束于小时，分钟秒钟都为59 eg: 2019-10-18 18:59:59
 
 @return NSDate
 */
- (NSDate *)endOfCurrentHour;

/**
 开始于天，小时分钟秒数都为0，eg: 2019-10-18 00:00:00
 
 @return NSDate
 */
- (NSDate *)startOfDay;

/**
 结束于天，小时分钟秒数都为极值，eg: 2019-10-18 23:59:59
 
 @return NSDate
 */
- (NSDate *)endOfDay;

/**
 开始于星期, 日期所属星期的星期一那天，时分秒为0(具体参看单元测试)
 
 @return NSDate
 */
- (NSDate *)startOfWeek;

/**
 结束于星期天，时为23，分秒为59(具体参看单元测试)
 
 @return NSDate
 */
- (NSDate *)endOfWeek;

/**
 开始于月, eg: 2019-10-01 00:00:00
 
 @return NSDate
 */
- (NSDate *)startOfMonth;

/**
 结束于月, eg: 20119-10-31 23:59:59
 
 @return NSDate
 */
- (NSDate *)endOfMonth;

@end
