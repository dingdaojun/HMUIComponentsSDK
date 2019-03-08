//  HMServiceAPI+BUSCard.m
//  Created on 2018/6/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+BUSCard.h"
#import <UIKit/UIKit.h>
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (BUSCard)


- (id<HMCancelableAPI> _Nullable)busCard_bindWithDeviceID:(NSString *)deviceID
                                                     card:(id<HMServiceAPIBUSCard>)card
                                          completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    NSString *cardID = card.api_busCardID;
    NSParameterAssert(deviceID.length > 0);
    NSParameterAssert(cardID.length > 0);
    if (deviceID.length == 0 || cardID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"没有绑定设备或没有公交卡信息");
        return nil;
    }

    NSDictionary *wallerHeader = [self.delegate uniformWalletHeaderFieldValues];
    NSString *sn = wallerHeader.hmjson[@"x-snbps-imei"].string;
    NSString *cplc = wallerHeader.hmjson[@"x-snbps-cplc"].string;

    if (sn.length == 0 || cplc.length == 0) {
        !completionBlock ?: completionBlock(NO, @"没有绑定设备或没有公交卡信息");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/devices/%@/busCards/%@", userID, deviceID, cardID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        long long openTime = (long long)[card.api_busCardLastUpdateTime timeIntervalSince1970];
        NSMutableDictionary *parameters = [@{@"appCode" : card.api_busCardCityCode,
                                             @"aid" : card.api_busCardApplicationID,
                                             @"openTime" : @(openTime),
                                             @"sn" : sn,
                                             @"cplc" : cplc} mutableCopy];

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
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
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

- (id<HMCancelableAPI> _Nullable)busCard_retrieveWithDeviceID:(NSString *)deviceID
                                              completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCard>> * _Nullable cards))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(deviceID.length > 0);
    if (deviceID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"没有绑定设备", nil);
        return nil;
    }
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/device/%@/busCards", userID, deviceID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

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
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   NSArray *items = data.hmjson[@"items"].array;
                                   if (completionBlock) {
                                       completionBlock(success, message, items);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI> _Nullable)busCard_unbindWithDeviceID:(NSString *)deviceID
                                                     cardID:(NSString *)cardID
                                            completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    NSParameterAssert(deviceID.length > 0);
    NSParameterAssert(cardID.length > 0);

    if (deviceID.length == 0 || cardID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"没有绑定设备或没有公交卡信息");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/devices/%@/busCards/%@", userID, deviceID, cardID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
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

- (id<HMCancelableAPI> _Nullable)busCard_transactionRecordWithCityID:(NSString *)cityID
                                                              cardID:(NSString *)cardID
                                                                type:(HMServiceBUSCardTransactionRecordType)type
                                                            nextTime:(NSDate * _Nullable)nextTime
                                                               limit:(NSInteger)limit
                                                     completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardTransactionRecord>> * _Nullable records, NSDate *  _Nullable nestTime))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil, nil);
        return nil;
    }

    NSParameterAssert(cityID.length > 0);
    NSParameterAssert(cardID.length > 0);

    if (cityID.length == 0 || cardID.length == 0) {
        completionBlock(NO, @"没有城市或公交卡信息", nil, nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/cities/%@/busCards/%@/transactions", userID, cityID, cardID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil);
            });
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"queryType" : @(type),
                                             @"limit" : @(limit)} mutableCopy];
        if (nextTime) {
            long long next = (long long)nextTime.timeIntervalSince1970 * 1000;
            [parameters setObject:@(next) forKey:@"next"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil);
            });
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

                                   NSDate *date = data.hmjson[@"next"].date;
                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items, date);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI> _Nullable)busCard_uploadTransactionRecordWithCityID:(NSString *)cityID
                                                                    cardID:(NSString *)cardID
                                                                   records:(NSArray<id<HMServiceAPIBUSCardTransactionRecord>> *)records
                                                           completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出");
        return nil;
    }

    NSParameterAssert(cityID.length > 0);
    NSParameterAssert(cardID.length > 0);

    if (cityID.length == 0 || cardID.length == 0) {
        completionBlock(NO, @"没有城市或公交卡信息");
        return nil;
    }

    NSParameterAssert(records.count);
    if (!records.count) {
        completionBlock(NO, @"没有上传交易数据");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/cities/%@/busCards/%@/transactions", userID, cityID, cardID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription);
            });
            return nil;
        }

        NSMutableArray *recordDictionarys = [NSMutableArray array];
        for (id<HMServiceAPIBUSCardTransactionRecord> record in records) {
            long long time =  (long long)(record.api_busCardTransactionRecordTime.timeIntervalSince1970 * 1000);
            NSMutableDictionary *recordDictionary = [@{@"transactionType" : record.api_busCardTransactionRecordType,
                                                       @"transactionTime" : @(time),
                                                       @"state" : record.api_busCardTransactionRecordState,
                                                       @"amount" : @(record.api_busCardTransactionRecordAmount)} mutableCopy];
            NSString *location = record.api_busCardTransactionRecordLocation;
            NSString *serviceProvider = record.api_busCardTransactionRecordServiceProvider;
            if (location.length > 0) {
                [recordDictionary setObject:location forKey:@"site"];
            }
            if (serviceProvider.length > 0) {
                [recordDictionary setObject:serviceProvider forKey:@"serviceProvider"];
            }
            [recordDictionarys addObject:recordDictionary];
        }

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:recordDictionarys
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self handleResultForAPI:_cmd
                                  responseError:error
                                       response:response
                                 responseObject:responseObject
                              desiredDataFormat:HMServiceResultDataFormatAny
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                    completionBlock(success, message);
                                }];
                   }];
    }];
}


