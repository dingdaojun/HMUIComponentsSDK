//
//  HMServiceAPI+Sleep.m
//  HMNetworkLayer
//
//  Created by 李宪 on 28/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Band.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (Band)

- (id<HMCancelableAPI>)band_uploadBandData:(id<HMServiceAPIBandData>)data
                            lastDeviceType:(HMServiceAPIDeviceType)lastDeviceType
                          lastDeviceSource:(HMServiceAPIDeviceSource)lastDeviceSource
                              lastDeviceID:(NSString *)lastDeviceID
                              lastSyncTime:(NSDate *)lastSyncTime
                             iOSDeviceUUID:(NSString *)uuid
                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        HMServiceAPIDeviceTypeParameterAssert(lastDeviceType);
        HMServiceAPIDeviceSourceParameterAssert(lastDeviceSource);
        NSParameterAssert(uuid.length > 0);
        
        NSString *dataString = ({
            
            NSString *dateString = ({
                NSDate *date = data.api_bandDataDate;
                NSParameterAssert(date);
                
                NSDateFormatter *formatter  = [NSDateFormatter new];
                formatter.calendar          = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                formatter.dateFormat        = @"yyyy-MM-dd";
                [formatter stringFromDate:date];
            });
            
            id<HMServiceAPIBandRawData>rawData = data.api_bandDataRawData;
            NSData *heartRateRawData = rawData.api_bandRawDataHeartRateRawData;
            NSString *heartRateRawDataString = @"";
            if (heartRateRawData.length > 0) {
                heartRateRawDataString = [heartRateRawData base64EncodedStringWithOptions:0];
            }
            
            NSString *summaryString = ({
                
                id<HMServiceAPIBandSleepData>sleepData  = data.api_bandDataSleepData;
                id<HMServiceAPIBandStepData>stepData    = data.api_bandDataStepData;
                
                NSDictionary *sleepDictionary = ({
                    
                    NSDate *startTime               = sleepData.api_bandSleepDataStartTime;
                    NSDate *endTime                 = sleepData.api_bandSleepDataEndTime;
                    NSUInteger deepSleepMinutes     = sleepData.api_bandSleepDataDeepSleepMinutes;
                    NSUInteger lightSleepMinutes    = sleepData.api_bandSleepDataLightSleepMinutes;
                    NSUInteger awakeMinutes         = sleepData.api_bandSleepDataAwakeMinutes;
                    NSUInteger wakeUpCount          = sleepData.api_bandSleepDataWakeUpCount;
                    NSParameterAssert(startTime);
                    NSParameterAssert(endTime);
                    
                    @{@"ed" : @((long long)endTime.timeIntervalSince1970),
                      @"wk" : @(awakeMinutes),
                      @"lt" : @(lightSleepMinutes),
                      @"wc" : @(wakeUpCount),
                      @"st" : @((long long)startTime.timeIntervalSince1970),
                      @"dp" : @(deepSleepMinutes)};
                });
                
                NSDictionary *stepDictionary = ({
                    
                    NSUInteger stepCount        = stepData.api_bandStepDataStepCount;
                    double distance             = stepData.api_bandStepDataDistanceInMeters;
                    double calorie              = stepData.api_bandStepDataCalorie;
                    NSUInteger walkingMinutes   = stepData.api_bandStepDataWalkingMinutes;
                    NSUInteger runningMinutes   = stepData.api_bandStepDataRunningMinutes;
                    double runningDistance      = stepData.api_bandStepDataRunningDistance;
                    double runningCalorie       = stepData.api_bandStepDataRunningCalorie;
                    
                    @{@"runCal" : @(runningCalorie),
                      @"cal" : @(calorie),
                      @"conAct" : @0,
                      @"ttl" : @(stepCount),
                      @"dis" : @(distance),
                      @"rn" : @(runningMinutes),
                      @"wk" : @(walkingMinutes),
                      @"runDist" : @(runningDistance)};
                });
                
                NSUInteger goal = stepData.api_bandStepDataStepCountGoal;
                
                NSDictionary *summaryDictionary = @{@"slp" : sleepDictionary,
                                                    @"stp" : stepDictionary,
                                                    @"v" : @5,
                                                    @"goal" : @(goal)};
                NSData *summaryJSONData = [NSJSONSerialization dataWithJSONObject:summaryDictionary options:0 error:NULL];
                [[NSString alloc] initWithData:summaryJSONData encoding:0];
            });
            
            NSArray *dataArray = ({
                
                NSData *data = rawData.api_bandRawDataStepAndSleepRawData;
                HMServiceAPIDeviceSource deviceSource = rawData.api_bandRawDataDeviceSource;
                NSString *deviceID = rawData.api_bandRawDataDeviceID;
                NSTimeZone *timeZone = rawData.api_bandRawDataTimeZone;
                if (!timeZone) {
                    timeZone = [NSTimeZone systemTimeZone];
                }
                
                NSParameterAssert(data.length > 0 && data.length % 3 == 0);
                HMServiceAPIDeviceSourceParameterAssert(deviceSource);
                
                @[@{@"start" : @0,
                    @"stop" : @1439,
                    @"value" : [data base64EncodedStringWithOptions:0],
                    @"src" : @(deviceSource),
                    @"did" : deviceID.length > 0 ? deviceID : @"-1",
                    @"tz" : @([timeZone hms_offset])}];
            });
            
            NSArray *bandDataDictionaries = @[@{@"summary" : summaryString,
                                                @"data" : dataArray,
                                                @"data_hr" : heartRateRawDataString,
                                                @"date" : dateString}];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bandDataDictionaries options:0 error:NULL];
            [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        });
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/data/band_data.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"data_json" : dataString,
                                             @"last_deviceid" : lastDeviceID.length > 0 ? lastDeviceID : @"-1",
                                             @"uuid" : uuid,
                                             @"last_source" : @(lastDeviceSource),
                                             @"device_type" : @(lastDeviceType)} mutableCopy];
        if (lastSyncTime) {
            parameters[@"last_sync_data_time"] = @((long long)lastSyncTime.timeIntervalSince1970);
        }
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
             return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)band_bandDatasFromDate:(NSDate *)inBeginDate
                                       toDate:(NSDate *)inEndDate
                                  skipRawData:(BOOL)skipRawData
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBandData>> *bandDatas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        
        NSDate *beginDate = inBeginDate;
        NSDate *minDate = [formatter dateFromString:@"2014-01-01"];
        if (!beginDate || [beginDate timeIntervalSinceDate:minDate] < 0)  {
            beginDate = minDate;
        }
        
        NSDate *endDate = inEndDate;
        if (!endDate || [endDate timeIntervalSinceDate:minDate] <= 0) {
            endDate = [NSDate date];
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/data/band_data.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"device_type" : @(HMServiceAPIDeviceTypeBand),
                                             @"from_date" : [formatter stringFromDate:beginDate],
                                             @"to_date" : [formatter stringFromDate:endDate],
                                             @"query_type" : skipRawData ? @"summary" : @"detail"} mutableCopy];
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:completionBlock];
                  }];
    }];
}

