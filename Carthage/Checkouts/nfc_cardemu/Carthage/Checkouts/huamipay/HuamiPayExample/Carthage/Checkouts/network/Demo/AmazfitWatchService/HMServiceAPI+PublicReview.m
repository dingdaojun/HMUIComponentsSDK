//
//  HMServiceAPI+PublicReview.m
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+PublicReview.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (PublicReview)

- (id<HMCancelableAPI>)publicReview_checkWithCompletionBlock:(void (^)(BOOL success, NSString *message, BOOL joined, NSString *email))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", NO, nil);
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/romPublicPreview", userID]];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, NO, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, NO, nil);
                });
            }
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   BOOL joined     = data.hmjson[@"isInRomPreview"].boolean;
                                   NSString *email = data.hmjson[@"email"].string;


                                   if (completionBlock) {
                                       completionBlock(success, message, joined, email);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)publicReview_applyWithRomSerialNumber:(NSString *)romSerialNumber
                                             completionBlock:(void (^)(BOOL success, NSString *message, BOOL joined))completionBlock {

    NSParameterAssert(romSerialNumber.length > 0);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", NO);
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/romPublicPreview", userID]];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, NO);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sn"] = romSerialNumber;
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, NO);
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

                                    if (!completionBlock) {
                                        return;
                                    }

                                    if (error.code == 409) {
                                        completionBlock(YES, message, NO);
                                        return;
                                    }

                                    if (!success) {
                                        completionBlock(NO, message, NO);
                                        return;
                                    }

                                    completionBlock(YES, message, YES);
                                }];
                   }];
    }];
}

- (id<HMCancelableAPI>)publicReview_quitWithCompletionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/romPublicPreview", userID]];

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
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                    if (completionBlock) {
                                        completionBlock(YES, message);
                                    }
                                }];
                   }];
    }];
}

- (id<HMCancelableAPI>)publicReview_submitEmail:(NSString *)email
                                       userName:(NSString *)userName
                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSParameterAssert(email.length > 0);
    NSParameterAssert(userName.length > 0);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }


        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"/users/%@/addEmail", userID]];

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

        NSMutableDictionary *parameters = [@{@"email" : email,
                                             @"userName" : userName} mutableCopy];
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
                                completionBlock:^(BOOL success, NSString *message, id data) {
                                    
                                    if (completionBlock) {
                                        completionBlock(success, message);
                                    }
                                }];
                   }];
    }];
}

@end
