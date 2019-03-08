//  HMWeatherSunRiseSet.h
//  Created on 2018/5/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import "HMWeatherProtocol.h"
@class HMWeatherForecastItem;

@interface HMWeatherSunRiseSet : NSObject <HMWeatherSunRiseSetItemProtocol>

- (instancetype)initWithForecast:(HMWeatherForecastItem *)forecastItem;
- (instancetype)initWithSunRiseItem:(NSDictionary *)sunRiseItem;

@end
