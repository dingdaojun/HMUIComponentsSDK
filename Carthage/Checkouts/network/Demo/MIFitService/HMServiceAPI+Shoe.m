//
//  HMServiceAPI+Shoe.m
//  HMNetworkLayer
//
//  Created by 李宪 on 15/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Shoe.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (Shoe)

- (id<HMCancelableAPI>)shoe_uploadShoeData:(id<HMServiceAPIShoeData>)data
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
        
        NSParameterAssert(uuid.length > 0);
        
        NSDate *date                                = data.api_shoeDataDate;
        HMServiceAPIDeviceSource deviceSource       = data.api_shoeDataDeviceSource;
        NSString *deviceID                          = data.api_shoeDataDeviceID;
        NSString *serialNumber                      = data.api_shoeDataSerialNumber;
        NSData *rawData                             = data.api_shoeDataRawData;
        NSParameterAssert(date);
        NSParameterAssert(deviceSource == HMServiceAPIDeviceSourceShoe1 ||
                          deviceSource == HMServiceAPIDeviceSourceShoeMiJia ||
                          deviceSource == HMServiceAPIDeviceSourceSprandiShoe ||
                          deviceSource == HMServiceAPIDeviceSourceLightShoe ||
                          deviceSource == HMServiceAPIDeviceSourceChildrenShoe);
        NSParameterAssert(deviceID.length > 0);
        NSParameterAssert(rawData.length > 0);
        
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:date];
        
        NSString *summaryString = ({
            
            id<HMServiceAPIShoeStepData>stepData = data.api_shoeDataStepData;
            NSDictionary *stepDictionary = ({
                
                NSUInteger stepCount            = stepData.api_shoeStepDataStepCount;
                double distance                 = stepData.api_shoeStepDataDistanceInMeters;
                double calorie                  = stepData.api_shoeStepDataCalorie;
                NSUInteger walkingMinutes       = stepData.api_shoeStepDataWalkingMinutes;
                NSUInteger runningStepCount     = stepData.api_shoeStepDataRunningStepCount;
                NSUInteger frontFootStepCount   = stepData.api_shoeStepDataRunningStepCount;
                NSUInteger runningMinutes       = stepData.api_shoeStepDataFrontFootStepCount;
                double runningDistance          = stepData.api_shoeStepDataRunningDistance;
                double runningCalorie           = stepData.api_shoeStepDataRunningCalorie;
                
                @{@"ttl" : @(stepCount),
                  @"dis" : @(distance),
                  @"cal" : @(calorie),
                  @"wk" : @(walkingMinutes),
                  @"rttl" : @(runningStepCount),
                  @"rfttl" : @(frontFootStepCount),
                  @"rn" : @(runningMinutes),
                  @"rdis" : @(runningDistance),
                  @"rcal" : @(runningCalorie)};
            });
            
            NSUInteger goal = stepData.api_shoeStepDataStepCountGoal;
            
            NSDictionary *summaryDictionary = @{@"stp" : stepDictionary,
                                                @"v" : @1,
                                                @"goal" : @(goal)};
            NSData *summaryJSONData = [NSJSONSerialization dataWithJSONObject:summaryDictionary options:0 error:NULL];
            [[NSString alloc] initWithData:summaryJSONData encoding:0];
        });
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.user.setdata.json"];
        
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
                                             @"type" : @(HMServiceAPIDeviceTypeShoe),
                                             @"date" : dateString,
                                             @"summary" : summaryString,
                                             @"data" : [rawData base64EncodedStringWithOptions:0],
                                             @"deviceid" : deviceID,
                                             @"sn" : serialNumber ?: @"",
                                             @"source" : @(deviceSource),
                                             @"uuid" : uuid} mutableCopy];
        if (lastSyncTime) {
            parameters[@"last_sync_data_time"] = @((long long)lastSyncTime.timeIntervalSince1970);
        }
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
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

