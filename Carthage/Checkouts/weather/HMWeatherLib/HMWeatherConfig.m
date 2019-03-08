//  HMWeatherConfig.m
//  Created on 2018/6/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherConfig.h"

@implementation HMWeatherConfig
{
    NSInteger _forecastUpdateHours;
    NSInteger _AqiUpdateHours;
    NSInteger _LocationUpdateDistances;
}

- (instancetype)initWithForecastUpdateHours:(NSInteger)forecastUpdateH
                             AQIUpdateHours:(NSInteger)AQIUpdateH
                  LocationKeyUpdateDistance:(NSInteger)updateDistance {
    self = [super init];
    if (self) {
        _forecastUpdateHours = forecastUpdateH;
        _AqiUpdateHours = AQIUpdateH;
        _LocationUpdateDistances = updateDistance;
    }
    return self;
}

#pragma mark - 返回各个配置更新时间间隔
- (NSInteger)forecastUpdateHours {
    return _forecastUpdateHours;
}

- (NSInteger)AQIUpdateHours {
    return _AqiUpdateHours;
}

- (NSInteger)LocationKeyUpdateDistance {
    return _LocationUpdateDistances;
}
@end
