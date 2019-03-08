//  HMDBWeatherAQIRecord+Protocol.m
//  Created on 19/12/2017
//  Description HMDBWeatherAQIRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherAQIRecord+Protocol.h"

@implementation HMDBWeatherAQIRecord (Protocol)

- (instancetype)initWithProtocol:(id<HMDBWeatherAQIProtocol>)weatherAQI {
    self = [super init];
    if (self) {
        self.weatherAQIPublishTime = weatherAQI.dbWeatherAQIPublishTime;
        self.valueOfAQI = weatherAQI.dbValueOfAQI;
        long long milliSeconds = [weatherAQI.dbRecordUpdateTime timeIntervalSince1970] * 1000;
        self.recordUpdateTimeInterval = milliSeconds;
        self.locationKey = weatherAQI.dbLocationKey;
    }
    
    return self;
}

- (NSNumber *)dbIdentifier {
    return self.identifier;
}

- (NSString *)dbWeatherAQIPublishTime {
    return self.weatherAQIPublishTime;
}

- (NSInteger)dbValueOfAQI {
    return self.valueOfAQI;
}


- (NSDate *)dbRecordUpdateTime {
    double seconds = self.recordUpdateTimeInterval / 1000.0;

    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

- (NSString *)dbLocationKey {
    return self.locationKey;
}
@end
