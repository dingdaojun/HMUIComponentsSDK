//
//  HMServiceAPI+Social.m
//  HMNetworkLayer
//
//  Created by 李宪 on 20/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Social.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (Social)

- (id<HMCancelableAPI>)social_searchUserByID:(NSString *)searchUserID
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialUser>> *users))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(searchUserID.length > 0);

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/search/%@", userID, searchUserID]];

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

        NSDictionary *parameters = [self.delegate uniformParametersForService:self error:&error];
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
                                   NSMutableArray *friends = [NSMutableArray array];
                                   if (success) {
                                       for (NSDictionary *friend in data.hmjson[@"items"].array) {
                                           if (friend.hmjson[@"friend"].integerValue != -1) {
                                               [friends addObject:friend];
                                           }
                                       }
                                   }

                                   if (completionBlock) {
                                       completionBlock(success, message, friends);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)social_friendsWithOffset:(NSUInteger)offset
                                completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialUser>> *users, BOOL more))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil, 0);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSUInteger pageSize = 10;
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.userFriend.getFriendList.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, 0);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"start_uid" : @"",
                                             @"stop_uid" : @"",
                                             @"limit" : @(pageSize),
                                             @"offset" : @(offset),
                                             @"userid" : userID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, 0);
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           NSArray *users = nil;
                                           BOOL more = NO;
                                           
                                           if (success) {
                                               users = data;
                                               more = (users.count >= pageSize);
                                           }
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message, users, more);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_applyForFriendToUserID:(NSString *)toUserID
                                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(toUserID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.pushMessage.sendInvitation.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"to_uid" : toUserID,
                                             @"userid" : userID} mutableCopy];
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_acceptFriendInvitationFromUserID:(NSString *)fromUserID
                                               completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPISocialUser>user))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(fromUserID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.pushMessage.acceptInvitation.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"from_uid" : fromUserID,
                                             @"userid" : userID,
                                             @"status" : @1} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
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
                                       completionBlock:^(BOOL success, NSString *message, NSArray *data) {
                                           id user = nil;
                                           if (success) {
                                               if ([data isKindOfClass:[NSArray class]]) {
                                                   user = data.firstObject;
                                               }
                                           }
                                           completionBlock(success, message, user);
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_rejectFriendInvitationFromUserID:(NSString *)fromUserID
                                               completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(fromUserID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.pushMessage.acceptInvitation.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"from_uid" : fromUserID,
                                             @"userid" : userID,
                                             @"status" : @0} mutableCopy];
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_deleteFriendWithUserID:(NSString *)friendUserID
                                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(friendUserID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.userFriend.removeRelationship.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"to_uid" : friendUserID,
                                             @"userid" : userID} mutableCopy];
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_sendConcernToFriendWithUserID:(NSString *)friendUserID
                                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(friendUserID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.userFriend.remindFriend.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"to_uid" : friendUserID,
                                             @"userid" : userID} mutableCopy];
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_friendHealthDataWithFriendUserID:(NSString *)friendUserID
                                                      fromDate:(NSDate *)fromDate
                                                       endDate:(NSDate *)endDate
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSArray *healthData))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(friendUserID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.userFriend.getUserFriendInfo.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"f_uid" : friendUserID,
                                             @"userid" : userID} mutableCopy];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        if (fromDate) {
            parameters[@"from_date"] = [dateFormatter stringFromDate:fromDate];
        }
        if (endDate) {
            parameters[@"to_date"] = [dateFormatter stringFromDate:endDate];
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
        
        return [HMNetworkCore POST:URL
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

- (id<HMCancelableAPI>)social_friendMessagesWithOffset:(NSUInteger)offset
                                       completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialMessage>> *messages, BOOL more))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil, NO);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSUInteger pageSize = 10;
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.pushMessage.getMsgList.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, NO);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"limit" : @(pageSize),
                                             @"offset" : @(offset),
                                             @"userid" : userID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, NO);
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           NSArray *messages = nil;
                                           BOOL more = NO;
                                           
                                           if (success) {
                                               messages = data;
                                               more = (messages.count >= pageSize);
                                           }
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message, messages, more);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)social_modifyFriendRemark:(NSString *)remark
                                    friendUserID:(NSString *)friendUserID
                                 completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(remark.length > 0);
        NSParameterAssert(friendUserID.length > 0);

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.band.userFriend.updateFriendNick.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"to_uid" : friendUserID,
                                             @"nick" : remark,
                                             @"userid" : userID} mutableCopy];
        
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
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}


