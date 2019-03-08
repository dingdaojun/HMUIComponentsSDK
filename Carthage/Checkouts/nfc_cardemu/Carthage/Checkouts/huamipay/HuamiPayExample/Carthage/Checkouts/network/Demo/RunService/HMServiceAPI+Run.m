//
//  HMServiceAPI+Run.m
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/4/21.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Run.h"
#import <objc/runtime.h>
#import <HMNetworkLayer/HMNetworkLayer.h>
#import "NSArray+HMServiceAPIRunDetailEncode.h"
#import "NSString+HMServiceAPIRunDetailDecode.h"
#import "NSString+HMServiceAPIRunDailyPerformanceInfoData.h"


static HMServiceAPIRunSourceType runSourceTypeWithString(NSString *string) {
    NSDictionary *map = @{@"run.mifit.huami.com" : @(HMServiceAPIRunSourceTypeMifit),
                          @"run.midong.huami.com" : @(HMServiceAPIRunSourceTypeMiDong),
                          @"run.chaohu.huami.com" : @(HMServiceAPIRunSourceTypeChaohu),
                          @"run.tempo.huami.com" : @(HMServiceAPIRunSourceTypeTempo),
                          @"run.watch.huami.com" : @(HMServiceAPIRunSourceTypeWatchHuanghe),
                          @"run.watch.everest.huami.com" : @(HMServiceAPIRunSourceTypeWatchEverest),
                          @"run.watch.everests.huami.com" : @(HMServiceAPIRunSourceTypeWatchEverest2S),
                          @"run.wuhan.huami.com" : @(HMServiceAPIRunSourceTypeWuhan),
                          @"run.beats.huami.com" : @(HMServiceAPIRunSourceTypeBeats),
                          @"run.beatsp.huami.com" : @(HMServiceAPIRunSourceTypeBeatsp),
                          @"run.chongqing.huami.com" : @(HMServiceAPIRunSourceTypeChongqing),
                          @"run.watch.qogir.huami.com" : @(HMServiceAPIRunSourceTypeWatchQogir),
                          };
    return [map[string] integerValue];
}

static NSString *stringWithRunSourceType(HMServiceAPIRunSourceType type) {
    switch (type) {
        case HMServiceAPIRunSourceTypeMifit: return @"run.mifit.huami.com";
        case HMServiceAPIRunSourceTypeMiDong: return @"run.midong.huami.com";
        case HMServiceAPIRunSourceTypeChaohu: return @"run.chaohu.huami.com";
        case HMServiceAPIRunSourceTypeTempo: return @"run.tempo.huami.com";
        case HMServiceAPIRunSourceTypeWatchHuanghe: return @"run.watch.huami.com";
        case HMServiceAPIRunSourceTypeWatchEverest: return @"run.watch.everest.huami.com";
        case HMServiceAPIRunSourceTypeWatchEverest2S: return @"run.watch.everests.huami.com";
        case HMServiceAPIRunSourceTypeWuhan: return @"run.wuhan.huami.com";
        case HMServiceAPIRunSourceTypeBeats: return @"run.beats.huami.com";
        case HMServiceAPIRunSourceTypeBeatsp: return @"run.beatsp.huami.com";
        case HMServiceAPIRunSourceTypeChongqing: return @"run.chongqing.huami.com";
        case HMServiceAPIRunSourceTypeWatchQogir: return @"run.watch.qogir.huami.com";
    }
}

#pragma mark -- HELP

@implementation HMServiceJSONValue (RunStatRunType)

- (NSUInteger)runStatRunType {
    NSUInteger runStatRunType = self.number.unsignedIntegerValue;
    if (runStatRunType > 1000 && runStatRunType < 2000) {
        runStatRunType = runStatRunType % 1000;

    }
    return runStatRunType;
}

@end

@interface NSDictionary (HMServiceAPIRunData) <HMServiceAPIRunData>
@end

@implementation NSDictionary (HMServiceAPIRunData)

- (NSString *)api_runDataTrackID {
    return self.hmjson[@"trackid"].string;
}

- (HMServiceAPIRunSourceType)api_runDataSourceType {
    NSString *source = self.hmjson[@"source"].string;
    return runSourceTypeWithString(source);
}

- (NSUInteger)api_runDataVersion {
    return self.hmjson[@"version"].number.unsignedIntegerValue;
}

- (NSDate *)api_runStartTime {
    return self.hmjson[@"trackid"].date;
}

@end


@interface NSDictionary (HMServiceAPIRunDetailData) <HMServiceAPIRunDetailData>
@end

@implementation NSDictionary (HMServiceAPIRunDetailData)

