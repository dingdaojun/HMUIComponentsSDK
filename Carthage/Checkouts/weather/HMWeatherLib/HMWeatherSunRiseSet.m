//  HMWeatherSunRiseSet.m
//  Created on 2018/5/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherSunRiseSet.h"
#import "HMWeatherForecastItem.h"
@import HMCategory;

@implementation HMWeatherSunRiseSet
{
    HMWeatherForecastItem *_item;
    NSDictionary *_sunRiseDict;
}
- (instancetype)initWithForecast:(HMWeatherForecastItem *)forecastItem {
    self = [super init];
    if (self) {
        _item = forecastItem;
    }
    return self;
}

- (instancetype)initWithSunRiseItem:(NSDictionary *)sunRiseItem {
    self = [super init];
    if (self) {
        _sunRiseDict = sunRiseItem;
    }
    return self;
}

- (NSDate *)sunriseDate {
    if (_item) {
        return [NSDate dateFromFormateString:_item.sunRiseFromValue dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    }
    return [self dateFromWeatherTimeStr:[_sunRiseDict objectForKey:@"from"]];
}

- (NSDate *)sunsetDate {
    if (_item) {
        return [NSDate dateFromFormateString:_item.sunRiseToValue dateFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
    }
    return [self dateFromWeatherTimeStr:[_sunRiseDict objectForKey:@"to"]];
}

- (NSDate *)dateFromWeatherTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *destDate = [dateFormatter dateFromString:time];
    return destDate;
}

@end
