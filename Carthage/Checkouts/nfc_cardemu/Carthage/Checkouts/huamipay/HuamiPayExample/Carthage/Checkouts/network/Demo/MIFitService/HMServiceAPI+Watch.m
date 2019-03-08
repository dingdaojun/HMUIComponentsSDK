//
//  HMServiceAPI+Watch.m
//  HMNetworkLayer
//
//  Created by 李宪 on 11/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Watch.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Watch)

- (id<HMCancelableAPI>)watch_dataFromDate:(NSDate *)inBeginDate
                                   toDate:(NSDate *)inEndDate
                              skipRawData:(BOOL)skipRawData
                          completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIWatchData>> *watchDatas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        // 接口只支持获取最新的31天的数据
        NSDate *minDate = [NSDate dateWithTimeIntervalSinceNow:- 60 * 60 * 24 * 30];
        
        NSDate *beginDate = inBeginDate;
        if (!beginDate || [beginDate timeIntervalSinceDate:minDate] < 0)  {
            beginDate = minDate;
        }
        
        NSDate *endDate = inEndDate;
        if (!endDate || [endDate timeIntervalSinceDate:minDate] <= 0) {
            endDate = [NSDate date];
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/data/watch_data.json"];
        
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
                                             @"from_time" : @((long long)beginDate.timeIntervalSince1970),
                                             @"to_time" : @((long long)endDate.timeIntervalSince1970),
                                             @"device_type": @(HMServiceAPIDeviceTypeWatch),
                                             @"query_type" : skipRawData ? @"summary" : @"detail"} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
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

@interface NSDictionary (HMServiceAPIWatchData) <HMServiceAPIWatchData, HMServiceAPIWatchStepData, HMServiceAPIWatchSleepData>
@property (nonatomic, strong, readonly) NSDictionary *api_watchDataSleepDictionary;
@property (nonatomic, strong, readonly) NSDictionary *api_watchDataStepDictionary;
@end

@implementation NSDictionary (HMServiceAPIWatchData)

- (NSDictionary *)api_watchDataSummaryDictionary {
    
    NSDictionary *summary = objc_getAssociatedObject(self, "api_watchDataSummaryDictionary");
    if (!summary) {
        summary = self.hmjson[@"summary"].dictionary;
        if (!summary) {
            return nil;
        }
        
        objc_setAssociatedObject(self, "api_watchDataSummaryDictionary", summary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return summary;
}

- (NSDictionary *)api_watchDataSleepDictionary {
    return self.api_watchDataSummaryDictionary.hmjson[@"slp"].dictionary;
}

- (NSDictionary *)api_watchDataStepDictionary {
    return self.api_watchDataSummaryDictionary.hmjson[@"stp"].dictionary;
}

#pragma mark - HMServiceAPIWatchStepData

- (NSUInteger)api_watchStepDataStepCountGoal {
    return self.api_watchDataSummaryDictionary.hmjson[@"goal"].unsignedIntegerValue;
}

- (NSUInteger)api_watchStepDataStepCount {
    return self.api_watchDataStepDictionary.hmjson[@"ttl"].unsignedIntegerValue;
}

- (double)api_watchStepDataDistanceInMeters {
    return self.api_watchDataStepDictionary.hmjson[@"dis"].doubleValue;
}

- (double)api_watchStepDataCalorie {
    return self.api_watchDataStepDictionary.hmjson[@"cal"].doubleValue;
}

- (NSUInteger)api_watchStepDataWalkingMinutes {
    return self.api_watchDataStepDictionary.hmjson[@"wk"].unsignedIntegerValue;
}

- (NSUInteger)api_watchStepDataRunningMinutes {
    return self.api_watchDataStepDictionary.hmjson[@"rn"].doubleValue;
}

- (double)api_watchStepDataRunningDistance {
    return self.api_watchDataStepDictionary.hmjson[@"runDist"].doubleValue;
}

- (double)api_watchStepDataRunningCalorie {
    return self.api_watchDataStepDictionary.hmjson[@"runCal"].doubleValue;
}

#pragma mark - HMServiceAPIWatchSleepData

- (NSDate *)api_watchSleepDataStartTime {
    return self.api_watchDataSleepDictionary.hmjson[@"st"].date;
}

- (NSDate *)api_watchSleepDataEndTime {
    return self.api_watchDataSleepDictionary.hmjson[@"ed"].date;
}

- (NSUInteger)api_watchSleepDataDeepSleepMinutes {
    return self.api_watchDataSleepDictionary.hmjson[@"dp"].unsignedIntegerValue;
}

- (NSUInteger)api_watchSleepDataLightSleepMinutes {
    return self.api_watchDataSleepDictionary.hmjson[@"lt"].unsignedIntegerValue;
}

- (NSUInteger)api_watchSleepDataAwakeMinutes {
    return self.api_watchDataSleepDictionary.hmjson[@"wk"].unsignedIntegerValue;
}

- (NSUInteger)api_watchSleepDataWakeUpCount {
    return self.api_watchDataSleepDictionary.hmjson[@"wc"].unsignedIntegerValue;
}

#pragma mark - HMServiceAPIWatchData

- (NSDate *)api_watchDataDate {
    return [self.hmjson[@"date"] dateWithFormat:@"yyyy-MM-dd"];
}

- (NSDate *)api_watchDataLastSyncTime {
    return self.hmjson[@"lastSyncedTimestamp"].date;
}

- (HMServiceAPIDeviceSource)api_watchDataDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}

- (id<HMServiceAPIWatchStepData>)api_watchDataStepData {
    return self;
}

- (id<HMServiceAPIWatchSleepData>)api_watchDataSleepData {
    return self;
}

- (NSData *)api_watchDataMergedRawData {
    return self.hmjson[@"mergedRawData"].base64Data;
}

- (NSData *)api_watchDataHeartRateRawData {
    return self.hmjson[@"heartRateData"].base64Data;
}

@end