- (id<HMCancelableAPI>)social_shareWithAvatar:(NSString *)avatar
                                     nickName:(NSString *)nickName
                              completionBlock:(void (^)(BOOL success, NSString *message, NSString *shareUrl))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"t/friends"];

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

        NSMutableDictionary *parameters = [@{@"uid" : userID} mutableCopy];
        if (nickName.length > 0) {
            [parameters setObject:nickName forKey:@"nickname"];
        }
        if (avatar.length > 0) {
            [parameters setObject:nickName forKey:@"avatar"];
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

        return [HMNetworkCore POST:URL
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

                                    NSString *url = data.hmjson[@"tinyurl"].string;
                                    if (completionBlock) {
                                        completionBlock(success, message, url);
                                    }
                                }];
                   }];
    }];
}

@end


#pragma mark - Decode response data

@interface NSDictionary (HMServiceAPISocialUser) <HMServiceAPISocialUser>
@end

@implementation NSDictionary (HMServiceAPISocialUser)

- (NSString *)api_socialUserID {
    return self.hmjson[@"uid"].string;
}

- (NSString *)api_socialUserName {
    return self.hmjson[@"username"].string;
}

- (NSString *)api_socialUserAvatarURL {
    return self.hmjson[@"pic"].string;
}

- (BOOL)api_socialUserIsFriend {
    return self.hmjson[@"friend"].boolean;
}

- (NSDate *)api_socialUserBecameFriendTime {
    return self.hmjson[@"addts"].date;
}

- (NSDate *)api_socialUserUpdateTime {
    return self.hmjson[@"update_ts"].date;
}

- (NSString *)api_socialUserRemark {
    return self.hmjson[@"nick"].string;
}

- (NSUInteger)api_socialUserSendConcernTimes {
    return self.hmjson[@"slove"].unsignedIntegerValue;
}

- (NSUInteger)api_socialUserReceiveConcernTimes {
    return self.hmjson[@"rlove"].unsignedIntegerValue;
}

- (NSUInteger)api_socialUserStepCount {
    return self.hmjson[@"step"].unsignedIntegerValue;
}

- (NSUInteger)api_socialUserSleepMinutes {
    return self.hmjson[@"sleep"].unsignedIntegerValue;
}

- (double)api_socialUserWeight {
    return self.hmjson[@"w"].doubleValue;
}

@end


@interface NSDictionary (HMServiceAPISocialUserHealthData) <HMServiceAPISocialUserHealthData>
@end

@implementation NSDictionary (HMServiceAPISocialUserHealthData)

- (NSDate *)api_socialUserHealthDataDate {
    return self.hmjson[@"date"].date;
}

- (NSUInteger)api_socialUserHealthDataStepCount {
    return self.hmjson[@"step"].unsignedIntegerValue;
}

- (NSUInteger)api_socialUserHealthDataDistanceInMeters {
    return self.hmjson[@"distance"].unsignedIntegerValue;
}

- (NSDate *)api_socialUserHealthDataSleepBeginTime {
    return self.hmjson[@"startSleep"].date;
}

- (NSDate *)api_socialUserHealthDataSleepEndTime {
    return self.hmjson[@"sleepEndTime"].date;
}

- (NSUInteger)api_socialUserHealthDataDeepSleepMinutes {
    return self.hmjson[@"deepsleep"].unsignedIntegerValue;
}

- (NSUInteger)api_socialUserHealthDataLightSleepMinutes {
    return self.hmjson[@"shallowsleep"].unsignedIntegerValue;
}

- (NSUInteger)api_socialUserHealthDataManuallySleepMinutes {
    return self.hmjson[@"manualSleep"].unsignedIntegerValue;
}

- (double)api_socialUserHealthDataCalorie {
    return self.hmjson[@"calorie"].unsignedIntegerValue;
}

@end


@interface NSDictionary (HMServiceAPISocialMessage) <HMServiceAPISocialMessage>
@end

@implementation NSDictionary (HMServiceAPISocialMessage)

- (NSString *)api_socialMessageID {
    return self.hmjson[@"msg_id"].string;
}

- (NSDate *)api_socialMessageTime {
    return self.hmjson[@"timestamp"].date;
}

- (HMServiceAPISocialMessageType)api_socialMessageType {
    
    NSDictionary *map = @{@"care" : @(HMServiceAPISocialMessageTypeRemindFriend),
                          @"follow" : @(HMServiceAPISocialMessageTypeApplyFriend),
                          @"follow_accept" : @(HMServiceAPISocialMessageTypeAcceptFriend),
                          @"follow_reject" : @(HMServiceAPISocialMessageTypeRejectFriend),
                          @"unfollow" : @(HMServiceAPISocialMessageTypeDeleteFriend)};
    
    NSString *typeString = self.hmjson[@"msg_type"].string;
    return [map[typeString] integerValue];
}

- (NSString *)api_socialMessageFromUserID {
    return self.hmjson[@"uid"].string;
}

- (NSString *)api_socialMessageToUserID {
    return self.hmjson[@"to_uid"].string;
}

@end