- (NSArray<id<HMServiceAPIRunGPSData>> *)api_runDetailDataGps {
    
    NSArray *calculatedGpsInfos = objc_getAssociatedObject(self, "api_calculateGpsInfos");
    
    if (calculatedGpsInfos) {
        return calculatedGpsInfos;
    }
    
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *longitudeLatitudeEncodeStr = self.hmjson[@"longitude_latitude"].string;
    
    NSString *timeEncodeStr = self.hmjson[@"time"].string;
    NSString *paceEncodeStr = self.hmjson[@"pace"].string;
    NSString *altitudeEncodeStr = self.hmjson[@"altitude"].string;
    NSString *GPSFlagEncodeStr = self.hmjson[@"flag"].string;
    NSString *GPSAccuracyEncodeStr = self.hmjson[@"accuracy"].string;
    
    calculatedGpsInfos = [longitudeLatitudeEncodeStr hm_stringByDecodingGpsWithstartTime:startTime
                                                                           timeEncodeStr:timeEncodeStr
                                                                           paceEncodeStr:paceEncodeStr
                                                                       altitudeEncodeStr:altitudeEncodeStr
                                                                        GPSFlagEncodeStr:GPSFlagEncodeStr
                                                                    GPSAccuracyEncodeStr:GPSAccuracyEncodeStr];
    
    if (!calculatedGpsInfos) {
        return nil;
    }
    
    objc_setAssociatedObject(self, "api_calculateGpsInfos", calculatedGpsInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return calculatedGpsInfos;
}

- (NSArray<id<HMServiceAPIRunHeartRateData>> *)api_runDetailDataHeartRate {
    
    NSArray *calculatedHeartRates = objc_getAssociatedObject(self, "api_calculateHeartRates");
    if (calculatedHeartRates) {
        return calculatedHeartRates;
    }
    
    NSTimeInterval startTime = self.hmjson[@"trackid"].doubleValue;
    NSString *heartRateEncodeStr = self.hmjson[@"heart_rate"].string;
    calculatedHeartRates = [heartRateEncodeStr hm_stringByDecodingHeartRateWithStartTime:startTime];
    
    if (!calculatedHeartRates) {
        return nil;
    }
    
    objc_setAssociatedObject(self, "api_calculateHeartRates", calculatedHeartRates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return calculatedHeartRates;
}

- (NSArray<id<HMServiceAPIRunDistanceData>> *)api_runDetailDataDistance {
    
    NSArray *calculatedDistances = objc_getAssociatedObject(self, "api_calculateDistances");
    if (calculatedDistances) {
        return calculatedDistances;
    }
    
    NSTimeInterval startTime = self.hmjson[@"trackid"].doubleValue;
    NSString *distanceEncodeStr = self.hmjson[@"distance"].string;
    calculatedDistances = [distanceEncodeStr hm_stringByDecodingDistanceWithStartTime:startTime];
    
    if (!calculatedDistances) {
        return nil;
    }
    
    objc_setAssociatedObject(self, "api_calculateDistances", calculatedDistances, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return calculatedDistances;
}

- (NSArray<id<HMServiceAPIRunGaitData>> *)api_runDetailDataGait {
    NSTimeInterval startTime = self.hmjson[@"trackid"].doubleValue;
    NSString *gaitEncodeStr = self.hmjson[@"gait"].string;
    
    return [gaitEncodeStr hm_stringByDecodingGaitWithStartTime:startTime];
}

- (NSArray<id<HMServiceAPIRunPressureData>> *)api_runDetailDataPressure {
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *pressureEncodeStr = self.hmjson[@"air_pressure_altitude"].string;
    
    return [pressureEncodeStr hm_stringByDecodingPressureWithStartTime:startTime];
}

- (NSArray<id<HMServiceAPIRunPauseData>> *)api_runDetailDataPause {
    NSString *pauseEncodeStr = self.hmjson[@"pause"].string;
    return [pauseEncodeStr hm_stringByDecodingPause];
}

- (NSArray<id<HMServiceAPIRunPaceData>> *)api_runDetailDataKiloPace {
    
    NSString *kilopaceEncodeStr = self.hmjson[@"kilo_pace"].string;
    NSArray *calculatedKiloPaces = [kilopaceEncodeStr hm_stringByDecodingPace];
    
    if (calculatedKiloPaces && [calculatedKiloPaces count] > 0) {
        
        NSArray<id<HMServiceAPIRunDistanceData>> *distanceDatas = [self api_runDetailDataDistance];
        if (distanceDatas.count > 0) {
            
            id<HMServiceAPIRunDistanceData> distanceData = [distanceDatas lastObject];
            NSInteger kilo = distanceData.api_runDistance / 1000;
            id<HMServiceAPIRunPaceData> kiloPace = [calculatedKiloPaces lastObject];
            
            if (kilo <= kiloPace.api_runPaceKilometer + 1) {
                return calculatedKiloPaces;
            }
        }
        else {
            return calculatedKiloPaces;
        }
    }
    
    calculatedKiloPaces = objc_getAssociatedObject(self, "api_calculateMileagePacesInKilometer");
    if (calculatedKiloPaces) {
        return calculatedKiloPaces;
    }
    
    [self api_calculateMileagePaces];
    calculatedKiloPaces = objc_getAssociatedObject(self, "api_calculateMileagePacesInKilometer");
    if (calculatedKiloPaces) {
        return calculatedKiloPaces;
    }
    
    calculatedKiloPaces = [self rebuildMileStone:YES gpsDatas:[self api_runDetailDataGps]];
    if (!calculatedKiloPaces) {
        return nil;
    }
    
    return calculatedKiloPaces;
}

- (NSArray<id<HMServiceAPIRunPaceData>> *)api_runDetailDataMilePace {
    
    NSString *milePaceEncodeStr = self.hmjson[@"mile_pace"].string;
    NSArray *calculatedMilePaces = [milePaceEncodeStr hm_stringByDecodingPace];
    
    if (calculatedMilePaces && [calculatedMilePaces count] > 0) {
        
        NSArray<id<HMServiceAPIRunDistanceData>> *distanceDatas = [self api_runDetailDataDistance];
        if (distanceDatas.count > 0) {
            
            id<HMServiceAPIRunDistanceData> distanceData = [distanceDatas lastObject];
            NSInteger mile = distanceData.api_runDistance / 1609.344;
            id<HMServiceAPIRunPaceData> milePace = [calculatedMilePaces lastObject];
            
            if (mile <= milePace.api_runPaceKilometer + 1) {
                return calculatedMilePaces;
            }
        }
        else {
            return calculatedMilePaces;
        }
    }
    
    calculatedMilePaces = objc_getAssociatedObject(self, "api_calculateMileagePacesInMile");
    if (calculatedMilePaces) {
        return calculatedMilePaces;
    }
    
    [self api_calculateMileagePaces];
    calculatedMilePaces = objc_getAssociatedObject(self, "api_calculateMileagePacesInMile");
    if (calculatedMilePaces) {
        return calculatedMilePaces;
    }
    
    calculatedMilePaces = [self rebuildMileStone:NO gpsDatas:[self api_runDetailDataGps]];
    if (!calculatedMilePaces) {
        return nil;
    }
    
    return calculatedMilePaces;
}

- (NSArray<id<HMServiceAPIRunLapData>> *)api_runDetailDataLap {
    
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *lapEncodeStr = self.hmjson[@"lap"].string;
    return  [lapEncodeStr hm_stringByDecodingLapWithStartTime:startTime];
}

#pragma 很老的还原公里（英里）数据
- (NSArray *)rebuildMileStone:(BOOL)isKilo gpsDatas:(NSArray<id<HMServiceAPIRunGPSData>> *)gpsDatas
{
    float totleDistance = 0.f;
    float sectionDistance = 0.f;
    
    int totleTime = 0;
    int sectionTime = 0;
    
    NSTimeInterval lastTime = 0.0;
    CLLocation *lastLocation = nil;
    NSMutableArray *kiloPaces = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [gpsDatas count]; i++) {
        
        id<HMServiceAPIRunGPSData> gpsData = [gpsDatas objectAtIndex:i];
        //        if (gpsData.api_runGPSFlag != HMServiceAPIRunGPSFlagNormal) {
        //            continue;
        //        }
        
        if (!lastLocation) {
            lastLocation = gpsData.api_runGPSDataLoction;
            continue;
        }
        
        CLLocation *location = gpsData.api_runGPSDataLoction;
        float distance = [location distanceFromLocation:lastLocation];
        
        int interval = [location.timestamp timeIntervalSinceDate:lastLocation.timestamp];
        if (distance > 200 && interval > 60) {
            lastLocation = location;
            continue;
        }
        
        if ([self isDistanceMoreThanOneUnit:sectionDistance + distance isKilo:isKilo]) {
            NSLog(@"new section");
            
            float oneUnitDistance = [self oneUnitDistance:isKilo];
            
            float leftdistance =  oneUnitDistance - sectionDistance;
            int leftTime = leftdistance*interval/distance;
            
            sectionTime += interval - leftTime;
            
            
            totleTime += sectionTime;
            totleDistance += oneUnitDistance;
            
            if (sectionTime>0 && oneUnitDistance>0.1) {
                
                HMServiceAPIRunPaceDataItem *kiloPaceItem = [[HMServiceAPIRunPaceDataItem alloc] init];
                kiloPaceItem.kilometer = [kiloPaces count];
                kiloPaceItem.totalTime = totleTime;
                kiloPaceItem.time = totleTime - lastTime;
                kiloPaceItem.coordinate = location.coordinate;
                [kiloPaces addObject:kiloPaceItem];
                lastTime = totleTime;
            }
            else{
                NSLog(@"new section error value sectionTime:%d oneUnitDistance:%f",sectionTime,oneUnitDistance);
            }
            
            leftdistance = distance - leftdistance;
            while (leftdistance > oneUnitDistance) {
                
                int oneUnitTime = oneUnitDistance*leftTime/leftdistance;
                
                totleTime += oneUnitTime;
                totleDistance += oneUnitDistance;
                
                if (oneUnitTime>0 && oneUnitDistance>0.1) {
                    
                    HMServiceAPIRunPaceDataItem *kiloPaceItem = [[HMServiceAPIRunPaceDataItem alloc] init];
                    kiloPaceItem.kilometer = [kiloPaces count];
                    kiloPaceItem.totalTime = totleTime;
                    kiloPaceItem.time = totleTime - lastTime;
                    kiloPaceItem.coordinate = location.coordinate;
                    [kiloPaces addObject:kiloPaceItem];
                    lastTime = totleTime;
                }
                else{
                    NSLog(@"long section error value oneUnitTime:%d oneUnitDistance:%f",oneUnitTime,oneUnitDistance);
                }
                
                leftdistance = leftdistance - oneUnitDistance;
                leftTime = leftTime - oneUnitTime;
            }
            
            sectionTime = leftTime;
            sectionDistance = leftdistance;
            lastLocation = location;
            
        }
        else{
            sectionTime += interval;
            
            sectionDistance += distance;
            
            lastLocation = location;
        }
    }
    
    return kiloPaces;
}

- (BOOL)isDistanceMoreThanOneUnit:(CGFloat)distance isKilo:(BOOL)isKilo{
    CGFloat oneUnitDis = [self oneUnitDistance:isKilo];
    if (distance > oneUnitDis) {
        return YES;
    } else {
        return NO;
    }
}

- (CGFloat)oneUnitDistance:(BOOL)isKilo{
    
    if (isKilo) {
        return 1000.0f;
    } else {
        return 1609.344;
    }
}

#pragma 精准还原公里（英里）数据
- (void)api_calculateMileagePaces {
    
    NSMutableArray *kiloPaces = [NSMutableArray array];
    NSMutableArray *milePaces = [NSMutableArray array];
    
    NSMutableArray *kiloPaceDistance = [NSMutableArray array];
    NSMutableArray *milePaceDistance = [NSMutableArray array];
    
    NSTimeInterval startTime = [self.api_runStartTime timeIntervalSince1970];
    
    NSArray<id<HMServiceAPIRunDistanceData>> *distanceDatas = [self api_runDetailDataDistance];
    
    //得到公里
    for (id<HMServiceAPIRunDistanceData> distanceData in distanceDatas) {
        
        if ([self isAddPaceWithDistanceData:distanceData isKilo:YES paceDistances:kiloPaceDistance]) {
            [kiloPaceDistance addObject:distanceData];
            
            HMServiceAPIRunPaceDataItem *kiloPaceItem = [[HMServiceAPIRunPaceDataItem alloc] init];
            kiloPaceItem.kilometer = (NSInteger)((float)distanceData.api_runDistance / 1000.0) - 1;
            kiloPaceItem.totalTime = [distanceData.api_runDistanceDate timeIntervalSince1970] - startTime;
            kiloPaceItem.timestamp = distanceData.api_runDistanceDate;
            [kiloPaces addObject:kiloPaceItem];
        }
        
        if ([self isAddPaceWithDistanceData:distanceData isKilo:NO paceDistances:milePaceDistance]) {
            [milePaceDistance addObject:distanceData];
            
            HMServiceAPIRunPaceDataItem *milePaceItem = [[HMServiceAPIRunPaceDataItem alloc] init];
            milePaceItem.kilometer = (NSInteger)((float)distanceData.api_runDistance / 1609.344) - 1;
            milePaceItem.totalTime = [distanceData.api_runDistanceDate timeIntervalSince1970] - startTime;
            milePaceItem.timestamp = distanceData.api_runDistanceDate;
            [milePaces addObject:milePaceItem];
        }
    }
    
    //补充公里用时
    kiloPaces = [self getPaceItemsWithIiems:kiloPaces];
    milePaces = [self getPaceItemsWithIiems:milePaces];
    
    [self setAvgHeartRateInfoWithDatas:[self api_runDetailDataHeartRate] kiloPaceItems:kiloPaces milePaceItems:milePaces];
    [self setGPSInfoWithDatas:[self api_runDetailDataGps] kiloPaceItems:kiloPaces milePaceItems:milePaces];
    
    objc_setAssociatedObject(self, "api_calculateMileagePacesInKilometer", kiloPaces, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "api_calculateMileagePacesInMile", milePaces, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAvgHeartRateInfoWithDatas:(NSArray<id<HMServiceAPIRunHeartRateData>> *)heartRateDatas kiloPaceItems:(NSMutableArray *)kiloPaceItems milePaceItems:(NSMutableArray *)milePaceItems
{
    NSInteger kiloTotalTime = 0;
    NSUInteger kiloTotalHeartRate = 0;
    NSUInteger lastKiloCount = 0;
    
    NSInteger mileTotalTime = 0;
    NSUInteger mileTotalHeartRate = 0;
    NSUInteger lastMileCount = 0;
    
    NSTimeInterval lastTime = 0.0;
    id<HMServiceAPIRunHeartRateData> lastHeartRateData = nil;
    
    for (id<HMServiceAPIRunHeartRateData> heartRateData in heartRateDatas) {
        NSInteger heartRate = heartRateData.api_runHeartRate;
        
        if (heartRate == 0) {
            continue;
        }
        if (!lastHeartRateData) {
            lastHeartRateData = heartRateData;
            continue;
        }
        
        NSTimeInterval time = [heartRateData.api_runHeartRateDate timeIntervalSince1970];
        
        NSInteger offsetTime = time - lastTime;
        
        if (offsetTime > 60) {
            offsetTime = 1;
        }
        
        kiloTotalHeartRate += offsetTime * lastHeartRateData.api_runHeartRate;
        kiloTotalTime += offsetTime;
        
        for (NSInteger i = lastKiloCount; i < [kiloPaceItems count]; i++) {
            
            HMServiceAPIRunPaceDataItem *kiloPaceItem = [kiloPaceItems objectAtIndex:i];
            if (kiloPaceItem.timestamp == nil) {
                continue;
            }
            
            NSTimeInterval kiloTime = [kiloPaceItem.timestamp timeIntervalSince1970];
            
            if (time > kiloTime) {
                NSUInteger avgHeartRate =  kiloTotalHeartRate / kiloTotalTime;
                kiloPaceItem.heartRate = avgHeartRate;
                lastKiloCount = i + 1;
                kiloTotalTime = 0;
                kiloTotalHeartRate = 0;
                break;
            }
        }
        
        mileTotalHeartRate += offsetTime * lastHeartRateData.api_runHeartRate;
        mileTotalTime += offsetTime;
        
        for (NSInteger i = lastMileCount; i < [milePaceItems count]; i++) {
            
            HMServiceAPIRunPaceDataItem *milePaceItem = [milePaceItems objectAtIndex:i];
            if (milePaceItem.timestamp == nil) {
                continue;
            }
            
            NSTimeInterval mileTime = [milePaceItem.timestamp timeIntervalSince1970];
            
            if (time > mileTime) {
                
                NSUInteger avgHeartRate =  mileTotalHeartRate / mileTotalTime;
                milePaceItem.heartRate = avgHeartRate;
                lastMileCount = i + 1;
                mileTotalTime = 0;
                mileTotalHeartRate = 0;
                break;
            }
        }
        
        lastHeartRateData = heartRateData;
    }
}

- (void)setGPSInfoWithDatas:(NSArray<id<HMServiceAPIRunGPSData>> *)gpsDatas kiloPaceItems:(NSMutableArray *)kiloPaceItems milePaceItems:(NSMutableArray *)milePaceItems
{
    for (id<HMServiceAPIRunGPSData> gpsData in gpsDatas) {
        
        //        if (gpsData.api_runGPSFlag != HMServiceAPIRunGPSFlagNormal) {
        //            continue;
        //        }
        NSTimeInterval gpsTime = [gpsData.api_runGPSDataLoction.timestamp timeIntervalSince1970];
        
        for (NSInteger i = 0; i < [kiloPaceItems count]; i++) {
            
            HMServiceAPIRunPaceDataItem *kiloPaceItem = [kiloPaceItems objectAtIndex:i];
            if (kiloPaceItem.timestamp == nil) {
                continue;
            }
            
            NSTimeInterval kiloTime = [kiloPaceItem.timestamp timeIntervalSince1970];
            
            if (gpsTime < kiloTime) {
                kiloPaceItem.coordinate = gpsData.api_runGPSDataLoction.coordinate;
                break;
            }
        }
        
        for (NSInteger i = 0; i < [milePaceItems count]; i++) {
            
            HMServiceAPIRunPaceDataItem *milePaceItem = [milePaceItems objectAtIndex:i];
            if (milePaceItem.timestamp == nil) {
                continue;
            }
            
            NSTimeInterval mileTime = [milePaceItem.timestamp timeIntervalSince1970];
            if (gpsTime > mileTime) {
                milePaceItem.coordinate = gpsData.api_runGPSDataLoction.coordinate;
                break;
            }
        }
    }
}

- (NSMutableArray *)getPaceItemsWithIiems:(NSMutableArray *)paceItems
{
    NSMutableArray *newPaceItems = [NSMutableArray array];
    
    NSInteger lastKilo = -1;
    NSTimeInterval lastTotalTime = 0.0;
    
    for (HMServiceAPIRunPaceDataItem *paceItem in paceItems) {
        
        [newPaceItems addObject:paceItem];
        
        NSInteger offsetKilo = paceItem.kilometer - lastKilo;
        NSTimeInterval offsetTime =  paceItem.totalTime - lastTotalTime;
        
        if (offsetKilo > 1) {
            
            NSTimeInterval tmpTotalTime = lastTotalTime;
            NSTimeInterval time = offsetTime / offsetKilo;
            for (NSInteger i = 0; i > offsetKilo - 1; i++) {
                
                HMServiceAPIRunPaceDataItem *tmpPaceItem = [[HMServiceAPIRunPaceDataItem alloc] init];
                tmpPaceItem.kilometer = i + 1 + paceItem.kilometer;
                tmpPaceItem.time = time;
                [newPaceItems addObject:tmpPaceItem];
                tmpTotalTime += time;
            }
            
            paceItem.time =  paceItem.totalTime - tmpTotalTime;
        }
        else {
            paceItem.time = offsetTime;
        }
        lastTotalTime = paceItem.totalTime;
    }
    
    return newPaceItems;
}

- (BOOL)isAddPaceWithDistanceData:(id<HMServiceAPIRunDistanceData>)distanceData isKilo:(BOOL)isKilo paceDistances:(NSMutableArray *)paceDistances
{
    double kiloMeter = 1000.0;
    if (!isKilo) {
        kiloMeter = 1609.344;
    }
    
    NSInteger beforeKM = 0;
    id<HMServiceAPIRunDistanceData> lastDistanceData = nil;
    
    if ([paceDistances count] > 0) {
        lastDistanceData = [paceDistances lastObject];
        beforeKM = lastDistanceData.api_runDistance / kiloMeter;
    }
    
    double distanceKM = distanceData.api_runDistance / kiloMeter;
    NSInteger distanceKMInt = (NSInteger)distanceKM;
    if (distanceKM < beforeKM + 1.0) {
        return NO;
    }
    
    if (distanceKM - distanceKMInt > 0.05) {
        return NO;
    }
    
    return YES;
}

- (NSArray<id<HMServiceAPIRunCorrectAltitudeData>> *)api_runDetailDataCorrectAltitude {
    
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *encodeStr = self.hmjson[@"correct_altitude"].string;
    return  [encodeStr hm_stringByDecodingCorrectAltitudeWithStartTime:startTime];
}

- (NSArray<id<HMServiceAPIRunStrokeSpeedData>> *)api_runDetailDataStrokeSpeed {
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *encodeStr = self.hmjson[@"stroke_speed"].string;
    return  [encodeStr hm_stringByDecodingStrokeSpeedWithStartTime:startTime];
}

- (NSArray<id<HMServiceAPIRunCadenceData>> *)api_runDetailDataCadence {
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *encodeStr = self.hmjson[@"cadence"].string;
    return  [encodeStr hm_stringByDecodingCadenceWithStartTime:startTime];
}

- (NSArray<id<HMServiceAPIRunDailyPerformanceInfoData>> *)api_runDetailDataDailyPerformanceInfo {
    if (self.hmjson[@"daily_performance_info"].string.length == 0) {
        return @[];
    }
    
    return [self.hmjson[@"daily_performance_info"].string componentsSeparatedByString:@";"];
}

- (NSArray<id<HMServiceAPIRunSpeedData>> *)api_runDetailDataSpeed {
    NSTimeInterval startTime = [self.hmjson[@"trackid"] doubleValue];
    NSString *encodeStr = self.hmjson[@"speed"].string;
    return  [encodeStr hm_stringByDecodingSpeedWithStartTime:startTime];
}


@end



@interface NSDictionary (HMServiceAPIRunSummaryData) <HMServiceAPIRunSummaryData>
@end

@implementation NSDictionary (HMServiceAPIRunSummaryData)

- (NSString *)api_runSummaryDataParentTrackID
{
    return self.hmjson[@"parent_trackid"].string;
}

- (NSArray *)api_runSummaryDataChildList
{
    NSArray *dicts = self.hmjson[@"child_list"].array;
    if ([dicts count] == 0) {
        return nil;
    }
    
    NSMutableArray *childList = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        NSString *childTrackID = dict.hmjson[@"trackid"].string;
        [childList addObject:childTrackID];
    }
    return childList;
}

- (HMServiceAPIRunType)api_runSummaryDataType {
    return self.hmjson[@"type"].runStatRunType;
}

- (HMServiceAPIRunSportMode)api_runSummaryDataSportMode {
    return self.hmjson[@"sport_mode"].unsignedIntegerValue;
}

- (double)api_runSummaryDataDistance {
    return self.hmjson[@"dis"].doubleValue;
}

- (double)api_runSummaryDataCalorie {
    return  self.hmjson[@"calorie"].doubleValue;
}

- (NSTimeInterval)api_runSummaryDataRunTime {
    return self.hmjson[@"run_time"].doubleValue;
}

- (NSDate *)api_runSummaryDataEndTime {
    return self.hmjson[@"end_time"].date;
}

- (double)api_runSummaryDataAvgPace {
    return self.hmjson[@"avg_pace"].doubleValue;
}

- (NSInteger)api_runSummaryDataAvgFrequency {
    return self.hmjson[@"avg_frequency"].integerValue;
}

- (NSInteger)api_runSummaryDataAvgHeareRate {
    return self.hmjson[@"avg_heart_rate"].integerValue;
}

- (NSInteger)api_runSummaryDataForefootRatio {
    return self.hmjson[@"forefoot_ratio"].integerValue;
}

- (double)api_runSummaryDataMaxPace {
    
    if (self.api_runDataSourceType == HMServiceAPIRunSourceTypeWatchHuanghe ||
        self.api_runDataSourceType == HMServiceAPIRunSourceTypeWatchEverest ||
        self.api_runDataSourceType == HMServiceAPIRunSourceTypeWatchEverest2S) {
        
        if (self.api_runDataVersion <= 14) {
            return self.hmjson[@"min_pace"].doubleValue;
        }
    }
    
    return self.hmjson[@"max_pace"].doubleValue;
}

- (double)api_runSummaryDataMinPace {
    
    if (self.api_runDataSourceType == HMServiceAPIRunSourceTypeWatchHuanghe ||
        self.api_runDataSourceType == HMServiceAPIRunSourceTypeWatchEverest ||
        self.api_runDataSourceType == HMServiceAPIRunSourceTypeWatchEverest2S) {
        
        if (self.api_runDataVersion <= 14) {
            return self.hmjson[@"max_pace"].doubleValue;
        }
    }
    
    return self.hmjson[@"min_pace"].doubleValue;
}

- (NSString *)api_runSummaryDataBindDevice {
    return self.hmjson[@"bind_device"].string;
}

- (double)api_runSummaryDataAltitudeAscend {
    return self.hmjson[@"altitude_ascend"].doubleValue;
}

- (double)api_runSummaryDataAltitudeDescend {
    return self.hmjson[@"altitude_descend"].doubleValue;
}

- (double)api_runSummaryDataStepLength {
    return self.hmjson[@"avg_stride_length"].doubleValue;
}

- (NSInteger)api_runSummaryDataTotalStep {
    return self.hmjson[@"total_step"].integerValue;
}

- (double)api_runSummaryDataClimbAscendDistance {
    return self.hmjson[@"distance_ascend"].doubleValue;
}

- (double)api_runSummaryDataClimbDescendDis {
    return self.hmjson[@"climb_dis_descend"].doubleValue;
}

- (NSTimeInterval)api_runSummaryDataClimbAscendTime {
    return self.hmjson[@"climb_dis_ascend_time"].number.doubleValue;
}

- (NSTimeInterval)api_runSummaryDataClimbDescendTime {
    return self.hmjson[@"climb_dis_descend_time"].number.doubleValue;
}

- (NSInteger)api_runSummaryDataMaxCadence {
    return self.hmjson[@"max_cadence"].integerValue;
}

- (NSInteger)api_runSummaryDataAvgCadence {
    return self.hmjson[@"avg_cadence"].integerValue;
}

- (NSString *)api_runSummaryDataLocation {
    return self.hmjson[@"location"].string;
}

- (NSString *)api_runSummaryDataCity {
    return self.hmjson[@"city"].string;
}

- (double)api_runSummaryDataFlightRatio {
    return self.hmjson[@"flight_ratio"].doubleValue;
}

- (NSTimeInterval)api_runSummaryDataLandingTime {
    return self.hmjson[@"landing_time"].doubleValue;
}

- (CLLocationDistance)api_runSummaryDataMaxAltitude {
    return self.hmjson[@"max_altitude"].doubleValue;
}

- (CLLocationDistance)api_runSummaryDataMinAltitude {
    return self.hmjson[@"min_altitude"].doubleValue;
}

- (CLLocationDistance)api_runSummaryDataLapDistance {
    return self.hmjson[@"lap_distance"].doubleValue;
}

- (NSInteger)api_runSummaryDataMaxHeartRate {
    return self.hmjson[@"max_heart_rate"].integerValue;
}

- (NSInteger)api_runSummaryDataMinHeartRate {
    return self.hmjson[@"min_heart_rate"].integerValue;
}

- (NSInteger)api_runSummaryDataStrokeEfficiency {
    return self.hmjson[@"swolf"].integerValue;
}

- (NSInteger)api_runSummaryDataStrokeTime {
    return self.hmjson[@"total_strokes"].integerValue;
}

- (NSInteger)api_runSummaryDataStrokeTrips {
    return self.hmjson[@"total_trips"].integerValue;
}

- (float)api_runSummaryDataAverageStrokeSpeed {
    return self.hmjson[@"avg_stroke_speed"].floatValue;
}

- (float)api_runSummaryDataMaxStrokeSpeed {
    return self.hmjson[@"max_stroke_speed"].floatValue;
}

- (CLLocationDistance)api_runSummaryDataStrokeDistance {
    return self.hmjson[@"avg_distance_per_stroke"].doubleValue;
}

- (CLLocationDistance)api_runSummaryDataSwimPoolLength {
    return self.hmjson[@"swim_pool_length"].doubleValue;
}

- (HMServiceAPIRunSwimStyleType)api_runSummaryDataSwimStyleType {
    return self.hmjson[@"swim_style"].integerValue;
}

- (NSInteger)api_runSummaryDataTrainEffect {
    return self.hmjson[@"te"].integerValue;
}

- (NSInteger)api_runSummaryDataMaxstepFrequency {
    return self.hmjson[@"max_frequency"].integerValue;
}

- (HMServiceAPIRunUnit)api_runSummaryDataUnit {
    return self.hmjson[@"unit"].integerValue;
}

- (NSInteger)api_runSummaryDataDownhillMaxAltitudeDesend {
    return self.hmjson[@"downhill_max_altitude_desend"].integerValue;
}

- (NSInteger)api_runSummaryDataDownhill_num {
    return self.hmjson[@"downhill_num"].integerValue;
}

- (NSInteger)api_runSummaryStrokes {
    return self.hmjson[@"strokes"].integerValue;
}

- (NSInteger)api_runSummaryForeHand {
    return self.hmjson[@"fore_hand"].integerValue;
}

- (NSInteger)api_runSummaryBackHand {
    return self.hmjson[@"back_hand"].integerValue;
}

- (NSInteger)api_runSummaryServe {
    return self.hmjson[@"serve"].integerValue;
}

- (NSTimeInterval)api_runSummaryHalfStartTime {
    return self.hmjson[@"second_half_start_time"].doubleValue;
}


@end


@interface NSDictionary (HMServiceAPIRunStatData) <HMServiceAPIRunStatData>
@end

@implementation NSDictionary (HMServiceAPIRunStatData)

- (NSTimeInterval)api_runStatDataRunTime {
    return self.hmjson[@"run_time"].doubleValue;
}

- (double)api_runStatDataCalorie {
    return self.hmjson[@"calorie"].doubleValue;
}

- (NSUInteger)api_runStatDistance {
    return [self.hmjson[@"dis"].number integerValue];
}

- (NSUInteger)api_runStatCount {
    return [self.hmjson[@"count"].number integerValue];
}

- (HMServiceAPIRunType)api_runStatRunType {
    return self.hmjson[@"type"].runStatRunType;
}

@end


@interface NSDictionary (HMServiceAPIRunConfigData) <HMServiceAPIRunConfigData>
@end

@implementation NSDictionary (HMServiceAPIRunConfigData)

- (BOOL)api_runConfigDataAutoPauseEnable {
    return self.hmjson[@"autoPauseEnable"].boolean;
}

- (BOOL)api_runConfigDataVoicePlayEnable {
    return self.hmjson[@"voicePlayEnable"].boolean;
}

- (BOOL)api_runConfigDataMeasureHREnable {
    return self.hmjson[@"measureHREnable"].boolean;
}

- (BOOL)api_runConfigDataRemindHREnable {
    return self.hmjson[@"remindHREnable"].boolean;
}

- (NSUInteger)api_runConfigDataRemindHeartRate {
    return self.hmjson[@"remindHeartRate"].unsignedIntegerValue;
}

- (BOOL)api_runConfigDataRemindPaceEnable {
    return self.hmjson[@"remindPaceEnable"].boolean;
}

- (double)api_runConfigDataRemindPace {
    return self.hmjson[@"remindPace"].doubleValue;
}

- (NSUInteger)api_runConfigDataKeepScreenOnEnable {
    return self.hmjson[@"keepScreenOn"].unsignedIntegerValue;;
}

- (NSString *)api_runConfigDataIndoorLearnLength {
    return self.hmjson[@"indoorLearnArray"].string;
}

- (NSString *)api_runConfigDataIndoorStepLength {
    return self.hmjson[@"indoorStepLArray"].string;
}

@end



@implementation HMServiceAPI  (Run)

#pragma mark - History
- (id<HMCancelableAPI>)run_historyWithSource:(HMServiceAPIRunSourceType)type
                                    runTypes:(NSArray<NSNumber *> *)runTypes
                                    friendID:(NSString *)friendID
                                   startTime:(NSDate *)startTime
                                       count:(NSInteger)count
                                   submotion:(BOOL)submotion
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(count > 0);
        NSString *source = stringWithRunSourceType(type);
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"source" : source} mutableCopy];
        if (startTime) {
            parameters[@"trackid"] = @((NSInteger)[startTime timeIntervalSince1970]);
        }
        else {
            parameters[@"trackid"] = @((NSInteger)[[NSDate date] timeIntervalSince1970]);
        }
        parameters[@"count"] = @(count);
        parameters[@"type"] = [self getRunTypeStringWithTypes:runTypes];
        
        if (submotion) {
            parameters[@"need_sub_data"] = @(YES);
        }
        
        if ([friendID length] > 0) {
            [parameters setObject:friendID forKey:@"follow_user_id"];
        }
        
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        return [self run_historyWithParameters:parameters completionBlock:completionBlock];
    }];
}

