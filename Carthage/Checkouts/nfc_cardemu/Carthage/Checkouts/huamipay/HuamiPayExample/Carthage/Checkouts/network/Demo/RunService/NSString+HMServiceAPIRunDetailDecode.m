//
//  NSString+HMServiceAPIRunDetailDecode.m
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/7/3.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "NSString+HMServiceAPIRunDetailDecode.h"
#import <CoreLocation/CoreLocation.h>
#import "HMServiceAPIRunDataItem.h"
#import "HMServiceAPIRunLapDataItem.h"
#import "HMServiceAPIRunPauseDataItem.h"
#import "HMServiceAPIRunGPSDataItem.h"
#import "HMServiceAPIRunGaitDataItem.h"
#import <objc_geohash/GeoHash.h>

@implementation NSString (HMSport)

- (NSString *)hmSport_TrimEndsSemicolon{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
    return [self stringByTrimmingCharactersInSet:characterSet];
}

- (NSArray *)hmSport_ComponentsSeparatedBySemicolon{
    return [self hmSport_ComponentsSeparatedByString:@";"];
}

- (NSArray *)hmSport_ComponentsSeparatedByComma{
    return [self hmSport_ComponentsSeparatedByString:@","];
}

- (NSString *)hmSport_TrimEndsSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)hmSport_TrimAllSpace{
    return  [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *)hmSport_TrimSpecialCode{
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return string;
}

- (NSDictionary *)hmSport_StringToDictionaryError:(NSError **)error{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
    return dict;
}

#pragma mark - Private Methods
- (NSArray *)hmSport_ComponentsSeparatedByString:(NSString *)string{
    if (self.length > 0) {
        return [self componentsSeparatedByString:string];
    }
    return nil;
}
@end


@implementation NSString (HMServiceAPIRunDetailDecode)

#pragma mark - GPS
- (NSArray<id<HMServiceAPIRunGPSData>> *)hm_stringByDecodingGpsWithstartTime:(NSTimeInterval)startTime
                                                               timeEncodeStr:(NSString *)timeEncodeStr
                                                               paceEncodeStr:(NSString *)paceEncodeStr
                                                           altitudeEncodeStr:(NSString *)altitudeEncodeStr
                                                            GPSFlagEncodeStr:(NSString *)GPSFlagEncodeStr
                                                        GPSAccuracyEncodeStr:(NSString *)GPSAccuracyEncodeStr
{
    NSMutableArray *GPSDatas = [NSMutableArray array];
    NSArray *longitude_latitudeArray = [self hmSport_ComponentsSeparatedBySemicolon];
    NSArray *altitudeArray = [altitudeEncodeStr hmSport_ComponentsSeparatedBySemicolon];
    NSArray *timestampArray = [timeEncodeStr hmSport_ComponentsSeparatedBySemicolon];
    NSArray *accuracyArray = [GPSAccuracyEncodeStr hmSport_ComponentsSeparatedBySemicolon];
    NSArray *flagArray = [GPSFlagEncodeStr hmSport_ComponentsSeparatedBySemicolon];
    NSArray *paceArray = [paceEncodeStr hmSport_ComponentsSeparatedBySemicolon];

    HMServiceAPIRunGPSDataItem<HMServiceAPIRunGPSData> *lastItem = nil;
    for (NSInteger i = 0; i < [longitude_latitudeArray count]; i++) {

        HMServiceAPIRunGPSDataItem *item = [[HMServiceAPIRunGPSDataItem alloc] init];

        CLLocationCoordinate2D coordinate = [self decodeGPSWithLongitudeLatitudeEncodeStr:longitude_latitudeArray[i] lastItem:lastItem];

        CLLocationDistance altitude = -20000.0;
        if (i < [altitudeArray count]) {
            altitude = [self decodeGPSAltitudeWithEncodeStr:altitudeArray[i]];
        }

        CLLocationAccuracy accuracy = 0.0;
        if (i < [accuracyArray count]) {
            accuracy = [self decodeGPSAccuracyWithEncodeStr:accuracyArray[i]];
        }

        NSTimeInterval time = 0.0;
        if (i < [timestampArray count]) {
            time = [self decodeGPSTimeWithEncodeStr:timestampArray[i] lastItem:lastItem startTime:startTime];
        }
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                             altitude:altitude
                                                   horizontalAccuracy:accuracy
                                                     verticalAccuracy:0.0
                                                            timestamp:[NSDate dateWithTimeIntervalSince1970:time]];

        item.loction = location;
        if (i < [paceArray count]) {
            item.GPSPace = [self decodeGPSPaceWithPaceEncodeStr:paceArray[i]];
        }
        if (i < [flagArray count]) {
            item.GPSFlag = [self decodeGPSPaceWithPaceEncodeStr:flagArray[i]];
        }

        [GPSDatas addObject:item];
        lastItem = item;
    }


    return GPSDatas;
}

