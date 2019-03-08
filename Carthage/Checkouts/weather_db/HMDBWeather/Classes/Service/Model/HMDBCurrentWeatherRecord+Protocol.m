//  HMDBCurrentWeatherRecord+Protocol.m
//  Created on 18/12/2017
//  Description HMDBCurrentWeatherRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBCurrentWeatherRecord+Protocol.h"

@implementation HMDBCurrentWeatherRecord (Protocol)

- (instancetype)initWithProtocol:(id<HMDBCurrentWeatherProtocol>)currentWeather {
    self = [super init];
    if (self) {
        self.weatherPublishTime = currentWeather.dbWeatherPublishTime;
        self.weatherType = currentWeather.dbWeatherType;
        self.temperature = currentWeather.dbTemperature;
        self.temperatureUnit = currentWeather.dbTemperatureUnit;

        long long milliSeconds = [currentWeather.dbRecordUpdateTime timeIntervalSince1970] * 1000;
        self.recordUpdateTimeInterval = milliSeconds;
        self.locationKey = currentWeather.dbLocationKey;
    }
    
    return self;
}

- (NSString *)dbWeatherPublishTime {
    return self.weatherPublishTime;
}

- (NSInteger)dbWeatherType {
    return self.weatherType;
}

- (NSInteger)dbTemperature {
    return self.temperature;
}


- (NSString *)dbTemperatureUnit {
    return self.temperatureUnit;
}

- (NSDate *)dbRecordUpdateTime {
    double seconds = self.recordUpdateTimeInterval / 1000.0;

    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

- (NSString *)dbLocationKey {
    return self.locationKey;
}

@end