- (id<HMCancelableAPI>)run_historyWithSource:(HMServiceAPIRunSourceType)type
                                    runTypes:(NSArray<NSNumber *> *)runTypes
                                    friendID:(NSString *)friendID
                                   startTime:(NSDate *)startTime
                                     endTime:(NSDate *)endTime
                                   submotion:(BOOL)submotion
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(startTime);
        NSParameterAssert(endTime);
        
        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"source" : source} mutableCopy];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM";
        parameters[@"from"] = [formatter stringFromDate:endTime];
        parameters[@"to"] = [formatter stringFromDate:endTime];
        parameters[@"type"] = [self getRunTypeStringWithTypes:runTypes];
        if (submotion) {
            parameters[@"need_sub_data"] = @(YES);
        }
        if ([friendID length] > 0) {
            [parameters setObject:friendID forKey:@"follow_user_id"];
        }
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        return [self run_historyWithParameters:parameters completionBlock:completionBlock];
    }];
}

- (id<HMCancelableAPI>)run_historyWithSource:(HMServiceAPIRunSourceType)type
                                    runTypes:(NSArray<NSNumber *> *)runTypes
                                   startTime:(NSDate *)startTime
                                     endTime:(NSDate *)endTime
                                       count:(NSInteger)count
                                   submotion:(BOOL)submotion
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(startTime);
        NSParameterAssert(endTime);
        
        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"source" : source} mutableCopy];
        
        parameters[@"startTrackId"] = @((NSInteger)[startTime timeIntervalSince1970] + 1);
        parameters[@"stopTrackId"] = @((NSInteger)[endTime timeIntervalSince1970]);
        parameters[@"count"] = @(count);
        parameters[@"type"] = [self getRunTypeStringWithTypes:runTypes];
        if (submotion) {
            parameters[@"need_sub_data"] = @(YES);
        }
        
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        return [self run_historyWithParameters:parameters completionBlock:completionBlock];
    }];
}

