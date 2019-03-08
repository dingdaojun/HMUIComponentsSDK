//  HMServiceAPI+BUSCardsBinding.m
//  Created on 2018/2/22
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+BUSCardsBinding.h"
#import <UIKit/UIKit.h>
#import <HMNetworkLayer/HMNetworkLayer.h>


static HMServiceBUSCardStatus cardStatusWithString(NSString *string) {
    NSDictionary *map = @{@"BINDING" : @(HMServiceBUSCardStatusBinding),
                          @"UNOPENED" : @(HMServiceBUSCardStatusUnopened),
                          @"EXCEPTION" : @(HMServiceBUSCardStatusException)};
    return [map[string] integerValue];
}

@interface NSDictionary (HMServiceAPIBUSCardsBindingCard) <HMServiceAPIBUSCardsBindingCard>
@end

@implementation NSDictionary (HMServiceAPIBUSCardsBindingCard)

- (NSString *)api_busCardsBindingCardID {
    return self.hmjson[@"cardId"].string;
}

- (NSString *)api_busCardsBindingCardCityCode {
    return self.hmjson[@"appCode"].string;
}

- (NSInteger)api_busCardsBindingCardApplicationID {
    return self.hmjson[@"aid"].integerValue;
}

- (NSDate *)api_busCardsBindingCardLastUpdateTime {
    return self.hmjson[@"lastStatusUpdateTime"].date;
}

- (NSString *)api_busCardsBindingCardStatus {
    return self.hmjson[@"status"].string;     //还需要转码
}

@end


@interface NSDictionary (HMServiceAPIBUSCardsTransactionRecord) <HMServiceAPIBUSCardsTransactionRecord>
@end

@implementation NSDictionary (HMServiceAPIBUSCardsTransactionRecord)

- (NSDate *)api_busCardsTransactionRecordTime {
    return self.hmjson[@"transactionTime"].date;
}

- (NSString *)api_busCardsTransactionRecordState {
    return self.hmjson[@"state"].string;
}

- (NSInteger)api_busCardsTransactionRecordAmount {
    return self.hmjson[@"amount"].integerValue;
}

- (NSString *)api_busCardsTransactionRecordLocation {
    return self.hmjson[@"site"].string;
}

- (NSString *)api_busCardsTransactionRecordServiceProvider {
    return self.hmjson[@"serviceProvider"].string;
}

- (NSString *)api_busCardsTransactionRecordType {
    return self.hmjson[@"transactionType"].string;
}

@end

@implementation NSDictionary (HMServiceAPIBUSCardsCity)


- (NSString *)api_busCardsCityName {
    return self.hmjson[@"cityName"].string;
}

- (NSString *)api_busCardsCityID {
    return self.hmjson[@"appCode"].string;
}

- (NSString *)api_busCardsCityCardName {
    return self.hmjson[@"cardName"].string;
}

- (NSString *)api_busCardsCityAID {
    return self.hmjson[@"aid"].string;
}

- (NSString *)api_busCardsCityBusCode {
    return self.hmjson[@"busCode"].string;
}

- (NSString *)api_busCardsCityCardCode {
    return self.hmjson[@"cardCode"].string;
}

- (NSString *)api_busCardsCityServiceScope {
    return self.hmjson[@"serviceScope"].string;
}

- (NSString *)api_busCardsCityOpenedImgUrl {
    return self.hmjson[@"openedImgUrl"].string;
}

- (NSString *)api_busCardsCityUnopenedImgUrl {
    return self.hmjson[@"unopenedImgUrl"].string;
}

- (BOOL)api_busCardsCityHasSubCity {
    return self.hmjson[@"hasSubCity"].boolean;
}

- (NSDate *)api_busCardsCityOpenTime {
    return self.hmjson[@"openTime"].date;
}

- (NSString *)api_busCardsCityCardID {
    return self.hmjson[@"cardId"].string;
}

- (NSString *)api_busCardsCityOrderID {
    return self.hmjson[@"orderId"].string;
}

- (HMServiceBUSCardStatus)api_busCardsCityCardStatus {
    return cardStatusWithString(self.hmjson[@"cardStatus"].string);
}

@end

@interface NSDictionary (HMServiceAPIWalletConfiguration) <HMServiceAPIWalletConfiguration>
@end

@implementation NSDictionary (HMServiceAPIWalletConfiguration)

- (NSString *)api_busCardsCityConfigurationPone {
    return self.hmjson[@"huami.mifit.user.phone"].string;
}

@end

@implementation HMServiceAPI (BUSCardsBinding)

