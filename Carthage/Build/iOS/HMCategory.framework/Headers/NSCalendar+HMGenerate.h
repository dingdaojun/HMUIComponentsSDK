//  NSCalendar+HMGenerate.h
//  Created on 2018/9/30
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *HMLocaleName NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT HMLocaleName en_US;
FOUNDATION_EXPORT HMLocaleName zh_Hans_CN;

@interface NSCalendar (HMGenerate)

/**
 格林乔治日历
 locale为autoupdating
 @return - Calendar
 */
+ (instancetype)gregorianCalendar;

/**
 格林乔治日历

 @param localeName 区域名称
 @return - Calendar
 */
+ (instancetype)gregorianCalendarWithLocaleName:(HMLocaleName)localeName;

@end

NS_ASSUME_NONNULL_END