- (NSString *)getRunTypeStringWithTypes:(NSArray<NSNumber *> *)runTypes {
    NSMutableString *typeStr = [NSMutableString stringWithFormat:@""];
    if (runTypes && runTypes.count > 0) {
        for (NSInteger i = 0; i < [runTypes count]; i++) {
            NSNumber *number = [runTypes objectAtIndex:i];
            if (i == 0) {
                [typeStr appendFormat:@"%@", number];
            }
            else {
                [typeStr appendFormat:@",%@", number];
            }
        }
    }
    
    return typeStr;
}

- (NSURLSessionTask *)run_historyWithParameters:(NSDictionary *)parameters
                                completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {
    if (!completionBlock) {
        return nil;
    }
    NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/run/history.json"];
    
    NSError *error = nil;
    NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO, error.localizedDescription, nil);
        });
        return nil;
    }
    
    return [HMNetworkCore GET:URL
                   parameters:parameters
                      headers:headers
                      timeout:30
              completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                  
                  [self legacy_handleResultForAPI:_cmd
                                    responseError:error
                                         response:response
                                   responseObject:responseObject
                                  completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                      
                                      NSArray *summarys = nil;
                                      if (success) {
                                          summarys = [data objectForKey:@"summary"];
                                      }
                                      
                                      if (completionBlock) {
                                          completionBlock(success, message, summarys);
                                      }
                                  }];
              }];
}

