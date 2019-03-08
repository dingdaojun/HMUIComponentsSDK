//
//  HMServiceAPI+Authorize.m
//  AmazfitWatch
//
//  Created by 朱立挺 on 2018/1/16.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Authorize.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


#define healthDataAuthorize_maxname @"md"

@interface NSDictionary (HMServiceAPIAuthorizeData) <HMServiceAPIAuthorizeData>
@end

@implementation NSDictionary (HMServiceAPIAuthorizeData)

- (BOOL)api_healthDataAuthorizeIsBind {
    return self.hmjson[@"isbind"].boolean;
}

-(NSString *)api_healthDataAuthorizeBindName {
    return self.hmjson[@"nickname"].string;
}

@end

@implementation HMServiceAPI (Authorize)

- (id<HMCancelableAPI>)healthDataAuthorize_checkWithCompletionBlock:(void (^)(BOOL success, NSString *message,id <HMServiceAPIAuthorizeData> authorizeData))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", nil);
                });
            }
            return nil;
        }

        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/v1/info/users.json"];
        
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
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"wxname"]        = healthDataAuthorize_maxname;
        parameters[@"userid"]        = userID;
        
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
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                   
                                   NSDictionary * dic = data[@"data"];
                                   if (![dic isKindOfClass:[NSDictionary class]]) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }
                                   
                                   completionBlock(success, message,dic);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)healthDataAuthorize_bindWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSString *bindInfo)) completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", nil);
                });
            }
            return nil;
        }

        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/v1/bind/qrcode.json"];
        
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
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"wxname"]        = healthDataAuthorize_maxname;
        parameters[@"userid"]        = userID;
        
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
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                   
                                   NSDictionary * dic = data[@"data"];
                                   if (![dic isKindOfClass:[NSDictionary class]]) {
                                       completionBlock(NO, @"数据类型错误", nil);
                                       return;
                                   }

                                   completionBlock(success, message, dic.hmjson[@"ticket"].string);
                               }];
                  }];
    }];
}
@end
