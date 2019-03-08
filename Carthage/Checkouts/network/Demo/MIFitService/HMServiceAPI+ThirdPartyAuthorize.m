//
//  HMServiceAPI+ThirdPartyAuthorize.m
//  HMNetworkLayer
//
//  Created by 李宪 on 19/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+ThirdPartyAuthorize.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (ThirdPartyAuthorize)

- (id<HMCancelableAPI>)thirdPartyAuthorize_authorizeWithThirdPartyAppID:(NSString *)appID
                                                        completionBlock:(void (^)(BOOL success, NSString *message, NSString *redirectURL))completionBlock {
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(appID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.authorizeThirdApp.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"third_appid" : appID} mutableCopy];
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
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           
                                           NSString *redirectURL = nil;
                                           if (success) {
                                               redirectURL = data[@"redirect_url"];
                                           }
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message, redirectURL);
                                           }
                                       }];
                   }];
    }];
}



@end
