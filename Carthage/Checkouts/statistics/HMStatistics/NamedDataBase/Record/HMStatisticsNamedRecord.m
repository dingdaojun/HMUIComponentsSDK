//  HMStatisticsNamedRecord.m
//  Created on 2018/4/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsNamedRecord.h"

@implementation HMStatisticsNamedRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventID = @"";
        _huamiID = @"";
        
        // 时间戳处理
        long long milliSeconds = [[NSDate date] timeIntervalSince1970] * 1000; // 毫秒数
        _eventTimestamp = milliSeconds;

        // 时区处理
        NSInteger sysOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
        NSInteger timeZoneKey = [self calTimeZoneKey:sysOffset];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        long long milSeconds = [timeZone daylightSavingTimeOffset] * 1000;
        _eventTimeZone = [NSString stringWithFormat:@"%ld,%lld",(long)timeZoneKey, milSeconds];

        _stringValue = @"";
        _eventType = @"";
        _eventParams = @"";
    }

    return self;
}

- (NSInteger)calTimeZoneKey:(NSInteger)rawOffset {
    NSInteger offset = rawOffset / 60;  //  /1000
    NSInteger flag = offset < 0 ? -1 : 1;
    offset = ABS(offset);
    NSInteger h = offset / 60;
    NSInteger m = offset % 60;

    return (h * 4 + m / 15) * flag;
}

@end
