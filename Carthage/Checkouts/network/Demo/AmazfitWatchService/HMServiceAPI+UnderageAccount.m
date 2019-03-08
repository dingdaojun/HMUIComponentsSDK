//
//  HMServiceAPI+UnderageAccount.m
//  AmazfitWatch
//
//  Created by 李宪 on 2018/5/20.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+UnderageAccount.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (UnderageAccount)

- (id<HMCancelableAPI>)underageAccount_checkNeedCustodianApprovalWithCompletionBlock:(void (^)(BOOL success, NSString *message, BOOL needApproval, NSUInteger remainDays))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", NO, 0);
                });
            }
            return nil;
        }

        NSString *URL = [NSString stringWithFormat:@"users/%@/minorAuthorization", userID];
        URL = [self.delegate absoluteURLForService:self referenceURL:URL];

        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, NO, 0);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters addEntriesFromDictionary:[self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, NO, 0);
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

                                   if (!completionBlock) {
                                       return;
                                   }

                                   if (!success) {
                                       completionBlock(NO, message, NO, 0);
                                       return;
                                   }

                                   BOOL needApproval        = data.hmjson[@"required"].boolean;
                                   NSUInteger remainDays    = data.hmjson[@"day"].unsignedIntegerValue;

                                   completionBlock(YES, message, needApproval, remainDays);
                               }];
                  }];
    }];
}

@end
