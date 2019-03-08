//  HMServiceAPI+Authorization.m
//  Created on 2018/5/22
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+Authorization.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@interface NSDictionary (HMServiceAPIMinorAuthorization) <HMServiceAPIMinorAuthorization>
@end

@implementation NSDictionary (HMServiceAPIMinorAuthorization)

- (BOOL)api_minorAuthorization {
    return self.hmjson[@"required"].boolean;
}

- (NSInteger)api_minorAuthorizationDay {
    return self.hmjson[@"day"].integerValue;
}

@end

@implementation HMServiceAPI (Authorization)

- (id<HMCancelableAPI>)authorization_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIMinorAuthorization> minorAuthorization))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"users/%@/minorAuthorization", userID];
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:referenceURL];
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

        NSMutableDictionary *parameters = [@{@"userId" : userID} mutableCopy];
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

@end
