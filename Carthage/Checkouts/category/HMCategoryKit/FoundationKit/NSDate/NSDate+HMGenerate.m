//
//  NSDate+HMGenerate.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/16.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDate+HMGenerate.h"
#import "NSCalendar+HMGenerate.h"
#import "NSDateFormatter+HMGenerate.h"

NSInteger const HMSecondsInMinute = 60;
NSInteger const HMSecondsInHour   = 3600;
NSInteger const HMSecondsInDay    = 86400;
NSInteger const HMSecondsInWeek   = 604800;

/**yyyy-MM-dd HH:mm:ss*/
HMDateFormat HMDateFormatyyyy_MM_ddsHHcmmcss               = @"yyyy-MM-dd HH:mm:ss";
/**yyyy-MM-dd HH:mm*/
HMDateFormat HMDateFormatyyyy_MM_ddsHHcmm               = @"yyyy-MM-dd HH:mm";
/**yyyy-MM-dd*/
HMDateFormat HMDateFormatyyyy_MM_dd                     = @"yyyy-MM-dd";
/**dd-MM-yyyy*/
HMDateFormat HMDateFormatdd_MM_yyyy                     = @"dd-MM-yyyy";
/**yyyy-MM*/
HMDateFormat HMDateFormatyyyy_MM                        = @"yyyy-MM";
/**MM-dd*/
HMDateFormat HMDateFormatMM_dd                          = @"MM-dd";
/**dd-MM*/
HMDateFormat HMDateFormatdd_MM                          = @"dd-MM";
/**yyyy/MM/dd HH:mm*/
HMDateFormat HMDateFormatyyyybMMbddsHHcmm               = @"yyyy/MM/dd HH:mm";
/**yyyy/MM/dd*/
HMDateFormat HMDateFormatyyyybMMbdd                     = @"yyyy/MM/dd";
/**yyyy/MM*/
HMDateFormat HMDateFormatyyyybMM                        = @"yyyy/MM";
/**MM/dd HH:mm*/
HMDateFormat HMDateFormatMMbddsHHcmm                   = @"MM/dd HH:mm";
/**MM/dd*/
HMDateFormat HMDateFormatMMbdd                          = @"MM/dd";
/**HH:mm*/
HMDateFormat HMDateFormatHHcmm                          = @"HH:mm";
/**yyyy-MM-dd HH:mm a*/
HMDateFormat HMDateFormatyyyy_MM_ddsHHcmmsa             = @"yyyy-MM-dd HH:mm a";
/**HH:mm a*/
HMDateFormat HMDateFormatHHcmmsa                        = @"HH:mm a";


@implementation NSDate (HMGenerate)

#pragma mark 根据字符串创建NSDate，字符串格式必须与后面所选formate一致
+ (NSDate *)dateFromFormateString:(NSString *)dateString dateFormat:(HMDateFormat)dateFormat {
    if (!dateString) {
        NSLog(@"dateString can not be nil !!!");
        return nil;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter formatter];
    formatter.calendar = [NSCalendar gregorianCalendar];
    formatter.dateFormat = dateFormat;
    return [formatter dateFromString:dateString];
}

#pragma mark 根据字符串创建NSDate，字符串格式必须为: 2014-09-19
+ (NSDate *)dateFromFormateString:(NSString *)dateFormatString {
    return [NSDate dateFromFormateString:dateFormatString dateFormat:HMDateFormatyyyy_MM_dd];
}

#pragma mark 根据传入的时分创建NSDate
+ (NSDate *)dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    [components setMinute:minutes];

    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}
@end
