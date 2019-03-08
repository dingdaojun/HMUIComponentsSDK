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

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }


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

- (id<HMCancelableAPI>)heartRate_listWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock {
    return [self heartRate_listToDate:nil limit:0 completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)heartRate_listToDate:(NSDate *)aDate
                                      limit:(NSUInteger)aLimit
                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock {

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


        NSDate *date = aDate ?: [NSDate date];
        NSUInteger limit = aLimit ?: 2000;

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

        NSMutableDictionary *parameters = [@{@"type" : @1,
                                             @"deviceType" : @(HMServiceAPIDeviceTypeWatch),
                                             @"endTime" : @((long long)date.timeIntervalSince1970),
                                             @"limit" : @(limit)} mutableCopy];
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

- (id<HMCancelableAPI>)heartRate_delete:(id<HMServiceAPIHeartRateData>)item
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSDate *time = item.api_heartRateDataTime;
    NSParameterAssert(time);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"/users/%@/heartRate/%@", userID, @((long long)time.timeIntervalSince1970)]];

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

        NSMutableDictionary *parameters = [@{@"userId" : userID,
                                             @"type" : @1,
                                             @"deviceType" : @(HMServiceAPIDeviceTypeWatch),
                                             @"generatedTime" : @((long long)time.timeIntervalSince1970)} mutableCopy];
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

                         [self handleResultForAPI:_cmd
                                    responseError:error
                                         response:response
                                   responseObject:responseObject
                                desiredDataFormat:HMServiceResultDataFormatAny
                                  completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

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

    Byte heartRate = 0;

    NSString *string = self.hmjson[@"heartRateData"].string;
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *valueData = [[NSData alloc] initWithBase64EncodedString:string options:0];

    if (valueData.length > 0) {
        NSString *heartRateString = [NSString stringWithFormat:@"%s", (char *)valueData.bytes];
        heartRate = heartRateString.integerValue;
        if (heartRate == 0) {
            heartRate = ((Byte *)valueData.bytes)[0];
        }
    }

    return heartRate;
}

- (HMServiceAPIDeviceSource)api_heartRateDataDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}

- (NSString *)api_heartRateDataDeviceID {
    return self.hmjson[@"deviceId"].string;
}

@end
