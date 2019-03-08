//
//  NSTimeZone+HMServiceAPI.m
//  HMNetworkLayer
//
//  Created by 李宪 on 2/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSTimeZone+HMServiceAPI.h"

@implementation NSTimeZone (HMServiceAPI)

- (NSInteger)hms_offset {
    
    NSInteger offset = self.secondsFromGMT;
    NSInteger flag = offset < 0 ? -1 : 1;
    
    offset = labs(offset);
    NSInteger hour = offset / 60 / 60;
    NSInteger minute = offset / 60 % 60;
    return (hour * 4 + minute / 15) * flag;
}

+ (instancetype)hms_timeZoneWithOffset:(NSInteger)offset {
    if (offset == -128){
        offset = 28800;
    }
    
    int flag = offset < 0 ? -1 : 1;
    offset = labs(offset);
    
    NSInteger h = offset / 4;
    NSInteger m = (offset % 4) * 15;
    NSInteger seconds = (h * 60 + m) * 60 * flag;
    return [NSTimeZone timeZoneForSecondsFromGMT:seconds];
}

@end
