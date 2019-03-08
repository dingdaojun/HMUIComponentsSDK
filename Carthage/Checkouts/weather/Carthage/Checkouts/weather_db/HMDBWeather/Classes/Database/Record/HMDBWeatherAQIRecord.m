//  HMDBWeatherAQIRecord.m
//  Created on 19/12/2017
//  Description 空气质量 Model

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherAQIRecord.h"

@implementation HMDBWeatherAQIRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        _weatherAQIPublishTime = @"";
        _valueOfAQI = 0;
        _recordUpdateTimeInterval = 0;
        _locationKey = @"";
    }
    
    return self;
}

@end
