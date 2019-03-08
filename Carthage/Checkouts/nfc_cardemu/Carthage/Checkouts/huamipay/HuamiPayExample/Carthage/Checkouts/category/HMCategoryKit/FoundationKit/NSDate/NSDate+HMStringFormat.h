//
//  @fileName  NSDate+HMStringFormat.h
//  @abstract  NSDate转字符串
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSDate+HMGenerate.h"


@interface NSDate (HMStringFormat)


/**
 字符串 eg: 2019-10-19
 
 @return NSString
 */
- (NSString *)stringWithFormat_yyyyMMdd;

/**
 字符串 eg: 2019-10
 
 @return NSString
 */
- (NSString *)stringWithFormat_yyyyMM;

/**
 字符串 eg: 10-11
 
 @return NSString
 */
- (NSString *)stringWithFormat_MMdd;

/**
 根据日期格式，获取格式化字符串
 
 @param dateFormate HMDateFormat类型
 @return NSString
 */
- (NSString *)stringWithFormat:(HMDateFormat)dateFormate;


@end
