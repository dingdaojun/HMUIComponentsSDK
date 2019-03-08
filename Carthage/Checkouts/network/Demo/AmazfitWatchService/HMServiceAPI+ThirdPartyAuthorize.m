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

- (id<HMCancelableAPI>)thirdPartyAuthorize_authorizeWithUserID:(NSString *)userID
                                               thirdPartyAppID:(NSString *)appID
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSString *redirectURL))completionBlock; {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(appID.length > 0);
        NSParameterAssert(userID.length > 0);
        
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

- (id<HMCancelableAPI>)thirdPartyAuthorize_authorizeForJavaScriptWithUserID:(NSString *)userID
                                                                     appKey:(NSString *)appKey
                                                                  timestamp:(NSString *)timestamp
                                                                      nonce:(NSString *)nonce
                                                                  signature:(NSString *)signature
                                                                     webURL:(NSString *)webURL
                                                                   apiNames:(NSArray<NSString *> *)apiNames
                                                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<NSString *> *authorizedAPINames))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(userID.length > 0);
        NSParameterAssert(appKey.length > 0);
        NSParameterAssert(timestamp.length > 0);
        NSParameterAssert(nonce.length > 0);
        NSParameterAssert(signature.length > 0);
        NSParameterAssert(webURL.length > 0);
        
        NSString *apiNamesString = [apiNames componentsJoinedByString:@","];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"jsbridge/verify"];
        
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
                                             @"appkey" : appKey,
                                             @"timestamp" : timestamp,
                                             @"nonceStr" : nonce,
                                             @"signature" : signature,
                                             @"url" : webURL,
                                             @"jsApiList" : apiNamesString} mutableCopy];
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
                                      completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                          
                                          NSArray *authorizedAPINames = nil;
                                          if (success) {
                                              authorizedAPINames = data.hmjson[@"jsApiList"].array;
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, authorizedAPINames);
                                          }
                                      }];
                  }];
    }];
}

@end