- (CLLocationCoordinate2D)decodeGPSWithLongitudeLatitudeEncodeStr:(NSString *)longitudeLatitudeEncodeStr lastItem:(HMServiceAPIRunGPSDataItem *)lastItem
{
    CLLocationDegrees latitude = 181.0;
    CLLocationDegrees longitude = 181.0;

    NSArray *coordinate2DArray = [longitudeLatitudeEncodeStr componentsSeparatedByString:@","];

    if ([coordinate2DArray count] != 2) {
        return CLLocationCoordinate2DMake(latitude, longitude);
    }

    latitude = [[coordinate2DArray firstObject] doubleValue] * pow(10,-8);;
    longitude = [[coordinate2DArray lastObject] doubleValue] * pow(10,-8);;

    if (lastItem) {
        latitude +=  lastItem.api_runGPSDataLoction.coordinate.latitude;
        longitude += lastItem.api_runGPSDataLoction.coordinate.longitude;
    }

    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (CLLocationDistance)decodeGPSAltitudeWithEncodeStr:(NSString *)altitudeEncodeStr
{
    if (!altitudeEncodeStr) {
        return 0.0;
    }

    return [altitudeEncodeStr doubleValue] * pow(10,-2);
}

- (double)decodeGPSPaceWithPaceEncodeStr:(NSString *)paceEncodeStr
{
    if (!paceEncodeStr) {
        return 0.0;
    }

    return [paceEncodeStr doubleValue];
}

- (NSInteger)decodeGPSFlagWithEncodeStr:(NSString *)flagEncodeStr
{
    if (!flagEncodeStr) {
        return 0;
    }

    return [flagEncodeStr integerValue];
}

- (CLLocationAccuracy)decodeGPSAccuracyWithEncodeStr:(NSString *)accuracyEncodeStr
{
    if (!accuracyEncodeStr) {
        return 0;
    }

    return [accuracyEncodeStr doubleValue];
}

- (NSTimeInterval)decodeGPSTimeWithEncodeStr:(NSString *)timeEncodeStr lastItem:(HMServiceAPIRunGPSDataItem *)lastItem startTime:(NSTimeInterval)startTime
{
    if (!timeEncodeStr) {
        return 0;
    }

    if (lastItem) {
        return [timeEncodeStr doubleValue] + [lastItem.loction.timestamp timeIntervalSince1970];
    }
    else {
        return [timeEncodeStr doubleValue] + startTime;
    }
}

#pragma mark - heart rate
- (NSArray<id<HMServiceAPIRunHeartRateData>> *)hm_stringByDecodingHeartRateWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:YES];
}

#pragma mark - distance
- (NSArray<id<HMServiceAPIRunDistanceData>> *)hm_stringByDecodingDistanceWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:YES];
}

#pragma mark - Pressure
- (NSArray<id<HMServiceAPIRunPressureData>> *)hm_stringByDecodingPressureWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:NO];
}

#pragma mark - Gait
- (NSArray<id<HMServiceAPIRunGaitData>> *)hm_stringByDecodingGaitWithStartTime:(NSTimeInterval)startTime
{
    NSArray *gaitArray = [self hmSport_ComponentsSeparatedBySemicolon];

    NSMutableArray *gaitDatas = [NSMutableArray array];
    NSInteger lastStep = 0;
    NSTimeInterval lastTime = startTime;

    for (NSString *str in gaitArray) {

        HMServiceAPIRunGaitDataItem *item = [self decodeGaitWithEncodeStr:str lastStep:lastStep lastTime:lastTime];
        if (!item) {
            continue;
        }
        [gaitDatas addObject:item];
        lastTime = item.time;
        lastStep = item.step;
    }

    return gaitDatas;
}