- (id<HMCancelableAPI> _Nullable)busCardsBinding_bindWithDeviceID:(NSString *)deviceID
                                                       deviceType:(NSInteger)deviceType
                                                             card:(id<HMServiceAPIBUSCardsBindingCard>)card
                                                  completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    NSString *cardID = card.api_busCardsBindingCardID;

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

        long long openTime = (long long)[card.api_busCardsBindingCardLastUpdateTime timeIntervalSince1970];
        NSMutableDictionary *parameters = [@{@"appCode" : card.api_busCardsBindingCardCityCode,
                                             @"aid" : card.api_busCardsBindingCardApplicationID,
                                             @"openTime" : @(openTime),
                                             @"deviceType" : @(deviceType),
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_unbindWithDeviceID:(NSString *)deviceID
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_unbindWithDeviceID:(NSString *)deviceID
                                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }
    
    NSParameterAssert(deviceID.length > 0);
    if (deviceID.length == 0 ) {
        !completionBlock ?: completionBlock(NO, @"没有绑定设备");
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/devices/%@/busCards", userID, deviceID];
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_boundCardsWithDeviceID:(NSString *)deviceID
                                                        completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsBindingCard>> * _Nullable cards))completionBlock {
    
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_transactionRecordWithCityID:(NSString *)cityID
                                                                      cardID:(NSString *)cardID
                                                                        type:(HMServiceBUSCardsTransactionRecordType)type
                                                                    nextTime:(NSDate * _Nullable)nextTime
                                                                       limit:(NSInteger)limit
                                                             completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsTransactionRecord>> * _Nullable records, NSDate *  _Nullable nestTime))completionBlock {
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
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_uploadTransactionRecordWithCityID:(NSString *)cityID
                                                                            cardID:(NSString *)cardID
                                                                           records:(NSArray<id<HMServiceAPIBUSCardsTransactionRecord>> *)records
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
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableArray *recordDictionarys = [NSMutableArray array];
        for (id<HMServiceAPIBUSCardsTransactionRecord> record in records) {
            long long time =  (long long)(record.api_busCardsTransactionRecordTime.timeIntervalSince1970 * 1000);
            NSMutableDictionary *recordDictionary = [@{@"transactionType" : record.api_busCardsTransactionRecordType,
                                                       @"transactionTime" : @(time),
                                                       @"state" : record.api_busCardsTransactionRecordState,
                                                       @"amount" : @(record.api_busCardsTransactionRecordAmount)} mutableCopy];
            NSString *location = record.api_busCardsTransactionRecordLocation;
            NSString *serviceProvider = record.api_busCardsTransactionRecordServiceProvider;
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_verifyCaptchaWithPhone:(NSString *)phone
                                                        completionBlock:(void (^)(BOOL success, NSInteger httpCode, NSString * _Nullable message))completionBlock {
    
    if (!completionBlock) {
        return nil;
    }
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    
    if (userID.length == 0) {
        completionBlock(NO, 0, @"账号已经退出");
        return nil;
    }
    
    NSParameterAssert(phone.length > 0);
    if (phone.length == 0) {
        completionBlock(NO, 0, @"没有手机号");
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/requestCaptcha", userID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, 0, error.localizedDescription);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        
        NSMutableDictionary *parameters = [@{@"phone" : phone,
                                             @"userId" : userID} mutableCopy];
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, 0, error.localizedDescription);
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
                                   NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                   completionBlock(success, statusCode, message);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI> _Nullable)busCardsBinding_boundPhone:(NSString *)phone
                                              verifyCaptcha:(NSString *)verifyCaptcha
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
    
    NSParameterAssert(verifyCaptcha.length > 0);
    if (verifyCaptcha.length == 0) {
        completionBlock(NO, @"没有验证码");
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/verifyCaptcha", userID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        
        NSMutableDictionary *parameters = [@{@"phone" : phone,
                                             @"captcha" : verifyCaptcha} mutableCopy];
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription);
            });
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
                                    
                                    completionBlock(success, message);
                                }];
                   }];
    }];
}


- (id<HMCancelableAPI> _Nullable)busCardsBinding_citysWithCompletionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable citys))completionBlock {
    
    if (!completionBlock) {
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"busCardCities"];
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_cityWithID:(NSString *)cityID
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_openedCitiesWithDeviceID:(NSString *)deviceID
                                                          completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable citys))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSParameterAssert(deviceID.length > 0);
    if (deviceID.length == 0) {
        completionBlock(NO, @"没有设备ID", nil);
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWalletConfiguration> _Nullable configuration))completionBlock {

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

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        NSError *error = nil;
        NSMutableDictionary *otherHeaders = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"mode" : @"SINGLE",
                                             @"propertyName" : @"huami.mifit.user.phone"} mutableCopy];
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

- (id<HMCancelableAPI> _Nullable)busCardsBinding_cityWithDeviceID:(NSString *)deviceID
                                                  completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsCity>> * _Nullable cities))completionBlock {

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



@end
