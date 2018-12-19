//  NSCalendar+HMGenerate.m
//  Created on 2018/9/30
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

#import "NSCalendar+HMGenerate.h"
#import <objc/runtime.h>
#import "HMCategoryDefine.h"

HMLocaleName en_US = @"en_US";
HMLocaleName zh_Hans_CN = @"zh_Hans_CN";

@implementation NSCalendar (HMGenerate)
    
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        category_swizzling_exchangeClassMethod(self, @selector(calendarWithIdentifier:), @selector(swizzed_calendarWithIdentifier:));
    });
}

+ (instancetype)gregorianCalendar {
    return [self calendarWithIdentifier:NSCalendarIdentifierGregorian];
}

+ (instancetype)gregorianCalendarWithLocaleName:(HMLocaleName)localeName {
    NSCalendar *calendar = [self gregorianCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:localeName];
    return calendar;
}

+ (NSMutableDictionary<NSCalendarIdentifier, NSCalendar *> *)cacheCalendars {
    NSMutableDictionary<NSCalendarIdentifier, NSCalendar *> *cache = objc_getAssociatedObject(self, _cmd);
    if (cache) { return cache; }
    
    cache = [NSMutableDictionary<NSCalendarIdentifier, NSCalendar *> dictionaryWithCapacity:0];
    objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return cache;
}

+ (instancetype)swizzed_calendarWithIdentifier:(NSCalendarIdentifier)identifier {
    NSCalendar *calendar = [[self cacheCalendars] objectForKey:NSCalendarIdentifierGregorian];
    if (calendar) { return calendar; }
    calendar = [self swizzed_calendarWithIdentifier:identifier];
    calendar.locale = [NSLocale autoupdatingCurrentLocale];
    [[self cacheCalendars] setObject:calendar forKey:identifier];
    return calendar;
}
    
@end
