//
//  HMServiceAPIRunDataItem.m
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunDataItem.h"

@implementation HMServiceAPIRunDataItem

@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunCorrectAltitudeData)
- (NSDate *)api_runCorrectAltitudeDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (double)api_runCorrectAltitude
{
    return [self.value doubleValue];
}

@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunStrokeSpeedData)

- (NSDate *)api_runStrokeSpeedDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (double)api_runStrokeSpeed
{
    return [self.value doubleValue];
}

@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunCadenceData)
- (NSDate *)api_runCadenceDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (double)api_runCadence
{
    return [self.value doubleValue];
}
@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunHeartRateData)

- (NSDate *)api_runHeartRateDate {
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (NSUInteger)api_runHeartRate {
    return [self.value integerValue];
}

@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunDistanceData)
- (NSDate *)api_runDistanceDate {
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (NSUInteger)api_runDistance {
    return self.value.unsignedIntegerValue;
}
@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunPressureData)
- (NSDate *)api_runPressureDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (double)api_runPressure
{
    return [self.value doubleValue];
}
@end

@implementation HMServiceAPIRunDataItem (HMServiceAPIRunSpeedData)
- (NSDate *)api_runSpeedDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (double)api_runSpeed
{
    return [self.value doubleValue];
}

@end



