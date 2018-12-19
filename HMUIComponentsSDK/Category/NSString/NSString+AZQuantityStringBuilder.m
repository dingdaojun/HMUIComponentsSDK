//
//  NSString+AZQuantityStringBuilder.m
//  MiFit
//
//  Created by dingdaojun on 15/12/25.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "NSString+AZQuantityStringBuilder.h"
#import <AZQuantity.h>

@implementation NSString (AZQuantityStringBuilder)

+ (NSString *)hm_roundedMinutesStringWithSeconds:(NSTimeInterval)seconds needToAppendUnit:(BOOL)needToAppendUnit {
    AZTimeQuantity *minuteQuantity = [AZTimeQuantity timeQuantityWithUnit:AZQuantityTimeUnitSecond value:seconds].minute;
    AZQuantityValue minute = minuteQuantity.round0Value;
    NSString *formatString = needToAppendUnit ? @"%ld分钟" : @"%ld";
    NSString *roundedMinutesString = [NSString stringWithFormat:formatString, (NSInteger)minute];
    return roundedMinutesString;
}

@end
