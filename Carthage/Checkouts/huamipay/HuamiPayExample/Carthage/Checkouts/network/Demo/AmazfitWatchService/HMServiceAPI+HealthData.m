//
//  HMServiceAPI+HealthData.m
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+HealthData.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (HealthData)

- (id<HMCancelableAPI>)healthData_retrieveWithStartDate:(NSDate *)startDate
                                                endDate:(NSDate *)endDate
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHealthData>> *healthDatas))completionBlock {

    NSParameterAssert(startDate);
    if (!endDate) {
        endDate = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24];
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", nil);
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/deviceTypes/%d/data", userID, (int)HMServiceAPIDeviceTypeWatch]];

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

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

        NSDateFormatter *dateFormatter  = [NSDateFormatter new];
        dateFormatter.calendar          = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        dateFormatter.dateFormat        = @"yyyy-MM-dd";
        parameters[@"startDay"]         = [dateFormatter stringFromDate:startDate];
        parameters[@"endDay"]           = [dateFormatter stringFromDate:endDate];

        parameters[@"queryType"]        = @"detail";

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
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   if (!completionBlock) {
                                       return;
                                   }

                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}

- (void)healthData_retrieveAllDataByMonthWithStateDate:(NSDate *)startDate
                                           healthDatas:(NSMutableArray<id<HMServiceAPIHealthData>> *)allDatas
                                       completionBlock:(void (^)(BOOL, NSString *, NSArray<id<HMServiceAPIHealthData>> *))completionBlock {

    if ([startDate timeIntervalSinceDate:[NSDate date]] >= 60 * 60 * 24) {
        completionBlock(YES, nil, allDatas);
        return;
    }

    NSDateFormatter *dateFormatter  = [NSDateFormatter new];
    dateFormatter.calendar          = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.dateFormat        = @"yyyy-MM-dd";

    if (!startDate) {
        startDate = [dateFormatter dateFromString:@"2016-10-01"];
    }

    NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 60 * 24 * 30];

    [self healthData_retrieveWithStartDate:startDate
                                   endDate:endDate
                           completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIHealthData>> *healthDatas) {

                               if (!success) {
                                   completionBlock(NO, message, nil);
                                   return;
                               }

                               [allDatas addObjectsFromArray:healthDatas];

                               NSDate *startDate = [endDate dateByAddingTimeInterval:60 * 60 * 24];
                               [self healthData_retrieveAllDataByMonthWithStateDate:startDate
                                                                        healthDatas:allDatas
                                                                    completionBlock:completionBlock];
                           }];
}

#pragma mark - Public

- (id<HMCancelableAPI>)healthData_retrieveWithStartDate:(NSDate *)date
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHealthData>> *healthDatas))completionBlock {
    return [self healthData_retrieveWithStartDate:date endDate:nil completionBlock:completionBlock];
}

- (void)healthData_retrieveAllDataFromDate:(NSDate *)date
                           completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHealthData>> *healthDatas))completionBlock {
    
    [self healthData_retrieveAllDataByMonthWithStateDate:date
                                             healthDatas:[NSMutableArray new]
                                         completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)healthData_retrieveUpdateTimeWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSDate *updateTime))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", nil);
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/latestEffectiveUpdateTime", userID]];

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

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
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
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   if (!completionBlock) {
                                       return;
                                   }

                                   if (!success) {
                                       // 404是新用户
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                       if (httpResponse.statusCode == 404) {
                                           completionBlock(YES, nil, nil);
                                           return;
                                       }

                                       completionBlock(NO, message, nil);
                                       return;
                                   }

                                   NSTimeInterval timeInterval = data.hmjson[@"lastSyncTime"].doubleValue;
                                   if (timeInterval == 0) {
                                       timeInterval = data.hmjson[@"effectiveTime"].doubleValue;
                                       if (timeInterval == 0) {
                                           completionBlock(YES, message, nil);
                                           return;
                                       }
                                   }

                                   NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                                   completionBlock(YES, message, date);
                               }];
                  }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIHealthData) <HMServiceAPIHealthData>
@end

@implementation NSDictionary (HMServiceAPIHealthData)

- (NSDate *)api_healthDataDate {
    return [self.hmjson[@"date"] dateWithFormat:@"yyyy-MM-dd"];
}

- (NSData *)api_healthDataHeartRateData {
    return self.hmjson[@"heartRateData"].base64Data;
}

- (NSData *)api_healthDataMergedRawData {
    return self.hmjson[@"mergedRawData"].base64Data;
}

- (NSUInteger)api_healthDataStepGoal {
    return self.hmjson[@"summary"][@"goal"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataStepCount {
    return self.hmjson[@"summary"][@"stp"][@"ttl"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataDistanceInMeters {
    return self.hmjson[@"summary"][@"stp"][@"dis"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataEnergyBurnedInKilocalorie {
    return self.hmjson[@"summary"][@"stp"][@"cal"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataActiveMinutes {
    return self.hmjson[@"summary"][@"active"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataClimbedFloors {
    return self.hmjson[@"summary"][@"floor_count"].unsignedIntegerValue;
}

- (NSInteger)api_healthDataSleepStartMinute {
    NSDate *time = self.hmjson[@"summary"][@"slp"][@"st"].date;
    return [time timeIntervalSinceDate:self.api_healthDataDate] / 60;
}

- (NSInteger)api_healthDataSleepEndMinute {
    NSDate *time = self.hmjson[@"summary"][@"slp"][@"ed"].date;
    return [time timeIntervalSinceDate:self.api_healthDataDate] / 60;
}

- (NSUInteger)api_healthDataDeepSleepMinutes {
    return self.hmjson[@"summary"][@"slp"][@"dp"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataLightSleepMinutes {
    return self.hmjson[@"summary"][@"slp"][@"lt"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataAwakeMinutes {
    return self.hmjson[@"summary"][@"slp"][@"wk"].unsignedIntegerValue;
}

- (NSUInteger)api_healthDataWakeUpCount {
    return self.hmjson[@"summary"][@"slp"][@"wc"].unsignedIntegerValue;
}

@end