#pragma mark - Detail
- (id<HMCancelableAPI>)run_detailWithType:(HMServiceAPIRunSourceType)type
                                  trackid:(NSInteger)trackid
                                 friendID:(NSString *)friendID
                          completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIRunDetailData> runDetail))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(trackid > 0);
        
        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"source" : source,
                                             @"trackid" : @(trackid)} mutableCopy];
        if ([friendID length] > 0) {
            [parameters setObject:friendID forKey:@"follow_user_id"];
        }
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/run/detail.json"];
        
        
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:30
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:completionBlock];
                  }];
    }];
}

- (id<HMCancelableAPI>)run_uploadDetailData:(id<HMServiceAPIRunDetailData>)datailItem
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(datailItem);
        NSParameterAssert(datailItem.api_runDataTrackID.length > 0);
        NSParameterAssert(datailItem.api_runDataVersion > 0);
        
        NSString *source = stringWithRunSourceType(datailItem.api_runDataSourceType);
        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];
        
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSTimeInterval startTime = [datailItem.api_runDataTrackID doubleValue];
        
        NSArray *gpsDatas = datailItem.api_runDetailDataGps;
        NSArray *gaitDatas = datailItem.api_runDetailDataGait;
        NSArray *pauseDatas = datailItem.api_runDetailDataPause;
        NSArray *kiloPaces = datailItem.api_runDetailDataKiloPace;
        NSArray *milePaces = datailItem.api_runDetailDataMilePace;
        NSArray *heartRateDatas = datailItem.api_runDetailDataHeartRate;
        NSArray *distanceDatas = datailItem.api_runDetailDataDistance;
        NSArray *pressureDatas = datailItem.api_runDetailDataPressure;
        NSArray *speedDatas = datailItem.api_runDetailDataSpeed;
        
        NSDictionary *itemDictionary = @{@"trackid" : datailItem.api_runDataTrackID,
                                         @"source" : source,
                                         @"version" : @(datailItem.api_runDataVersion),
                                         @"longitude_latitude": gpsDatas.count?[gpsDatas hm_stringByEncodingLongitudeAndLatitude]:@"",
                                         @"altitude": gpsDatas.count?[gpsDatas hm_stringByEncodingAltitude]:@"",
                                         @"accuracy": gpsDatas.count?[gpsDatas hm_stringByEncodingAccuracy]:@"",
                                         @"time": gpsDatas.count?[gpsDatas hm_stringByEncodingTimeWithStartTime:startTime]:@"",
                                         @"gait": gaitDatas.count?[gaitDatas hm_stringByEncodingGaitWithStartTime:startTime]:@"",
                                         @"pace": gpsDatas.count?[gpsDatas hm_stringByEncodingPace]:@"",
                                         @"pause": pauseDatas.count?[pauseDatas hm_stringByEncodingPause]:@"",
                                         @"flag": gpsDatas.count?[gpsDatas hm_stringByEncodingFlag]:@"",
                                         @"kilo_pace": kiloPaces.count?[kiloPaces hm_stringByEncodingKiloPace]:@"",
                                         @"mile_pace": milePaces.count? [milePaces hm_stringByEncodingMilePace]:@"",
                                         @"heart_rate": heartRateDatas.count?[heartRateDatas hm_stringByEncodingHeartRateWithStartTime:startTime]:@"",
                                         @"distance": distanceDatas.count?[distanceDatas hm_stringByEncodingDistanceWithStartTime:startTime]:@"",
                                         @"air_pressure_altitude": pressureDatas.count?[pressureDatas hm_stringByEncodingBarometerPressureWithStartTime:startTime]:@"",
                                         @"speed": speedDatas.count?[speedDatas hm_stringByEncodingSpeedWithStartTime:startTime]:@""};
        [parameters addEntriesFromDictionary:itemDictionary];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/run/detail.json"];
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:30
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