- (id<HMCancelableAPI> _Nullable)busCard_citiesWithDeviceID:(NSString *)deviceID
                                            completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable cities))completionBlock {
    
    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"devices/%@/openedBusCardCities", deviceID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
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

                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI> _Nullable)busCard_cityWithID:(NSString *)cityID
                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message, id<HMServiceAPIBUSCardCity> _Nullable city))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSParameterAssert(cityID.length > 0);
    if (cityID.length == 0) {
        completionBlock(NO, @"没有城市ID", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"busCardCities/%@", cityID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
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

                                   completionBlock(success, message, data);
                               }];
                  }];
    }];
}


- (id<HMCancelableAPI> _Nullable)busCard_cityWithDeviceID:(NSString *)deviceID
                                          completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable cities))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSParameterAssert(deviceID.length > 0);
    if (deviceID.length == 0) {
        completionBlock(NO, @"没有设备ID", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"devices/%@/busCardCities", deviceID]];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
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
                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI> _Nullable)busCard_busCompanyNoticeWithCompletionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCompanyNotice>> * _Nullable companyNotices))completionBlock {

    if (!completionBlock) {
        return nil;
    }


    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:@"busCompanyNotices"];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
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
                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI> _Nullable)busCard_busCompanyNoticeWithCityID:(NSString *)cityID
                                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCompanyNotice>> * _Nullable companyNotices))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSParameterAssert(cityID.length > 0);
    if (cityID.length == 0) {
        completionBlock(NO, @"没有城市ID", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:@"busCompanyNotices"];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        NSMutableDictionary *parameters = [@{@"appCode": cityID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
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
                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}

@end

static HMServiceBUSCardStatus cardStatusWithString(NSString *string) {
    NSDictionary *map = @{@"BINDING" : @(HMServiceBUSCardStatusBinding),
                          @"UNOPENED" : @(HMServiceBUSCardStatusUnopened),
                          @"EXCEPTION" : @(HMServiceBUSCardStatusException)};
    return [map[string] integerValue];
}

static HMServiceBUSCardCityStatus cityStatusWithString(NSString *string) {
    NSDictionary *map = @{@"PRE_ONLINE" : @(HMServiceBUSCardCityStatusPreOnline),
                          @"ONLINE" : @(HMServiceBUSCardCityStatusOnline),
                          @"TEST" : @(HMServiceBUSCardCityStatusTest),
                          @"OFFLINE" : @(HMServiceBUSCardCityStatusOffline),
                          @"DELETE" : @(HMServiceBUSCardCityStatusDelete)};
    return [map[string] integerValue];
}



@interface NSDictionary (HMServiceAPIBUSCard) <HMServiceAPIBUSCard>
@end

@implementation NSDictionary (HMServiceAPIBUSCard)

- (NSString *)api_busCardID {
    return self.hmjson[@"cardId"].string;
}

- (NSString *)api_busCardCityCode {
    return self.hmjson[@"appCode"].string;
}

- (NSInteger)api_busCardApplicationID {
    return self.hmjson[@"aid"].integerValue;
}

- (NSDate *)api_busCardLastUpdateTime {
    return self.hmjson[@"lastStatusUpdateTime"].date;
}

- (NSString *)api_busCardStatus {
    return self.hmjson[@"status"].string;     //还需要转码
}

@end


@interface NSDictionary (HMServiceAPIBUSCardTransactionRecord) <HMServiceAPIBUSCardTransactionRecord>
@end

@implementation NSDictionary (HMServiceAPIBUSCardTransactionRecord)

- (NSDate *)api_busCardTransactionRecordTime {
    return self.hmjson[@"transactionTime"].date;
}

- (NSString *)api_busCardTransactionRecordState {
    return self.hmjson[@"state"].string;
}

- (NSInteger)api_busCardTransactionRecordAmount {
    return self.hmjson[@"amount"].integerValue;
}

- (NSString *)api_busCardTransactionRecordLocation {
    return self.hmjson[@"site"].string;
}

- (NSString *)api_busCardTransactionRecordServiceProvider {
    return self.hmjson[@"serviceProvider"].string;
}

- (NSString *)api_busCardTransactionRecordType {
    return self.hmjson[@"transactionType"].string;
}

@end

@implementation NSDictionary (HMServiceAPIBUSCardCity)


- (NSString *)api_busCardCityName {
    return self.hmjson[@"cityName"].string;
}

- (NSString *)api_busCardCityID {
    return self.hmjson[@"appCode"].string;
}

- (NSString *)api_busCardCityCardName {
    return self.hmjson[@"cardName"].string;
}

- (NSString *)api_busCardCityAID {
    return self.hmjson[@"aid"].string;
}

- (NSString *)api_busCardCityBusCode {
    return self.hmjson[@"busCode"].string;
}

- (NSString *)api_busCardCityCardCode {
    return self.hmjson[@"cardCode"].string;
}

- (NSString *)api_busCardCityServiceScope {
    return self.hmjson[@"serviceScope"].string;
}

- (NSString *)api_busCardCityOpenedImgUrl {
    return self.hmjson[@"openedImgUrl"].string;
}

- (NSString *)api_busCardCityUnopenedImgUrl {
    return self.hmjson[@"unopenedImgUrl"].string;
}

- (BOOL)api_busCardCityHasSubCity {
    return self.hmjson[@"hasSubCity"].boolean;
}

- (NSDate *)api_busCardCityOpenTime {
    return self.hmjson[@"openTime"].date;
}

- (NSString *)api_busCardCityCardID {
    return self.hmjson[@"cardId"].string;
}

- (NSString *)api_busCardCityOrderID {
    return self.hmjson[@"orderId"].string;
}

- (HMServiceBUSCardStatus)api_busCardCityCardStatus {
    return cardStatusWithString(self.hmjson[@"cardStatus"].string);
}

- (NSString *)api_busCardCityFetchApduMode {
    return self.hmjson[@"fetchApduMode"].string;
}

- (NSString *)api_busCardCityParentCityID {
    return self.hmjson[@"parentAppCode"].string;
}

- (NSString *)api_busCardCityVisibleGroups {
    return self.hmjson[@"visibleGroups"].string;
}

- (NSString *)api_busCardCityXiaomiCardName {
    return self.hmjson[@"xiaomiCardName"].string;
}

- (NSString *)api_busCardCityXiaomiActionToken {
    return self.hmjson[@"xmActionToken"].string;
}

- (NSInteger)api_busCardCityXiaomiCardStatus {
    return self.hmjson[@"xmCardStatus"].integerValue;
}

- (NSArray<NSString *>  *)api_busCardCitySupportApps {
    return self.hmjson[@"supportApps"].array;
}

- (HMServiceBUSCardCityStatus)api_busCardCityStatus {
    return cityStatusWithString(self.hmjson[@"status"].string);
}

@end

@interface NSDictionary (HMServiceAPIBUSCardCompanyNotice) <HMServiceAPIBUSCardCompanyNotice>
@end

@implementation NSDictionary (HMServiceAPIBUSCardCompanyNotice)


- (NSArray <NSString *> *)api_busCardCompanyNoticeCities {
    return self.hmjson[@"appCodes"].array;
}

- (NSString *)api_busCardCompanyNoticeContext {
    return self.hmjson[@"context"].string;
}

- (NSString *)api_busCardCompanyNoticeCrossBarUrl {
    return self.hmjson[@"crossBarJumpUrl"].string;
}

- (NSString *)api_busCardCompanyNoticeID {
    return self.hmjson[@"id"].string;
}

- (NSDate *)api_busCardCompanyNoticeStartTime {
    return self.hmjson[@"startTime"].date;
}

- (NSDate *)api_busCardCompanyNoticeEndTime {
    return self.hmjson[@"endTime"].date;
}

- (NSDate *)api_busCardCompanyNoticeUpdateTime {
    return self.hmjson[@"updateTime"].date;
}

- (NSArray *)api_busCardCompanyNoticeTypes {
    return self.hmjson[@"noticeType"].array;
}

- (NSString *)api_busCardCompanyNoticeLoopType {
    return self.hmjson[@"loopType"].string;
}

- (BOOL)api_busCardCompanyNoticeSupportCrossBarJump {
    return self.hmjson[@"isSupportCrossBarJump"].boolean;
}

- (NSArray <id<HMServiceAPIBUSCardCompanyNoticeAppVersion>> *)api_busCardCompanyNoticeAppVersions {
    return self.hmjson[@"supportPhones"].array;
}

@end

@interface NSDictionary (HMServiceAPIBUSCardCompanyNoticeAppVersion) <HMServiceAPIBUSCardCompanyNoticeAppVersion>
@end

@implementation NSDictionary (HMServiceAPIBUSCardCompanyNoticeAppVersion)

- (NSString *)api_busCardCompanyNoticeAPPVersion {
    return self.hmjson[@"version"].string;
}

- (NSString *)api_busCardCompanyNoticeAPPType {
    return self.hmjson[@"phoneType"].string;
}

@end


