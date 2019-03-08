//  HMDBCurrentWeatherRecord.m
//  Created on 18/12/2017
//  Description 当前天气 Model

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBCurrentWeatherRecord.h"

@implementation HMDBCurrentWeatherRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        _weatherPublishTime = @"";
        _weatherType = 0;
        _temperature = 0;
        _temperatureUnit = @"";
        _recordUpdateTimeInterval = 0;
        _locationKey = @"";
    }
    
    return self;
}

@end