#pragma mark - Summary
- (id<HMCancelableAPI>)run_uploadSummaryData:(id<HMServiceAPIRunSummaryData>)summaryItem
                             completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(summaryItem);
        NSParameterAssert(summaryItem.api_runDataTrackID.length > 0);
        NSParameterAssert(summaryItem.api_runDataVersion > 0);
        
        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];
        
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        parameters[@"trackid"] = summaryItem.api_runDataTrackID?:@"";
        parameters[@"source"] = stringWithRunSourceType(summaryItem.api_runDataSourceType);
        parameters[@"version"] = @(summaryItem.api_runDataVersion);
        
        NSDictionary *itemDictionary = @{@"dis" : @(summaryItem.api_runSummaryDataDistance),
                                         @"calorie" : @(summaryItem.api_runSummaryDataCalorie),
                                         @"end_time" : @(summaryItem.api_runSummaryDataEndTime.timeIntervalSince1970),
                                         @"run_time": @(summaryItem.api_runSummaryDataRunTime),
                                         @"avg_pace": @(summaryItem.api_runSummaryDataAvgPace),
                                         @"avg_frequency": @(summaryItem.api_runSummaryDataAvgFrequency),
                                         @"avg_heart_rate": @(summaryItem.api_runSummaryDataAvgHeareRate),
                                         @"forefoot_ratio": @(summaryItem.api_runSummaryDataForefootRatio),
                                         @"bind_device": summaryItem.api_runSummaryDataBindDevice ?: @"",
                                         @"max_pace": @(summaryItem.api_runSummaryDataMaxPace),
                                         @"min_pace": @(summaryItem.api_runSummaryDataMinPace),
                                         @"type": @(summaryItem.api_runSummaryDataType),
                                         @"location": summaryItem.api_runSummaryDataLocation ?: @"",
                                         @"city": summaryItem.api_runSummaryDataCity ?: @"",
                                         @"altitude_ascend": @(summaryItem.api_runSummaryDataAltitudeAscend),
                                         @"altitude_descend": @(summaryItem.api_runSummaryDataAltitudeDescend),
                                         @"avg_stride_length": @(summaryItem.api_runSummaryDataStepLength),
                                         @"total_step": @(summaryItem.api_runSummaryDataTotalStep),
                                         @"distance_ascend":  @(summaryItem.api_runSummaryDataClimbAscendDistance),
                                         @"climb_dis_ascend_time": @(summaryItem.api_runSummaryDataClimbAscendTime),
                                         @"climb_dis_descend": @(summaryItem.api_runSummaryDataClimbDescendDis),
                                         @"climb_dis_descend_time": @(summaryItem.api_runSummaryDataClimbDescendTime),
                                         @"max_cadence": @(summaryItem.api_runSummaryDataMaxCadence),
                                         @"avg_cadence": @(summaryItem.api_runSummaryDataAvgCadence),
                                         @"flight_ratio": @(summaryItem.api_runSummaryDataFlightRatio),
                                         @"landing_time": @(summaryItem.api_runSummaryDataLandingTime),
                                         };
        [parameters addEntriesFromDictionary:itemDictionary];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/run/summary.json"];
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:30
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)run_updateSummaryWithType:(HMServiceAPIRunSourceType)type
                                         trackID:(NSString *)trackID
                                        distance:(NSInteger)distance
                                 completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }
    
    NSString *source = stringWithRunSourceType(type);
    NSParameterAssert(distance > 0);
    NSParameterAssert(trackID.length > 0);
    NSParameterAssert(source.length > 0);
    if (source.length == 0 ||
        trackID.length == 0 ||
        distance == 0) {

        !completionBlock ?: completionBlock(NO, @"非法的source 或 distance 或 trackID");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];

        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }

        NSDictionary *itemDictionary = @{@"dis" : @(distance),
                                         @"source": source,
                                         @"trackid" : trackID};
        [parameters addEntriesFromDictionary:itemDictionary];

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/run/summary.json"];
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }

        return [HMNetworkCore PUT:URL
                       parameters:parameters
                          headers:headers
                          timeout:30
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, id data) {

                                          if (completionBlock) {
                                              completionBlock(success, message);
                                          }
                                      }];
                  }];
    }];

}

