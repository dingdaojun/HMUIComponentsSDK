//
//  NSArray+HMServiceAPIRunDetailEncode.m
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/6/21.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "NSArray+HMServiceAPIRunDetailEncode.h"
#import <CoreLocation/CoreLocation.h>
#import <objc_geohash/GeoHash.h>
#import "HMServiceApiRunProtocol.h"

@protocol HMServiceAPIRunData;
@protocol HMServiceAPIRunGPSData;


@implementation NSArray (HMServiceAPIRunDetailEncode)

- (NSString *)hm_stringByEncodingLongitudeAndLatitude
{
    NSMutableString *coordinateStr = [NSMutableString string];

    CLLocation *lastLocation = nil;
    for (id<HMServiceAPIRunGPSData> gpsData in self) {
        CLLocation *location = gpsData.api_runGPSDataLoction;

        long long latitude = location.coordinate.latitude * pow(10,8);
        long long longitude = location.coordinate.longitude * pow(10,8);

        if (lastLocation) {

            long long lastLatitude = lastLocation.coordinate.latitude * pow(10,8);
            long long lastLongitude = lastLocation.coordinate.longitude * pow(10,8);
            [coordinateStr appendFormat:@"%lld,%lld;",(latitude - lastLatitude),(longitude - lastLongitude)];
        }
        else {
            [coordinateStr appendFormat:@"%lld,%lld;",latitude,longitude];
        }

        lastLocation = location;
    }

    return coordinateStr;
}


- (NSString *)hm_stringByEncodingAccuracy
{
    NSMutableString *accuracyStr = [NSMutableString string];

    for (id<HMServiceAPIRunGPSData> gpsData in self) {
        CLLocation *location = gpsData.api_runGPSDataLoction;
        NSInteger accuracy = (NSInteger)location.horizontalAccuracy;
        [accuracyStr appendFormat:@"%d;", (int)accuracy];
    }
    
    return accuracyStr;
}

- (NSString *)hm_stringByEncodingAltitude
{
    NSMutableString *altitudeStr = [NSMutableString string];

    for (id<HMServiceAPIRunGPSData> gpsData in self) {
        CLLocation *location = gpsData.api_runGPSDataLoction;
        NSInteger altitude = (NSInteger)location.altitude * pow(10, 2);
        [altitudeStr appendFormat:@"%d;", (int)altitude];
    }

    return altitudeStr;
}

- (NSString *)hm_stringByEncodingTimeWithStartTime:(NSTimeInterval)startTime
{
    NSMutableString *timeStr = [NSMutableString string];

    id<HMServiceAPIRunGPSData> lastGpsData = nil;

    for (id<HMServiceAPIRunGPSData> gpsData in self) {

        NSTimeInterval time = [gpsData.api_runGPSDataLoction.timestamp timeIntervalSince1970];
        NSTimeInterval diffTime = 0;
        if (!lastGpsData) {
            diffTime = time - startTime;
        } else {
            NSTimeInterval lastTime = [lastGpsData.api_runGPSDataLoction.timestamp timeIntervalSince1970];
            diffTime = time - lastTime;
        }
        lastGpsData = gpsData;

        [timeStr appendFormat:@"%d;", (int)(diffTime > 0 ? diffTime : 0)];
    }

    return timeStr;
}

- (NSString *)hm_stringByEncodingPace
{
    NSMutableString *paceStr = [NSMutableString string];

    for (id<HMServiceAPIRunGPSData> gpsData in self) {
        double pace = gpsData.api_runGPSPace;
        [paceStr appendFormat:@"%.3f;",pace];
    }

    return paceStr;
}


- (NSString *)hm_stringByEncodingFlag;
{
    NSMutableString *flagStr = [NSMutableString string];

    for (id<HMServiceAPIRunGPSData> gpsData in self) {
        NSInteger flag = gpsData.api_runGPSFlag;
        [flagStr appendFormat:@"%d;", (int)flag];
    }

    return flagStr;
}


- (NSString *)hm_stringByEncodingPause
{
    NSMutableString *pauseStr = [NSMutableString string];

    for (id<HMServiceAPIRunPauseData> pauseData in self) {

        NSTimeInterval time = [pauseData.api_runPauseDate timeIntervalSince1970];

        [pauseStr appendFormat:@"%d,%d,%d,%d,%d;", (int)time, (int)pauseData.api_runPauseDuration, (int)pauseData.api_runPauseStartGpsIndex, (int)pauseData.api_runPauseEndGpsIndex, (int)pauseData.api_runPauseType];
    }

    return pauseStr;
}

- (NSString *)hm_stringByEncodingGaitWithStartTime:(NSTimeInterval)startTime
{
    NSMutableString *gaitStr = [NSMutableString string];

    id<HMServiceAPIRunGaitData> lastGaitData = nil;
    for (id<HMServiceAPIRunGaitData> gaitData in self) {
        long long diffTime = 0;
        NSInteger diffStepCount = 0;
        NSInteger stepLength = gaitData.api_runGaitStepLength;
        NSInteger stepCadence = gaitData.api_runGaitStepCadence;
        NSTimeInterval time = [gaitData.api_runGaitDate timeIntervalSince1970];

        if (!lastGaitData) {
            diffTime = time - startTime;
            diffStepCount = gaitData.api_runGaitStep;
        } else {
            NSTimeInterval lastTime = [lastGaitData.api_runGaitDate timeIntervalSince1970];
            diffTime = time - lastTime;
            diffStepCount = gaitData.api_runGaitStep - lastGaitData.api_runGaitStep;
        }

        lastGaitData = gaitData;
        [gaitStr appendFormat:@"%d,%d,%d,%d;", (int)diffTime, (int)diffStepCount, (int)stepLength, (int)stepCadence];
    }

    return gaitStr;
}

