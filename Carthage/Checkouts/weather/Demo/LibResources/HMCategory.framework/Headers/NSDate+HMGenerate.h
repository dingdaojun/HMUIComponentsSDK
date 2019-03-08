//
//  @fileName  NSDate+HMGenerate.h
//  @abstract  NSDate生成
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);


/**一分钟包含多少秒*/
FOUNDATION_EXTERN NSInteger const HMSecondsInMinute;
/**一小时包含多少秒*/
FOUNDATION_EXTERN NSInteger const HMSecondsInHour;
/**一天包含多少秒*/
FOUNDATION_EXTERN NSInteger const HMSecondsInDay;
/**一周包含多少秒*/
FOUNDATION_EXTERN NSInteger const HMSecondsInWeek;

/**
 日期格式类型定义
 s - ' '
 _ - '-'
 b - '/'
 c - ':'
 */
typedef NSString* HMDateFormat;

/**yyyy-MM-dd HH:mm:ss*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyy_MM_ddsHHcmmcss;
/**yyyy-MM-dd HH:mm*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyy_MM_ddsHHcmm;
/**yyyy-MM-dd*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyy_MM_dd;
/**yyyy-MM*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyy_MM;
/**MM-dd*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatMM_dd;
/**yyyy/MM/dd HH:mm*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyybMMbddsHHcmm;
/**yyyy/MM/dd*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyybMMbdd;
/**yyyy/MM*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyybMM;
/**MM/dd HH:mm*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatMMbddsHHcmm;
/**MM/dd*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatMMbdd;
/**HH:mm*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatHHcmm;
/**yyyy-MM-dd HH:mm a*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatyyyy_MM_ddsHHcmmsa;
/**HH:mm a*/
FOUNDATION_EXTERN HMDateFormat HMDateFormatHHcmmsa;


@interface NSDate (HMGenerate)


/**
 日历
 
 @return NSCalendar
 */
+ (NSCalendar *)currentCalendar;

/**
 根据字符串创建NSDate，字符串格式必须为: 2014-09-19
 
 @param dateFormatString 时间字符串
 @return NSDate
 */
+ (NSDate *)dateFromFormateString:(NSString *)dateFormatString;

/**
 根据字符串创建NSDate，字符串格式必须与后面所选formate一致

 @param dateString 时间字符串
 @param dateFormat 格式
 @return NSDate
 */
+ (NSDate *)dateFromFormateString:(NSString *)dateString dateFormat:(HMDateFormat)dateFormat;

/**
 根据传入的时分创建NSDate

 @param hours 时
 @param minutes 分
 @return NSDate
 */
+ (NSDate *)dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes;


@end