- (HMServiceAPIRunGaitDataItem *)decodeGaitWithEncodeStr:(NSString *)gaitEncodeStr lastStep:(NSInteger)lastStep lastTime:(NSTimeInterval)lastTime
{
    HMServiceAPIRunGaitDataItem *item = [[HMServiceAPIRunGaitDataItem alloc] init];
    NSArray *gaitArray = [gaitEncodeStr componentsSeparatedByString:@","];

    if ([gaitArray count] < 2) {
        return nil;
    }

    item.time = [gaitArray[0] doubleValue] + lastTime;
    item.step = [gaitArray[1] integerValue] + lastStep;

    if ([gaitArray count] < 4) {
        return item;
    }
    item.stepLength = [gaitArray[2] integerValue];
    item.stepCadence = [gaitArray[3] integerValue];

    return item;
}

#pragma mark - speed
- (NSArray<id<HMServiceAPIRunSpeedData>> *)hm_stringByDecodingSpeedWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:NO];
}

#pragma mark - Pause
- (NSArray<id<HMServiceAPIRunPauseData>> *)hm_stringByDecodingPause
{
    NSArray *pauseArray = [self hmSport_ComponentsSeparatedBySemicolon];
    NSMutableArray *pauseDatas = [NSMutableArray array];

    for (NSString *str in pauseArray) {

        HMServiceAPIRunPauseDataItem *item = [self decodePauseWithEncodeStr:str];
        if (!item) {
            continue;
        }
        [pauseDatas addObject:item];
    }

    return pauseDatas;
}

- (HMServiceAPIRunPauseDataItem *)decodePauseWithEncodeStr:(NSString *)paceEncodeStr
{
    HMServiceAPIRunPauseDataItem *item = [[HMServiceAPIRunPauseDataItem alloc] init];
    NSArray *pauseArray = [paceEncodeStr componentsSeparatedByString:@","];

    if ([pauseArray count] < 5) {
        return nil;
    }

    item.time = [pauseArray[0] integerValue];
    item.duration = [pauseArray[1] doubleValue];
    item.startGpsIndex = [pauseArray[2] integerValue];
    item.endGpsIndex = [pauseArray[3] integerValue];
    item.type = [pauseArray[4] integerValue];

    return item;
}


#pragma mark - Pace
- (NSArray<id<HMServiceAPIRunPaceData>> *)hm_stringByDecodingPace
{
    NSArray *paceArray = [self hmSport_ComponentsSeparatedBySemicolon];
    NSMutableArray *paceDatas = [NSMutableArray array];
    HMServiceAPIRunPaceDataItem *lastItem = nil;
    for (NSString *str in paceArray) {

        HMServiceAPIRunPaceDataItem *item = [self decodePaceWithEncodeStr:str];
        if (!item) {
            continue;
        }
        [paceDatas addObject:item];

        lastItem = item;
    }

    return paceDatas;
}

- (HMServiceAPIRunPaceDataItem *)decodePaceWithEncodeStr:(NSString *)paceEncodeStr {
    HMServiceAPIRunPaceDataItem *item = [[HMServiceAPIRunPaceDataItem alloc] init];
    NSArray *paceArray = [paceEncodeStr componentsSeparatedByString:@","];

    if ([paceArray count] < 6) {
        return nil;
    }
    
    item.kilometer = [paceArray[0] integerValue];
    item.time = [paceArray[1] doubleValue];
    
    NSString *geoHash = paceArray[2];
    GHArea *area =[GeoHash areaForHash:geoHash];
    CLLocationDegrees latitude = ([area.latitude.min floatValue] + [area.latitude.max floatValue])/2.0;
    CLLocationDegrees longitude = ([area.longitude.min floatValue] + [area.longitude.max floatValue])/2.0;
    item.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    item.heartRate = [paceArray[4] integerValue];
    item.totalTime = [paceArray[5] integerValue];

    return item;
}

#pragma mark - lap
- (NSArray<id<HMServiceAPIRunLapData>> *)hm_stringByDecodingLapWithStartTime:(NSTimeInterval)startTime {
    NSArray *lapArray = [self hmSport_ComponentsSeparatedBySemicolon];
    NSMutableArray *lapDatas = [NSMutableArray array];

    HMServiceAPIRunLapDataItem *lastItem = nil;
    for (NSString *str in lapArray) {

        HMServiceAPIRunLapDataItem *item = [self decodeLapWithEncodeStr:str startTime:startTime];
        if (!item) {
            continue;
        }
        [lapDatas addObject:item];
        lastItem = item;
    }

    return lapDatas;
}

