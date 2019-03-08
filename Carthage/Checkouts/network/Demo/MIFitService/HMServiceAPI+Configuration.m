//  HMServiceAPI+Configuration.m
//  Created on 2018/5/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+Configuration.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Configuration)

- (id<HMCancelableAPI>)configuration_retrieveWithCompletionBlock1:(void (^)(BOOL success, NSString *message, NSDictionary *configuration))completionBlock {

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
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"propertyName" : @"huami.mifit.user.settings.",
                                             @"mode" : @"RANGE"} mutableCopy];
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

                                   completionBlock(success, message, data);
                               }];
                  }];
    }];
}


- (id<HMCancelableAPI>)configuration_update:(NSDictionary *)configuration
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
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

        NSMutableDictionary *parameters = [@{@"properties" : configuration} mutableCopy];
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
                              desiredDataFormat:HMServiceResultDataFormatDictionary
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                    completionBlock(success, message);
                                }];
                   }];
    }];
}


@end
