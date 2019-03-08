//
//  Created on 2017/11/27
//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+Message.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

static NSString *stringWithMessageStatus(HMServiceAPIMessageStatus status) {
    switch (status) {
        case HMServiceAPIMessageStatusNew: return @"NEW";
        case HMServiceAPIMessageStatusRead: return @"READ";
        case HMServiceAPIMessageStatusDeleted: return @"DELETED";
    }
    return @"";
}

static HMServiceAPIMessageStatus messageStatusWithString(NSString *string) {
    NSDictionary *map = @{@"NEW" : @(HMServiceAPIMessageStatusNew),
                          @"READ" : @(HMServiceAPIMessageStatusRead),
                          @"DELETED" : @(HMServiceAPIMessageStatusDeleted)};
    return [map[string] integerValue];
}

static HMServiceAPIMessageType messageTypeWithString(NSString *string) {
    NSDictionary *map = @{@"FOLLOW_RELATION" : @(HMServiceAPIMessageTypeFriendRelation),
                          @"FOLLOW_DATA_UPDATE" : @(HMServiceAPIMessageTypeFriendDataUpdate),
                          @"FRIEND_NOTIFICATION" : @(HMServiceAPIMessageTypeFriendNotification),
                          @"FOLLOW_NOTIFY_MESSAGE" : @(HMServiceAPIMessageTypeFriendNotifyMessage),
                          @"FOLLOW_RELATION_AGREE" : @(HMServiceAPIMessageTypeFriendRelationAgree),
                          @"SHOW_SLEEP" : @(HMServiceAPIMessageTypeShowSleep),
                          @"SHOW_STEP" : @(HMServiceAPIMessageTypeShowStep),
                          @"SHOW_HEART_RATE" : @(HMServiceAPIMessageTypeShowHeartRate),
                          @"SHOW_HRV" : @(HMServiceAPIMessageTypeShowHRV),
                          @"SHOW_BODY" : @(HMServiceAPIMessageTypeShowBody),
                          @"WEB_VIEW" : @(HMServiceAPIMessageTypeWebview),
                          @"ACTIVITY" : @(HMServiceAPIMessageTypeActivity),
                          @"DATA_REPORT" : @(HMServiceAPIMessageTypeDataReport),
                          @"MIFIT_CIRCLE" : @(HMServiceAPIMessageTypeMifitCircle),
                          @"MIFIT_PRIVATE_MESSAGE" : @(HMServiceAPIMessageTypeMifitPrivateMessage)};
    return [map[string] integerValue];
}


@interface NSDictionary (HMServiceAPIMessageData) <HMServiceAPIMessageData>
@end

@implementation NSDictionary (HMServiceAPIMessageData)

- (NSString *)api_messageID {
    return self.hmjson[@"messageId"].string;
}

- (NSString *)api_messageTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_messageContent {
    return self.hmjson[@"text"].string;
}

- (NSString *)api_messageDataFolloweeID {
    return self.hmjson[@"followeeId"].string;
}

- (NSString *)api_messageUrl {
    return self.hmjson[@"url"].string;
}

- (NSString *)api_messageNickName {
    return self.hmjson[@"nickName"].string;
}

- (NSString *)api_messageDataIconUrl {
    return self.hmjson[@"iconUrl"].string;
}

- (NSDate *)api_messageDataTime {
    return self.hmjson[@"generateTime"].date;
}

- (NSInteger)api_messageDataCount {
    return self.hmjson[@"count"].integerValue;
}

- (HMServiceAPIMessageStatus)api_messageStatus {
    return messageStatusWithString(self.hmjson[@"status"].string);
}

- (HMServiceAPIMessageType)api_messageType {
    return messageTypeWithString(self.hmjson[@"type"].string);
}

@end


@interface NSDictionary (HMServiceAPIMessageMifitCircleUserInfoData) <HMServiceAPIMessageMifitCircleUserInfoData>
@end

@implementation NSDictionary (HMServiceAPIMessageMifitCircleUserInfoData)

