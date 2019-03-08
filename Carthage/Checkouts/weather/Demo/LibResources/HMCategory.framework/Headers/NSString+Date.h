//
//  NSString+Date.h
//  HMCategorySourceCodeExample
//
//  Created by zhanggui on 2017/10/19.
//  Copyright © 2017年 华米科技. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface NSString (Date)


/**
 当前字符串年份是否是否是公历格式

 @return BOOL,字符串格式非yyyy-MM-dd或年份数据异常，都返回false
 */
- (BOOL)isGregorianDateString;

/**
 用于数据库层切换日历生成的错误日期数据转成正确公元纪年方法
 -【旧版错误数据格式均为yyyy-MM-dd]

 日本历法 = 公元纪年 - 1988
 佛历 = 公元纪年 + 543

 @return NSDate (公元制)，如果字符串不符合yyyy-MM-dd日期格式，返回nil
 */
- (NSDate *)unGregorianDateStringToDate;

@end
