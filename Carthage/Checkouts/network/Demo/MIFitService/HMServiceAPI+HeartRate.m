//
//  HMServiceAPI+HeartRate.m
//  HMNetworkLayer
//
//  Created by 李宪 on 26/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+HeartRate.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (HeartRate)

- (id<HMCancelableAPI>)heartRate_upload:(NSArray<id<HMServiceAPIHeartRateData>> *)items
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSMutableArray *itemDictionaries = [NSMutableArray new];
        for (id<HMServiceAPIHeartRateData>item in items) {

            NSDate *time = item.api_heartRateDataTime;
            Byte value = item.api_heartRateDataValue;
            HMServiceAPIDeviceSource deviceSource = item.api_heartRateDataDeviceSource;

            NSParameterAssert(time);
            NSParameterAssert(value > 0);
            HMServiceAPIDeviceSourceParameterAssert(deviceSource);

            NSData *valueData = [NSData dataWithBytes:&value length:sizeof(value)];

            NSString *timeZone = [[NSTimeZone systemTimeZone] name] ?: @"";
            NSMutableDictionary *dictionary = [@{@"type" : @2,
                                                 @"heartRateData" : [valueData base64EncodedStringWithOptions:0],
                                                 @"timeZone" : timeZone,
                                                 @"deviceId" : item.api_heartRateDataDeviceID,
                                                 @"deviceSource" : @(deviceSource),
                                                 @"generatedTime" : @((long long)time.timeIntervalSince1970)} mutableCopy];
            [itemDictionaries addObject:dictionary];
        }
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/heartRate?deviceType=%d&type=2", userID, (int)HMServiceAPIDeviceTypeBand]];
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

        return [HMNetworkCore POST:URL
                        parameters:itemDictionaries
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self handleResultForAPI:_cmd
                                  responseError:error
                                       response:response
                                 responseObject:responseObject
                              desiredDataFormat:HMServiceResultDataFormatDictionary
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                    if (completionBlock) {
                                        completionBlock(success, message);
                                    }
                                }];
                   }];
    }];
}

- (id<HMCancelableAPI>)heartRate_listWithDate:(NSDate *)date
                                        count:(NSInteger)count
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock {

    return [self heartRate_listWithDate:date count:count deviceTypeNumber:nil completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)heartRate_listWithDate:(NSDate *)date
                                        count:(NSInteger)count
                                   deviceType:(HMServiceAPIDeviceType)deviceType
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock {
    return [self heartRate_listWithDate:date count:count deviceTypeNumber:@(deviceType) completionBlock:completionBlock];
}


- (id<HMCancelableAPI>)heartRate_listWithDate:(NSDate *)date
                                        count:(NSInteger)count
                             deviceTypeNumber:(NSNumber *)deviceTypeNumber
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/heartRate", userID]];
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

        NSMutableDictionary *parameters = [@{@"type" : @2,
                                             @"endTime" : @((NSInteger)[date timeIntervalSince1970]),
                                             @"limit" : @100} mutableCopy];
        if (deviceTypeNumber) {
            [parameters setObject:deviceTypeNumber forKey:@"deviceType"];
        }
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

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   NSArray *historyDatas = nil;
                                   if (success) {
                                       historyDatas = data.hmjson[@"items"].array;
                                   }

                                   if (completionBlock) {
                                       completionBlock(success, message, historyDatas);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)heartRate_delete:(NSArray<id<HMServiceAPIHeartRateData>> *)items
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSMutableArray *timestamps = [NSMutableArray new];
        for (id<HMServiceAPIHeartRateData>item in items) {
            NSDate *time = item.api_heartRateDataTime;
            NSParameterAssert(time);

            [timestamps addObject:@((long long)[time timeIntervalSince1970])];
        }
        NSData *timestampJSONData = [NSJSONSerialization dataWithJSONObject:timestamps options:0 error:NULL];
        NSString *timestampJSONString = [[NSString alloc] initWithData:timestampJSONData encoding:NSUTF8StringEncoding];

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/data/heart_rate.json"];

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
                                             @"type" : @2,
                                             @"timestamp_list" : timestampJSONString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
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
                             timeout:0
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

@end



@interface NSDictionary (HMServiceAPIHeartRateData) <HMServiceAPIHeartRateData>
@end

@implementation NSDictionary (HMServiceAPIHeartRateData)

- (NSDate *)api_heartRateDataTime {
    return self.hmjson[@"generatedTime"].date;
}

- (Byte)api_heartRateDataValue {
    NSData *valueData = self.hmjson[@"heartRateData"].base64Data;
    if (valueData.length > 0) {
        return ((Byte *)valueData.bytes)[0];
    }

    return 0;
}

- (HMServiceAPIDeviceSource)api_heartRateDataDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}


- (NSString *)api_heartRateDataDeviceID {
    return self.hmjson[@"deviceId"].string;
}



@end
