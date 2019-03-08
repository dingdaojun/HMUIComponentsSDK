//
//  HMServiceAPI+UserDataRank.m
//  HMNetworkLayer
//
//  Created by 李宪 on 28/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+UserDataRank.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (UserDataRank)

- (id<HMCancelableAPI>)userDataRank_stepRankInDay:(NSDate *)day
                                        stepCount:(NSUInteger)stepCount
                                  completionBlock:(void (^)(BOOL success, NSString *message, double beatPercentage))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", 0.0);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(day);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/user/ranks.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, 0);
                });
            }
            return nil;
        }
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dayString = [formatter stringFromDate:day];
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"record_type" : @"step",
                                             @"rank_time_type" : @"day",
                                             @"record" : @(stepCount),
                                             @"from_date" : dayString,
                                             @"to_date" : dayString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, 0);
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
                                          double beatPercentage = 0.f;
                                          
                                          if (success) {
                                              beatPercentage = data.hmjson[@"beat_percentage"].doubleValue;
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, beatPercentage);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)userDataRank_sleepRankInDay:(NSDate *)day
                                sleepTimeInMinutes:(NSUInteger)minutes
                                   completionBlock:(void (^)(BOOL success, NSString *message, double beatPercentage))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", 0.0);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(day);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/user/ranks.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, 0);
                });
            }
            return nil;
        }
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dayString = [formatter stringFromDate:day];
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"record_type" : @"sleep",
                                             @"rank_time_type" : @"day",
                                             @"record" : @(minutes),
                                             @"from_date" : dayString,
                                             @"to_date" : dayString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, 0);
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
                                          double beatPercentage = 0.f;
                                          
                                          if (success) {
                                              beatPercentage = data.hmjson[@"beat_percentage"].doubleValue;
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, beatPercentage);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)userDataRank_goalAchievementRankInDay:(NSDate *)day
                                                achievedDays:(NSUInteger)days
                                             completionBlock:(void (^)(BOOL success, NSString *message, double beatPercentage))completionBlock {
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", 0.0);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
       
        NSParameterAssert(day);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/user/ranks.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, 0);
                });
            }
            return nil;
        }
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dayString = [formatter stringFromDate:day];
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"record_type" : @"goal",
                                             @"record" : @(days),
                                             @"from_date" : dayString,
                                             @"to_date" : dayString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, 0);
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
                                          double beatPercentage = 0.f;
                                          
                                          if (success) {
                                              beatPercentage = data.hmjson[@"beat_percentage"].doubleValue;
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, beatPercentage);
                                          }
                                      }];
                  }];
    }];
}

@end