- (NSString *)api_mifitCircleUserInfoAvatar {
    return self.hmjson[@"avatar"].string;
}

- (NSString *)api_mifitCircleUserInfoSummary {
    return self.hmjson[@"summary"].string;
}

- (NSString *)api_mifitCircleUserInfoID {
    return self.hmjson[@"userID"].string;
}

- (NSString *)api_mifitCircleUserInfoNickName {
    return self.hmjson[@"userName"].string;
}

- (HMServiceAPIMessageMifitCircleUserInfoGrade)api_mifitCircleUserInfoGrade {
    return self.hmjson[@"type"].integerValue;
}

- (HMServiceAPIMessageMifitCircleUserInfoStatus)api_mifitCircleUserInfoStatus {
    return mifitCircleFollowStatusWithString(self.hmjson[@"followStatus"].string);
}

- (BOOL)api_mifitCircleUserInfReceiveStrangerMessage {
    return (self.hmjson[@"chatWithStranger"].integerValue == 0) ? YES : NO;
}

@end


@interface NSDictionary (HMServiceAPIMessageMifitCircleData) <HMServiceAPIMessageMifitCircleData>
@end

@implementation NSDictionary (HMServiceAPIMessageMifitCircleData)

- (NSString *)api_mifitCircleCommentContent {
    return self.hmjson[@"commentContent"].string;
}

- (NSString *)api_mifitCircleCommentID {
    return self.hmjson[@"commentID"].string;
}

- (NSString *)api_mifitCircleContent {
    return self.hmjson[@"content"].string;
}

- (NSString *)api_mifitCirclePostID {
    return self.hmjson[@"postID"].string;
}

- (NSString *)api_mifitCirclePostImage {
    return self.hmjson[@"postImg"].string;
}

- (NSDate *)api_mifitCircleDate {
    return self.hmjson[@"time"].date;
}

- (NSString *)api_mifitCircleTopicID {
    return self.hmjson[@"topicID"].string;
}

- (NSUInteger)api_mifitCircleUnreadCount {
    return self.hmjson[@"unread"].integerValue;
}

- (HMServiceAPIMessageMifitCircleType)api_mifitCircleType {
    return self.hmjson[@"type"].integerValue;
}

- (id<HMServiceAPIMessageMifitCircleUserInfoData>)api_mifitCircleUserInfo {
    return self.hmjson[@"userInfo"].dictionary;
}

- (id<HMServiceAPIMessageMifitCircleUserInfoData>)api_mifitCircleReceiveUserInfo {
    return self.hmjson[@"reUserInfo"].dictionary;
}

@end

@implementation HMServiceAPI (Message)


- (id<HMCancelableAPI>)message_dataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIMessageData>> *messageDatas))completionBlock {
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/messageCenter", userID];
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

- (id<HMCancelableAPI>)message_updateWithMessageID:(NSString *)messageID
                                            status:(HMServiceAPIMessageStatus)status
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }
    //    PUT /users/{userId}/messageCenter/{messageType}/messages/{messageId}

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/messageCenter", userID];
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
        
        NSMutableDictionary *parameters = [@{@"status" : stringWithMessageStatus(status),
                                             @"messageId" : messageID} mutableCopy];
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore PUT:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                requestDataFormat:HMNetworkRequestDataFormatHTTP
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


- (id<HMCancelableAPI>)message_mifitCircleWithCount:(NSInteger)count
                                            lastKey:(NSString *)lastKey
                                         newMessage:(BOOL)newMessage
                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIMessageMifitCircleData>> *mifitCircleDatas, NSString *nextKey))completionBlock {
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil, nil);
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *key = lastKey.length>0?lastKey:@"-1";
        NSString *referenceURL = [NSString stringWithFormat:@"v1/soc/user/%@/msg/list/%@/%@/%d", userID, newMessage?@"1":@"2", key,(int)count];
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

- (id<HMCancelableAPI>)message_mifitCircleDeleteWithCompletionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{


        NSString *referenceURL = [NSString stringWithFormat:@"v1/soc/user/%@/msg/-1/del", userID];
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



@end