- (id<HMCancelableAPI>)band_uploadManullySleepData:(id<HMServiceAPIBandSleepData>)sleepData
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSDate *date = sleepData.api_bandSleepDataDate;
        NSParameterAssert(date);
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSDate *startTime               = sleepData.api_bandSleepDataStartTime;
        NSDate *endTime                 = sleepData.api_bandSleepDataEndTime;
        NSUInteger deepSleepMinutes     = sleepData.api_bandSleepDataDeepSleepMinutes;
        NSUInteger lightSleepMinutes    = sleepData.api_bandSleepDataLightSleepMinutes;
        NSUInteger awakeMinutes         = sleepData.api_bandSleepDataAwakeMinutes;
        NSUInteger wakeUpCount          = sleepData.api_bandSleepDataWakeUpCount;
        NSParameterAssert(startTime);
        NSParameterAssert(endTime);
        
        NSDictionary *sleepDataDictionary = @{@"st" : @((long long)startTime.timeIntervalSince1970),
                                              @"ed" : @((long long)endTime.timeIntervalSince1970),
                                              @"dp" : @(deepSleepMinutes),
                                              @"lt" : @(lightSleepMinutes),
                                              @"wc" : @(wakeUpCount),
                                              @"wk" : @(awakeMinutes)};
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sleepDataDictionary options:0 error:NULL];
        NSString *summaryJSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/user/manualData.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"type" : @"sleep",
                                             @"date" : dateString,
                                             @"summary" : summaryJSONString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];

    }];
}

- (id<HMCancelableAPI>)band_manullySleepDataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBandSleepData>> *sleepDatas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/user/manualData.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"type" : @"sleep"} mutableCopy];
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
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


#import <objc/runtime.h>

@interface NSDictionary (HMServiceBandAPI) <HMServiceAPIBandData, HMServiceAPIBandRawData, HMServiceAPIBandStepData, HMServiceAPIBandSleepData>
@property (nonatomic, strong, readonly) NSDictionary *api_bandDataSummaryDictionary;
@property (nonatomic, strong, readonly) NSDictionary *api_bandDataSleepDictionary;
@property (nonatomic, strong, readonly) NSDictionary *api_bandDataStepDictionary;
@end

@implementation NSDictionary (HMServiceBandAPI)

