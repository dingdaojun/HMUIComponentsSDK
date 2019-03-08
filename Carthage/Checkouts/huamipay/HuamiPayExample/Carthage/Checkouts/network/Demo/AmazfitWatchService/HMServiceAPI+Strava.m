//
//  HMServiceAPI+Strava.m
//  AmazfitWatch
//
//  Created by 李宪 on 2018/6/22.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Strava.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/HMCategoryKit.h>


@interface HMServiceAPIStravaUserInformation : NSObject <HMServiceAPIStravaUserInformation>
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *token;
@end

@implementation HMServiceAPIStravaUserInformation

- (NSString *)api_stravaUserInformationFirstName {
    return self.firstName;
}

- (NSString *)api_stravaUserInformationLastName {
    return self.lastName;
}

- (NSString *)api_stravaUserInformationToken {
    return self.token;
}

@end



@implementation HMServiceAPI (Strava)

- (id<HMCancelableAPI>)strava_retrieveUserInformationWithCompletionBlock:(void (^)(BOOL, NSString *, BOOL, id<HMServiceAPIStravaUserInformation>))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/third/certification.json?source=run.watch.huami.com&third_name=strava"];

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

        NSMutableDictionary *parameters = [NSMutableDictionary new];
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

                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                          if (!success) {
                                              completionBlock(NO, message, NO, nil);
                                              return;
                                          }

                                          NSString *token = data.hmjson[@"token"].string;
                                          if (token.length == 0) {
                                              completionBlock(YES, @"Unauthorized", NO, nil);
                                              return;
                                          }

                                          NSDictionary *headers = @{@"Authorization" : [@"Bearer " stringByAppendingString:token]};

                                          [HMNetworkCore GET:@"https://www.strava.com/api/v3/athlete"
                                                  parameters:nil
                                                     headers:headers
                                                     timeout:15
                                             completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                 if (error) {
                                                     completionBlock(YES, error.userInfo[NSLocalizedDescriptionKey], YES, nil);
                                                     return;
                                                 }

                                                 completionBlock(YES, message, NO, (id<HMServiceAPIStravaUserInformation>)data);
                                             }];
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)strava_authorizeWithCode:(NSString *)code
                                       clientID:(NSString *)clientID
                                   clientSecret:(NSString *)clientSecret
                                completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIStravaUserInformation>information))completionBlock {

    NSParameterAssert(code.length > 0);
    NSParameterAssert(clientID.length > 0 && clientSecret.length > 0);
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"client_id"]        = clientID;
        parameters[@"client_secret"]    = clientSecret;
        parameters[@"code"]             = code;

        return [HMNetworkCore POST:@"https://www.strava.com/oauth/token"
                        parameters:parameters
                   completionBlock:^(NSError *anError, NSURLResponse *response, NSDictionary *responseObject) {
                       if (anError) {
                           completionBlock(NO, anError.userInfo[NSLocalizedDescriptionKey], nil);
                           return;
                       }

                       HMServiceAPIStravaUserInformation *information   = [HMServiceAPIStravaUserInformation new];
                       information.firstName                            = responseObject.hmjson[@"athlete"][@"firstname"].string;
                       information.lastName                             = responseObject.hmjson[@"athlete"][@"lastname"].string;
                       information.token                                = responseObject.hmjson[@"access_token"].string;


                       NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/sport/third/certification.json"];

                       NSError *error = nil;
                       NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
                       if (error) {
                           if (completionBlock) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   completionBlock(NO, error.localizedDescription, nil);
                               });
                           }
                           return;
                       }


                       NSMutableDictionary *parameters = [NSMutableDictionary new];
                       parameters[@"source"]           = @"run.watch.huami.com";
                       parameters[@"third_name"]       = @"strava";
                       parameters[@"token"]            = information.token;
                       parameters[@"expire"]           = @0;

                       NSMutableDictionary *extra      = [NSMutableDictionary new];
                       {
                           NSMutableDictionary *userInfo   = [NSMutableDictionary new];
                           userInfo[@"firstname"]          = information.firstName;
                           userInfo[@"lastname"]           = information.lastName;
                           extra[@"user_info"]             = [userInfo toJSON:NO];
                       }
                       parameters[@"extra"]            = [extra toJSON:NO];

                       [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
                       if (error) {
                           if (completionBlock) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   completionBlock(NO, error.localizedDescription, nil);
                               });
                           }
                           return;
                       }

                       [HMNetworkCore POST:URL
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
                                               completionBlock:^(BOOL success, NSString *message, id data) {

                                                   if (!completionBlock) {
                                                       return;
                                                   }

                                                   if (!success) {
                                                       completionBlock(NO, message, nil);
                                                       return;
                                                   }

                                                   completionBlock(success, message, information);
                                               }];
                           }];
                   }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIStravaUserInformation) <HMServiceAPIStravaUserInformation>
@end

@implementation NSDictionary (HMServiceAPIStravaUserInformation)

- (NSString *)api_stravaUserInformationFirstName {
    NSString *firstname = self.hmjson[@"extra"][@"user_info"][@"firstname"].string;
    if (firstname.length == 0) {
        firstname = self.hmjson[@"extra"][@"user_info"][@"athlete"][@"firstname"].string;
    }
    return firstname;
}

- (NSString *)api_stravaUserInformationLastName {
    NSString *lastname = self.hmjson[@"extra"][@"user_info"][@"lastname"].string;
    if (lastname.length == 0) {
        lastname = self.hmjson[@"extra"][@"user_info"][@"athlete"][@"lastname"].string;
    }
    return lastname;
}

- (NSString *)api_stravaUserInformationToken {
    return self.hmjson[@"token"].string;
}

@end
