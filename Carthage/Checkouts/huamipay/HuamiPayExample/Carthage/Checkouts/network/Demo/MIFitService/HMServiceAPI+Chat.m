//  HMServiceAPI+Chat.m
//  Created on 2017/12/21
//  Description <#文件描述#>

//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+Chat.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

static NSString *stringWithReportCategory(HMServiceAPIChatReportCategory category) {
    switch (category) {
        case HMServiceAPIChatReportCategoryPornographic: return @"1";
        case HMServiceAPIChatReportCategoryHarass: return @"2";
        case HMServiceAPIChatReportCategoryAdvertisement: return @"3";
        case HMServiceAPIChatReportCategoryOther: return @"4";
    }
    return @"";
}


@interface NSDictionary (HMServiceAPIChatData) <HMServiceAPIChatData>
@end

@implementation NSDictionary (HMServiceAPIChatData)

- (NSString *)api_chatContent {
    return self.hmjson[@"content"].string;
}

- (NSDate *)api_chatSendTime {
    return self.hmjson[@"sendTime"].date;
}

- (NSString *)api_chatOtherUserID {
    NSDictionary *userInfo = self.hmjson[@"userInfo"].dictionary;
    return userInfo.hmjson[@"userID"].string;
}

@end

@implementation HMServiceAPI (Chat)

- (id<HMCancelableAPI>)chat_uploadWithOtherUserID:(NSString *)otherUserID
                                          content:(NSString *)content
                                  completionBlock:(void (^)(BOOL success, NSString *message, HMServiceAPIChatErrorCode errorCode))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", NO);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/v1/soc/chat/msg/add"];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, HMServiceAPIChatErrorCodeUnkown);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"otherUserID" : otherUserID,
                                             @"content" : content} mutableCopy];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];

        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, HMServiceAPIChatErrorCodeUnkown);
                });
            }
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatHTTP
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                           if (!completionBlock) {
                                               return;
                                           }
                                           if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                               completionBlock(success, message, NO);
                                               return;
                                           }

                                           HMServiceAPIChatErrorCode errorCode = HMServiceAPIChatErrorCodeUnkown;

                                           NSInteger code = [responseObject[@"code"] integerValue];
                                           if (code == 701002) {
                                               errorCode = HMServiceAPIChatErrorCodeUnFollow;
                                           }
                                           else if (code == 601004) {
                                               errorCode = HMServiceAPIChatErrorCodeGag;
                                           }

                                           completionBlock(success, message, errorCode);
                                       }];
                   }];
    }];
}


- (id<HMCancelableAPI>)chat_queryUnreadMessageWithOtherUserID:(NSString *)otherUserID
                                                 lastItemTime:(NSTimeInterval)lastItemTime
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIChatData>> *chatDatas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        long time = (long)(lastItemTime * 1000);
        NSString *referenceURL = [NSString stringWithFormat:@"/v1/soc/chat/heartBeat/msgList/%@/%ld", otherUserID, (long)time];
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

                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSArray *data) {

                                          if (completionBlock) {
                                              completionBlock(success, message, data);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)chat_queryMessageWithOtherUserID:(NSString *)otherUserID
                                            lastItemKey:(NSString *)lastItemKey
                                                  count:(NSUInteger)count
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIChatData>> *chatDatas, NSString *lastItemKey))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil, nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"/v1/soc/chat/msgList/%@/%@/%d", otherUserID, lastItemKey, (int)count];
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

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

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

                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSArray *data) {

                                          NSString *lastItemKey = nil;

                                          if (data.count > 0 && [responseObject isKindOfClass:[NSDictionary class]]) {
                                              NSDictionary *response = (NSDictionary *)responseObject;

                                              NSDictionary *keyDictionary = response.hmjson[@"nextStartKey"].dictionary;
                                              lastItemKey = keyDictionary.hmjson[@"lastItemKey"].string;
                                          }

                                          if (completionBlock) {
                                              completionBlock(success, message, data, lastItemKey);
                                          }
                                      }];
                  }];
    }];
}


- (id<HMCancelableAPI>)chat_reportWithOtherUserID:(NSString *)otherUserID
                                         category:(HMServiceAPIChatReportCategory)category
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {


    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/v1/soc/report"];

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

        NSMutableDictionary *parameters = [@{@"id" : otherUserID,
                                             @"category" : stringWithReportCategory(category),
                                             @"type" : @3} mutableCopy];
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
                 requestDataFormat:HMNetworkRequestDataFormatHTTP
                responseDataFormat:HMNetworkResponseDataFormatJSON
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

- (id<HMCancelableAPI>)chat_followWithOtherUserID:(NSString *)otherUserID
                                  completionBlock:(void (^)(BOOL success, HMServiceAPIMessageMifitCircleUserInfoStatus follow, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"v1/soc/user/%@/follow/%@", userID, otherUserID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, NO, error.localizedDescription);
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

                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           
                                           if (completionBlock) {

                                               HMServiceAPIMessageMifitCircleUserInfoStatus followStatus = HMServiceAPIMessageMifitCircleUserInfoStatusUnfollow;
                                               if (success && data) {
                                                   followStatus = mifitCircleFollowStatusWithString(data.hmjson[@"followStatus"].string);
                                               }

                                               completionBlock(success, followStatus, message);
                                           }
                                       }];
                   }];
    }];
}


@end