- (NSString *)hm_stringByEncodingDistanceWithStartTime:(NSTimeInterval)startTime
{
    NSMutableString *distanceStr = [NSMutableString string];

    id<HMServiceAPIRunDistanceData> lastDistanceData = nil;
    for (id<HMServiceAPIRunDistanceData> distanceData in self) {
        long long diffTime = 0;
        NSInteger diffDistance = 0;
        NSTimeInterval time = [distanceData.api_runDistanceDate timeIntervalSince1970];
        if (!lastDistanceData) {
            diffTime = time - startTime;
            diffDistance = distanceData.api_runDistance;
        } else {
            NSTimeInterval lastTime = [lastDistanceData.api_runDistanceDate timeIntervalSince1970];
            diffTime = time - lastTime;
            diffDistance = distanceData.api_runDistance - lastDistanceData.api_runDistance;
        }

        lastDistanceData = distanceData;
        [distanceStr appendFormat:@"%d,%d;", (int)diffTime, (int)diffDistance];
    }

    return distanceStr;
}

- (NSString *)hm_stringByEncodingHeartRateWithStartTime:(NSTimeInterval)startTime
{
    NSMutableString *heartRateStr = [NSMutableString string];

    id<HMServiceAPIRunHeartRateData> lastHearRateData = nil;
    for (id<HMServiceAPIRunHeartRateData> hearRateData in self) {
        long long diffTime = 0;
        NSInteger diffHeartRate = 0;
        NSTimeInterval time = [hearRateData.api_runHeartRateDate timeIntervalSince1970];
        if (!lastHearRateData) {
            diffTime = time - startTime;
            diffHeartRate = hearRateData.api_runHeartRate;
        } else {
            NSTimeInterval lastTime = [lastHearRateData.api_runHeartRateDate timeIntervalSince1970];
            diffTime = time - lastTime;
            diffHeartRate = hearRateData.api_runHeartRate - lastHearRateData.api_runHeartRate;
        }

        lastHearRateData = hearRateData;
        [heartRateStr appendFormat:@"%d,%d;", (int)diffTime, (int)diffHeartRate];
    }

    return heartRateStr;
}


- (NSString *)hm_stringByEncodingBarometerPressureWithStartTime:(NSTimeInterval)startTime
{
    NSMutableString *pressureStr = [NSMutableString string];

    id<HMServiceAPIRunPressureData> lastPressureData = nil;
    for (id<HMServiceAPIRunPressureData> pressureData in self) {

        long long diffTime = 0;
        double diffPressure = 0;
        NSTimeInterval time = [pressureData.api_runPressureDate timeIntervalSince1970];

        if (!lastPressureData) {
            diffTime = time - startTime;
            diffPressure = pressureData.api_runPressure;
        } else {
            NSTimeInterval lastTime = [lastPressureData.api_runPressureDate timeIntervalSince1970];
            diffTime = time - lastTime;
            diffPressure = pressureData.api_runPressure - lastPressureData.api_runPressure;
        }

        lastPressureData = pressureData;
        [pressureStr appendFormat:@"%d,%d;", (int)diffTime, (int)diffPressure];
    }

    return pressureStr;
}

- (NSString *)hm_stringByEncodingSpeedWithStartTime:(NSTimeInterval)startTime {
    NSMutableString *speedStr = [NSMutableString string];

    id<HMServiceAPIRunSpeedData> lastSpeedData = nil;
    for (id<HMServiceAPIRunSpeedData> speedData in self) {

        long long diffTime = 0;
        NSTimeInterval time = [speedData.api_runSpeedDate timeIntervalSince1970];

        if (!lastSpeedData) {
            diffTime = time - startTime;
        } else {
            NSTimeInterval lastTime = [lastSpeedData.api_runSpeedDate timeIntervalSince1970];
            diffTime = time - lastTime;
        }

        lastSpeedData = speedData;
        [speedStr appendFormat:@"%d, %0.2f;", (int)diffTime, (double)speedData.api_runSpeed];
    }

    return speedStr;
}

- (NSString *)hm_stringByEncodingKiloPace
{
    NSMutableString *kiloPaceStr = [NSMutableString string];

    for (id<HMServiceAPIRunPaceData> paceData in self) {

        NSInteger time = paceData.api_runPaceTime;
        NSInteger totleTime = paceData.api_runPaceTotalTime;
        
        CLLocationCoordinate2D coordinate = paceData.api_runPaceLocation;
        NSString *geoHash = [GeoHash hashForLatitude:coordinate.latitude longitude:coordinate.longitude length:10];
        
        NSInteger heartRate = paceData.api_runPaceHeartRate;
        NSInteger km = paceData.api_runPaceKilometer;
        NSInteger index = -1;

        [kiloPaceStr appendFormat:@"%d,%d,%@,%d,%d,%d;", (int)km, (int)time, geoHash, (int)index, (int)heartRate, (int)(totleTime)];
    }

    return kiloPaceStr;
}

- (NSString *)hm_stringByEncodingMilePace
{
    return [self hm_stringByEncodingKiloPace];
}

@end
