//  HMServiceAPI+EventReminder.m
//  Created on 2017/12/20
//  Description <#文件描述#>

//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+EventReminder.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@interface NSDictionary (HMServiceAPIEventReminderData) <HMServiceAPIEventReminderData>
@end

@implementation NSDictionary (HMServiceAPIEventReminderData)

- (long long)api_eventReminderCreatedDate {
    return (long long)self.hmjson[@"createdDate"].unsignedIntegerValue;
}

- (NSDate *)api_eventReminderStartDate {
    return [self.hmjson[@"startDate"] dateWithFormat:@"yyyy-MM-dd HH:mm"];
}

- (NSDate *)api_eventReminderStopDate {
    return [self.hmjson[@"stopDate"] dateWithFormat:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)api_eventReminderID {
    return [NSString stringWithFormat:@"%d", (int)self.hmjson[@"id"].integerValue];
}

- (NSString *)api_eventReminderLoop {
    return self.hmjson[@"loop"].string;
}

- (NSString *)api_eventReminderTitle {
    return self.hmjson[@"title"].string;
}

- (HMServiceAPIEventReminderFrom)api_eventReminderFrom {
    return self.hmjson[@"from"].integerValue;
}

- (HMServiceAPIEventReminderOperation)api_eventReminderOperation {
    return self.hmjson[@"op"].integerValue;
}

@end


@implementation HMServiceAPI (EventReminder)

- (id<HMCancelableAPI>)eventReminder_dataWithCount:(NSUInteger)count
                                            nextID:(NSString *)nextID
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIEventReminderData>> *eventReminderDatas, NSString *next))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil, nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/eventReminders/read", userID];

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"from" : @(0),
                                             @"limit" : @(count)} mutableCopy];

        if (nextID.length > 0) {
            [parameters setObject:nextID forKey:@"next"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, nil);
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
                                   NSString *next = data.hmjson[@"next"].string;

                                   if (completionBlock) {
                                       completionBlock(success, message, items, next);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)eventReminder_validDataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIEventReminderData>> *eventReminderDatas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/eventReminders/unread", userID];

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

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

        NSMutableDictionary *parameters = [@{@"from" : @(0)} mutableCopy];
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

- (id<HMCancelableAPI>)eventReminder_uploadWithDatas:(NSArray<id<HMServiceAPIEventReminderData>> *)datas
                                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/eventReminders", userID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

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

        NSArray *parameters = [self dictionaryWithEventReminderDatas:datas];

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
                                completionBlock:^(BOOL success, NSString *message, id data) {

                                    if (completionBlock) {
                                        completionBlock(success, message);
                                    }
                                }];
                   }];
    }];
}

- (NSArray *)dictionaryWithEventReminderDatas:(NSArray<id<HMServiceAPIEventReminderData>> *)datas {

    NSMutableArray *dictionarys = [NSMutableArray array];
    for (id<HMServiceAPIEventReminderData> data in datas) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";

        NSString *startDate = [formatter stringFromDate:data.api_eventReminderStartDate];
        NSString *stopDate = [formatter stringFromDate:data.api_eventReminderStopDate];

        NSDictionary *dictionary = @{@"createdDate" : @(data.api_eventReminderCreatedDate),
                                     @"from" : @(data.api_eventReminderFrom),
                                     @"id" : data.api_eventReminderID,
                                     @"loop" : data.api_eventReminderLoop,
                                     @"startDate" : startDate,
                                     @"stopDate" : stopDate,
                                     @"title" : data.api_eventReminderTitle,
                                     @"op" : @(data.api_eventReminderOperation)};
        [dictionarys addObject:dictionary];
    }

    return dictionarys;
}

- (id<HMCancelableAPI>)eventReminder_deleteWithData:(id<HMServiceAPIEventReminderData>)data
                                    completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        long long time = data.api_eventReminderCreatedDate;
        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/eventReminders/%lld", userID, time];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

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
                  responseDataFormat:HMNetworkResponseDataFormatJSON
                     completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                         [self handleResultForAPI:_cmd
                                    responseError:error
                                         response:response
                                   responseObject:responseObject
                                desiredDataFormat:HMServiceResultDataFormatAny
                                  completionBlock:^(BOOL success, NSString *message, id data) {

                                      if (completionBlock) {
                                          completionBlock(success, message);
                                      }
                                  }];
                     }];
    }];
}

@end
