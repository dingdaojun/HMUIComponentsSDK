//  HMDBWeatherForecastRecord+Protocol.m
//  Created on 19/12/2017
//  Description HMDBWeatherForecastRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherForecastRecord+Protocol.h"

@implementation HMDBWeatherForecastRecord (Protocol)

- (instancetype)initWithProtocol:(id<HMDBWeatherForecastProtocol>) weatherForecast {
    self = [super init];
    if (self) {
        self.forecastPublishTime = weatherForecast.dbForecastPublishTime;
        self.weatherFromValue = weatherForecast.dbWeatherFromValue;
        self.weatherToValue = weatherForecast.dbWeatherToValue;
        self.temperatureFromValue = weatherForecast.dbTemperatureFromValue;
        self.temperatureToValue = weatherForecast.dbTemperatureToValue;
        self.temperatureUnit = weatherForecast.dbTemperatureUnit;

        long long milliSeconds = [weatherForecast.dbRecordUpdateTime timeIntervalSince1970] * 1000;
        self.recordUpdateTimeInterval = milliSeconds;

        milliSeconds = [weatherForecast.dbForecastDateTime timeIntervalSince1970] * 1000;
        self.forecastDateTimeInterval = milliSeconds;
        
        self.sunriseDateString = weatherForecast.dbSunriseDateString;
        self.sunsetDateString = weatherForecast.dbSunsetDateString;
        self.locationKey = weatherForecast.dbLocationKey;
    }
    
    return self;
}

- (NSNumber *)dbIdentifier {
    return self.identifier;
}

- (NSString *)dbForecastPublishTime {
    return self.forecastPublishTime;
}

- (NSInteger)dbWeatherFromValue {
    return self.weatherFromValue;
}

- (NSInteger)dbWeatherToValue {
    return self.weatherToValue;
}


- (NSInteger)dbTemperatureFromValue {
    return self.temperatureFromValue;
}

- (NSInteger)dbTemperatureToValue {
    return self.temperatureToValue;
}


- (NSString *)dbTemperatureUnit {
    return self.temperatureUnit;
}

- (NSDate *)dbRecordUpdateTime {
    double seconds = self.recordUpdateTimeInterval / 1000.0;

    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

- (NSDate *)dbForecastDateTime {
    double seconds = self.forecastDateTimeInterval / 1000.0;
    
    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

- (NSString *)dbSunriseDateString {
    return self.sunriseDateString;
}

- (NSString *)dbSunsetDateString {
    return self.sunsetDateString;
}

- (NSString *)dbLocationKey {
    return self.locationKey;
}
@end