- (HMServiceAPIRunLapDataItem *)decodeLapWithEncodeStr:(NSString *)lapEncodeStr
                                             startTime:(NSTimeInterval)startTime {
    HMServiceAPIRunLapDataItem *item = [[HMServiceAPIRunLapDataItem alloc] init];
    NSArray *paceArray = [lapEncodeStr componentsSeparatedByString:@","];

    if ([paceArray count] < 9) {
        return nil;
    }

    item.lapIndex = [paceArray[0] intValue];
    item.runTime = [paceArray[1] doubleValue];
    item.distance = [paceArray[2] doubleValue];
    NSString *geoHash = paceArray[3];
    GHArea *area = [GeoHash areaForHash:geoHash];
    CLLocationDegrees latitude = ([area.latitude.min floatValue] + [area.latitude.max floatValue])/2.0;
    CLLocationDegrees longitude = ([area.longitude.min floatValue] + [area.longitude.max floatValue])/2.0;
    item.location = CLLocationCoordinate2DMake(latitude, longitude);
    item.averageHeartRate = [paceArray[4] intValue];
    item.time = [paceArray[5] doubleValue] + startTime;
    item.altitude = [paceArray[6] doubleValue];
    item.altitudeAscend = [paceArray[7] doubleValue];
    item.altitudeDescend = [paceArray[8] doubleValue];

    if ([paceArray count] < 19) {
        return item;
    }

    item.averagePace = [paceArray[9] doubleValue];
    item.maxPace = [paceArray[10] doubleValue];
    item.ascendDistance = [paceArray[11] doubleValue];
    item.averageStrokeSpeed = [paceArray[12] integerValue];
    item.strokeTime = [paceArray[13] integerValue];
    item.atrokeEfficiency = [paceArray[14] integerValue];
    item.calorie = [paceArray[15] integerValue];
    item.averageFrequency = [paceArray[16] integerValue];
    item.averageCadence = [paceArray[17] integerValue];
    item.type = [paceArray[18] integerValue];

    return item;
}

- (NSArray<id<HMServiceAPIRunCorrectAltitudeData>> *)hm_stringByDecodingCorrectAltitudeWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:NO];
}

- (NSArray<id<HMServiceAPIRunStrokeSpeedData>> *)hm_stringByDecodingStrokeSpeedWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:NO];
}

- (NSArray<id<HMServiceAPIRunCadenceData>> *)hm_stringByDecodingCadenceWithStartTime:(NSTimeInterval)startTime
{
    return [self hm_stringByDecodingWithStartTime:startTime isDataDifference:NO];
}

#pragma mark - 公有方法
#pragma mark - 时间戳为差值方法
- (NSArray<HMServiceAPIRunDataItem *> *)hm_stringByDecodingWithStartTime:(NSTimeInterval)startTime isDataDifference:(BOOL)isDataDifference
{
    NSArray *dataArray = [self hmSport_ComponentsSeparatedBySemicolon];
    NSMutableArray *dataDatas = [NSMutableArray array];
    NSTimeInterval lastTime = startTime;
    NSNumber *lastData = @(0);
    for (NSString *str in dataArray) {

        HMServiceAPIRunDataItem *item = [self decodeWithEncodeStr:str lastTime:lastTime lastData:lastData];
        if (!item) {
            continue;
        }
        [dataDatas addObject:item];
        lastTime = item.time;
        if (isDataDifference) {
            lastData = item.value;
        }
    }

    return dataDatas;
}

- (HMServiceAPIRunDataItem *)decodeWithEncodeStr:(NSString *)encodeStr lastTime:(NSTimeInterval)lastTime lastData:(NSNumber *)lastData
{
    HMServiceAPIRunDataItem *item = [[HMServiceAPIRunDataItem alloc] init];
    NSArray *dataArray = [encodeStr componentsSeparatedByString:@","];

    if ([dataArray count] < 2) {
        return nil;
    }

    item.time = [[dataArray firstObject] doubleValue] + lastTime;
    item.value = @([[dataArray lastObject] doubleValue] + lastData.doubleValue);

    return item;
}



@end