- (NSDictionary *)api_bandDataSummaryDictionary {

    NSDictionary *summary = objc_getAssociatedObject(self, "api_bandDataSummaryDictionary");
    if (summary) {
        return summary;
    }
    summary = self.hmjson[@"summary"].dictionary;
    if (!summary) {
        return nil;
    }
    objc_setAssociatedObject(self, "api_bandDataSummaryDictionary", summary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return summary;
}

- (NSDictionary *)api_bandDataSleepDictionary {
    
    NSDictionary *summary = self.api_bandDataSummaryDictionary;
    // 由于解析睡眠数据被两个接口复用，因此这个地方做了下适配。对于手环数据接口，睡眠数据来自于summary下的slp字段；而对于手动睡眠数据接口，睡眠数据直接来自于summary
    NSDictionary *sleepDictionary = summary.hmjson[@"slp"].dictionary;
    if (!sleepDictionary) {
        sleepDictionary = summary;
    }
        
    return sleepDictionary;
}

- (NSDictionary *)api_bandDataStepDictionary {
    NSDictionary *stepDictionary = self.api_bandDataSummaryDictionary.hmjson[@"stp"].dictionary;
    return stepDictionary;
}

#pragma mark - HMServiceAPIBandStepData

- (NSUInteger)api_bandStepDataStepCountGoal {
    return self.api_bandDataSummaryDictionary.hmjson[@"goal"].unsignedIntegerValue;
}

- (NSUInteger)api_bandStepDataStepCount {
    return self.api_bandDataStepDictionary.hmjson[@"ttl"].unsignedIntegerValue;
}

- (double)api_bandStepDataDistanceInMeters {
    return self.api_bandDataStepDictionary.hmjson[@"dis"].doubleValue;
}

- (double)api_bandStepDataCalorie {
    return self.api_bandDataStepDictionary.hmjson[@"cal"].doubleValue;
}

- (NSUInteger)api_bandStepDataWalkingMinutes {
    return self.api_bandDataStepDictionary.hmjson[@"wk"].unsignedIntegerValue;
}

- (NSUInteger)api_bandStepDataRunningMinutes {
    return self.api_bandDataStepDictionary.hmjson[@"rn"].doubleValue;
}

- (double)api_bandStepDataRunningDistance {
    return self.api_bandDataStepDictionary.hmjson[@"runDist"].doubleValue;
}

- (double)api_bandStepDataRunningCalorie {
    return self.api_bandDataStepDictionary.hmjson[@"runCal"].doubleValue;
}

#pragma mark - HMServiceAPIBandSleepData

- (NSDate *)api_bandSleepDataDate {
    return [self.hmjson[@"date_time"] dateWithFormat:@"yyyy-MM-dd"];
}

- (NSDate *)api_bandSleepDataStartTime {
    return self.api_bandDataSleepDictionary.hmjson[@"st"].date;
}

- (NSDate *)api_bandSleepDataEndTime {
    return self.api_bandDataSleepDictionary.hmjson[@"ed"].date;
}

- (NSUInteger)api_bandSleepDataDeepSleepMinutes {
    return self.api_bandDataSleepDictionary.hmjson[@"dp"].unsignedIntegerValue;
}

- (NSUInteger)api_bandSleepDataLightSleepMinutes {
    return self.api_bandDataSleepDictionary.hmjson[@"lt"].unsignedIntegerValue;
}

- (NSUInteger)api_bandSleepDataAwakeMinutes {
    return self.api_bandDataSleepDictionary.hmjson[@"wk"].unsignedIntegerValue;
}

- (NSUInteger)api_bandSleepDataWakeUpCount {
    return self.api_bandDataSleepDictionary.hmjson[@"wc"].unsignedIntegerValue;
}

#pragma mark - HMServiceAPIBandRawData

- (HMServiceAPIDeviceSource)api_bandRawDataDeviceSource {
    return self.hmjson[@"source"].unsignedIntegerValue;
}

- (NSString *)api_bandRawDataDeviceID {
    return @"";
}

- (NSTimeZone *)api_bandRawDataTimeZone {
    return nil;
}

- (NSData *)api_bandRawDataStepAndSleepRawData {
    return self.hmjson[@"data"].base64Data;
}

- (NSData *)api_bandRawDataHeartRateRawData {
    return self.hmjson[@"data_hr"].base64Data;
}

#pragma mark - HMServiceAPIBandData

- (NSDate *)api_bandDataDate {
    return [self.hmjson[@"date_time"] dateWithFormat:@"yyyy-MM-dd"];
}

- (id<HMServiceAPIBandStepData>)api_bandDataStepData {
    return self;
}

- (id<HMServiceAPIBandSleepData>)api_bandDataSleepData {
    return self;
}

- (id<HMServiceAPIBandRawData>)api_bandDataRawData {
    return self;
}

@end
