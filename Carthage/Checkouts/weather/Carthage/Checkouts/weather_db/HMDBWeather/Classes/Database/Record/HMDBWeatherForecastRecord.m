//  HMDBWeatherForecastRecord.m
//  Created on 19/12/2017
//  Description 天气预报数据库记录

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherForecastRecord.h"

@implementation HMDBWeatherForecastRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        _forecastPublishTime = @"";
        _weatherFromValue = 0;
        _weatherToValue = 0;
        _temperatureFromValue = 0;
        _temperatureToValue = 0;
        _temperatureUnit = @"";
        _recordUpdateTimeInterval = 0;
        _forecastDateTimeInterval = 0;
        _sunriseDateString = @"";
        _sunsetDateString = @"";
        _locationKey = @"";
    }
    
    return self;
}

@end
