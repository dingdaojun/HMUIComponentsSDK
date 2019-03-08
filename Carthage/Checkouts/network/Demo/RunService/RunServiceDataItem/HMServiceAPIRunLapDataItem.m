//
//  HMServiceAPIRunLapDataItem.m
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunLapDataItem.h"

@implementation HMServiceAPIRunLapDataItem

- (id)init
{
    self = [super init];
    if (self) {
        self.lapIndex = 0;
        self.time = -1;
        self.distance = -1;
        self.averageHeartRate = -1;
        self.runTime = -1;
        self.altitude = 0;
        self.altitudeAscend = -1;
        self.altitudeDescend = -1;
        self.averagePace = 0;
        self.maxPace = 0;
        self.ascendDistance = -1;
        self.averageStrokeSpeed = -1;
        self.atrokeEfficiency = -1;
        self.strokeTime = -1;
        self.calorie = 0;
        self.averageFrequency = 0;
        self.averageCadence = 0;
        self.type = HMServiceAPIRunLapTypeManually;
        self.ropeSkippingCount = 0;
    }

    return self;
}

- (int)api_runLapIndex {
    return self.lapIndex;
}

- (NSDate *)api_runLapDate {
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (CLLocationDistance)api_runLapDistance {
    return self.distance;
}

- (CLLocationCoordinate2D)api_runLapLocation {
    return self.location;
}

- (int)api_runLapAverageHeartRate {
    return self.averageHeartRate;
}

- (NSTimeInterval)api_runLapRunTime {
    return self.runTime;
}

- (CLLocationDistance)api_runLapAltitude {
    return self.altitude;
}

- (CLLocationDistance)api_runLapAltitudeAscend {
    return self.altitudeAscend;
}

- (CLLocationDistance)api_runLapAltitudeDescend {
    return self.altitudeDescend;
}

- (double)api_runLapAveragePace {
    return self.averagePace;
}

- (double)api_runLapMaxPace {
    return self.maxPace;
}

- (CLLocationDistance)api_runLapAscendDistance {
    return self.ascendDistance;
}

- (NSInteger)api_runLapAverageStrokeSpeed {
    return self.averageStrokeSpeed;
}

- (NSInteger)api_runLapStrokeTime {
    return self.strokeTime;
}

- (NSInteger)api_runLapStrokeEfficiency {
    return self.atrokeEfficiency;
}

- (NSInteger)api_runLapCalorie {
    return self.calorie;
}

- (NSInteger)api_runLapAverageFrequency {
    return self.averageFrequency;
}

- (NSInteger)api_runLapAverageCadence {
    return self.averageCadence;
}

- (HMServiceAPIRunLapType)api_runLapType {
    return self.type;
}

- (NSInteger)api_runLapRopeSkippingCount {
    return self.ropeSkippingCount;
}

@end
