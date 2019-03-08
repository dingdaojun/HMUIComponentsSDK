//  HMDBWeatherEarlyWarningRecord.m
//  Created on 19/12/2017
//  Description 天气预警信息

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherEarlyWarningRecord.h"

@implementation HMDBWeatherEarlyWarningRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        _earlyWarningPublishTime = @"";
        _warningID = @"";
        _title = @"";
        _detail = @"";
        _recordUpdateTimeInterval = 0;
        _locationKey = @"";
    }
    
    return self;
}

@end