- (id<HMCancelableAPI>)run_deleteSummaryData:(id<HMServiceAPIRunSummaryData>)summaryItem
                             completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSParameterAssert(summaryItem);
    NSParameterAssert(summaryItem.api_runDataTrackID.length > 0);

    return [self run_deleteSummaryTrackID:summaryItem.api_runDataTrackID
                                     type:summaryItem.api_runDataSourceType
                          completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)run_deleteSummaryTrackID:(NSString *)trackID
                                           type:(HMServiceAPIRunSourceType)type
                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    NSParameterAssert(trackID.length > 0);
    if (trackID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"没有跑步ID");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"trackid": trackID,
                                             @"source": source,
                                             @"userid": userID} mutableCopy];
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/run/summary.json"];
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }

        return [HMNetworkCore DELETE:URL
                          parameters:parameters
                             headers:headers
                             timeout:30
                     completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                         [self legacy_handleResultForAPI:_cmd
                                           responseError:error
                                                response:response
                                          responseObject:responseObject
                                         completionBlock:^(BOOL success, NSString *message, id data) {

                                             if (completionBlock) {
                                                 completionBlock(success, message);
                                             }
                                         }];
                     }];
    }];
}

#pragma mark - Config

- (id<HMCancelableAPI>)run_configWithType:(HMServiceAPIRunSourceType)type
                          completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIRunConfigData> runConfig))completionBlock {
    if (!completionBlock) {
        return nil;
    }
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"type" : @"run",
                                             @"source" : source} mutableCopy];
        
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/config.json"];
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:30
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, id data) {
                                          
                                          NSDictionary *dataDict = (NSDictionary *)data;
                                          NSString *jsonString = [dataDict.hmjson[@"config"].string hms_stringByDecodingPercentEscape];
                                          
                                          if ([jsonString length] == 0) {
                                              completionBlock(success, message, nil);
                                              return ;
                                          }
                                          
                                          NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                          NSError *error = nil;
                                          NSDictionary *config = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                                          
                                          if (error) {
                                              completionBlock(success, message, nil);
                                          }
                                          else {
                                              completionBlock(success, message, config);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)run_uploadConfigData:(id<HMServiceAPIRunConfigData>)configItem
                                       type:(HMServiceAPIRunSourceType)type
                            completionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *runConfig))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(configItem);
        
        NSDictionary *itemDictionary = @{@"autoPauseEnable" : @(configItem.api_runConfigDataAutoPauseEnable),
                                         @"voicePlayEnable" : @(configItem.api_runConfigDataVoicePlayEnable),
                                         @"measureHREnable" : @(configItem.api_runConfigDataMeasureHREnable),
                                         @"remindHREnable": @(configItem.api_runConfigDataRemindHREnable),
                                         @"remindHeartRate": @(configItem.api_runConfigDataRemindHeartRate),
                                         @"remindPaceEnable": @(configItem.api_runConfigDataRemindPaceEnable),
                                         @"remindPace": @(configItem.api_runConfigDataRemindPace),
                                         @"keepScreenOn": @(configItem.api_runConfigDataKeepScreenOnEnable),
                                         @"indoorLearnArray": configItem.api_runConfigDataIndoorLearnLength ?: @"",
                                         @"indoorStepLArray": configItem.api_runConfigDataIndoorStepLength ?: @"",
                                         };
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemDictionary
                                                           options:0
                                                             error:&error];
        NSString* strConfig = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
        
        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"type" : @"run",
                                             @"source" : source,
                                             @"config" : strConfig} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/config.json"];
        
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:30
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:completionBlock];
                   }];
    }];
}

#pragma mark - Stat
- (id<HMCancelableAPI>)run_statWithType:(HMServiceAPIRunSourceType)type
                               friendID:(NSString *)friendID
                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunStatData>> *runStats))completionBlock {
    if (!completionBlock) {
        return nil;
    }
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        NSString *source = stringWithRunSourceType(type);
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"type" : @(0),
                                             @"source" : source} mutableCopy];
        if ([friendID length] > 0) {
            [parameters setObject:friendID forKey:@"follow_user_id"];
        }
        NSError *error = nil;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v2/sport/stat.json"];
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:30
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:completionBlock];
                  }];
    }];
}

@end
