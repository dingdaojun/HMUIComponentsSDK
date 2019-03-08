//
//  NSString+HMServiceAPIRunDailyPerformanceInfoData.m
//  HMServiceAPI+Run
//
//  Created by 李宪 on 7/12/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSString+HMServiceAPIRunDailyPerformanceInfoData.h"
#import <HMService/HMService.h>

@implementation NSString (HMServiceAPIRunDailyPerformanceInfoData)

/**
 *  @brief  体能状态信息第几公里
 */
- (double)api_runDailyPerformanceInfoKilometer {
    NSArray *components = [self componentsSeparatedByString:@","];
    if (components.count != 2) {
        return 0.f;
    }

    return [components[0] doubleValue];
}

/**
 *  @brief  体能状态信息 (有效区间[-20,20])
 */
- (double)api_runDailyPerformanceInfo {
    NSArray *components = [self componentsSeparatedByString:@","];
    if (components.count != 2) {
        return 0.f;
    }

    return [components[1] doubleValue];
}

@end
