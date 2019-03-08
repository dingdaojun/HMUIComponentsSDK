//
//  @fileName  NSDate+HMDetail.h
//  @abstract  NSDate日期时间的详情
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>


#if defined(NS_STRING_ENUM)  // Available starting in Xcode 8.0.
#define HM_STRING_ENUM NS_STRING_ENUM
#else
#define HM_STRING_ENUM
#endif

typedef NSString *HMWeekDayType HM_STRING_ENUM;

FOUNDATION_EXTERN HMWeekDayType const kHMWeekdayMonday;
FOUNDATION_EXTERN HMWeekDayType const kHMWeekdayTuesday;
FOUNDATION_EXTERN HMWeekDayType const kHMWeekdayWednesday;
FOUNDATION_EXTERN HMWeekDayType const kHMWeekdayThursday;
FOUNDATION_EXTERN HMWeekDayType const kHMWeekdayFriday;
FOUNDATION_EXTERN HMWeekDayType const kHMWeekdaySaturday;
FOUNDATION_EXTERN HMWeekDayType const kHMWeekdaySunday;

typedef NS_ENUM(NSInteger, HMWeekDayFormat)  {
    HMWeekDayFormat0_6,
    HMWeekDayFormat1_7
};

@interface NSDate (HMDetail)


/**
 接近的小时
 */
@property (readonly) NSInteger nearestHour;

/**
 小时
 */
@property (readonly) NSInteger hour;

/**
 分钟
 */
@property (readonly) NSInteger minute;

/**
 秒
 */
@property (readonly) NSInteger seconds;

/**
 天
 */
@property (readonly) NSInteger day;

/**
 月
 */
@property (readonly) NSInteger month;

/**
 当前月的第几周
 */
@property (readonly) NSInteger weekOfMonth;

/**
 星期几
 */
@property (readonly) HMWeekDayType weekday;

/**
 年
 */
@property (readonly) NSInteger year;

/**
 时间戳
 */
@property (readonly) long long milliSecondsSince1970;

/**
 由weekdayType得到integer，规则如下

 -------------------     |   ------------------      |   -----------------
 HMWeekDayType           |   HMWeekDayFormat0_6      |   HMWeekDayFormat1_7
 -------------------     |   ------------------      |   -----------------
 kHMWeekdayMonday        |       0                   |       1
 kHMWeekdayTuesday       |       1                   |       2
 kHMWeekdayWednesday     |       2                   |       3
 kHMWeekdayThursday      |       3                   |       4
 kHMWeekdayFriday        |       4                   |       5
 kHMWeekdaySaturday      |       5                   |       6
 kHMWeekdaySunday        |       6                   |       7

 @param weekdayType 星期几
 @param format 格式符
 @return NSInteger
 */
+ (NSInteger)integerWithWeekdayType:(HMWeekDayType)weekdayType format:(HMWeekDayFormat)format;


/**
 调整旧版本数据库中的错误日期转成正确的公历日期

 @return 得到正确的公历年份日期
 */
- (NSDate *)adjustUnGregorianDate;
@end