- (id<HMCancelableAPI>)shoe_shoeDatasFromDate:(NSDate *)inBeginDate
                                       toDate:(NSDate *)inEndDate
                                  skipRawData:(BOOL)skipRawData
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIShoeData>> *shoeDatas))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *minDate = [formatter dateFromString:@"2014-01-01"];
        
        NSDate *beginDate = inBeginDate;
        if (!beginDate || [beginDate timeIntervalSinceDate:minDate] < 0)  {
            beginDate = minDate;
        }
        
        NSDate *endDate = inEndDate;
        if (!endDate || [endDate timeIntervalSinceDate:minDate] <= 0) {
            endDate = [NSDate date];
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.user.getdata.json"];
        
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
                                             @"type" : @(HMServiceAPIDeviceTypeShoe),
                                             @"deviceid" : @"",
                                             @"fromdate" : [formatter stringFromDate:beginDate],
                                             @"todate" : [formatter stringFromDate:endDate],
                                             @"is_data" : @(!skipRawData)} mutableCopy];
        
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
                                      completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                          
                                          NSArray *shoeDatas = nil;
                                          
                                          if (success) {
                                              shoeDatas = data.hmjson[@"data"].array;
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, shoeDatas);
                                          }
                                      }];
                  }];
    }];
}

@end


#import <objc/runtime.h>

@interface NSDictionary (HMServiceAPIShoeData) <HMServiceAPIShoeStepData, HMServiceAPIShoeData>
@property (nonatomic, strong, readonly) NSDictionary *api_shoeDataSummaryDictionary;
@property (nonatomic, strong, readonly) NSDictionary *api_shoeDataStepDictionary;
@end

@implementation NSDictionary (HMServiceAPIShoeData)

- (NSDictionary *)api_shoeDataSummaryDictionary {
    
    NSDictionary *summary = objc_getAssociatedObject(self, "api_shoeDataSummaryDictionary");
    if (!summary) {
        summary = self.hmjson[@"summary"].dictionary;
        if (!summary) {
            return nil;
        }
        
        objc_setAssociatedObject(self, "api_shoeDataSummaryDictionary", summary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return summary;
}

- (NSDictionary *)api_shoeDataStepDictionary {
    return self.api_shoeDataSummaryDictionary.hmjson[@"stp"].dictionary;
}

#pragma mark - HMServiceAPIShoeStepData

- (NSUInteger)api_shoeStepDataStepCountGoal {
    return self.api_shoeDataSummaryDictionary.hmjson[@"goal"].unsignedIntegerValue;
}

- (NSUInteger)api_shoeStepDataStepCount {
    return self.api_shoeDataStepDictionary.hmjson[@"ttl"].unsignedIntegerValue;
}

- (double)api_shoeStepDataDistanceInMeters {
    return self.api_shoeDataStepDictionary.hmjson[@"dis"].doubleValue;
}

- (double)api_shoeStepDataCalorie {
    return self.api_shoeDataStepDictionary.hmjson[@"cal"].doubleValue;
}

- (NSUInteger)api_shoeStepDataWalkingMinutes {
    return self.api_shoeDataStepDictionary.hmjson[@"wk"].unsignedIntegerValue;
}

- (NSUInteger)api_shoeStepDataRunningStepCount {
    return self.api_shoeDataStepDictionary.hmjson[@"rttl"].unsignedIntegerValue;
}

- (NSUInteger)api_shoeStepDataFrontFootStepCount {
    return self.api_shoeDataStepDictionary.hmjson[@"rfttl"].unsignedIntegerValue;
}

- (NSUInteger)api_shoeStepDataRunningMinutes {
    return self.api_shoeDataStepDictionary.hmjson[@"rn"].doubleValue;
}

- (double)api_shoeStepDataRunningDistance {
    return self.api_shoeDataStepDictionary.hmjson[@"rdis"].doubleValue;
}

- (double)api_shoeStepDataRunningCalorie {
    return self.api_shoeDataStepDictionary.hmjson[@"rcal"].doubleValue;
}

#pragma mark - HMServiceAPIShoeData

- (NSDate *)api_shoeDataDate {
    return [self.hmjson[@"date"] dateWithFormat:@"yyyy-MM-dd"];
}

- (HMServiceAPIDeviceSource)api_shoeDataDeviceSource {
    return self.hmjson[@"source"].unsignedIntegerValue;
}

- (NSString *)api_shoeDataDeviceID {
    return self.hmjson[@"deviceid"].string;
}

- (NSString *)api_shoeDataSerialNumber {
    return self.hmjson[@"sn"].string;
}

- (id<HMServiceAPIShoeStepData>)api_shoeDataStepData {
    return self;
}

- (NSData *)api_shoeDataRawData {
    return self.hmjson[@"data"].base64Data;
}

@end
