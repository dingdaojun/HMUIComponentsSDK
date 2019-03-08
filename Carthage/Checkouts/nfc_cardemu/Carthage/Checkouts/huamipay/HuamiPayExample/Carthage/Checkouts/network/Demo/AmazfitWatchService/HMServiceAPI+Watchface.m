//
//  HMServiceAPI+Watchface.m
//  AmazfitWatch
//
//  Created by hongzhiqiang on 2018/5/2.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Watchface.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (Watchface)

- (id<HMCancelableAPI>)watchface_queryWatchfaceInfo:(NSString *)serviceName
                                    completionBlock:(void (^)(BOOL, NSString *, NSString *))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, nil, nil);
                });
            }
            return nil;
        }
        
        NSString *URL = [self.delegate
                         absoluteURLForService:self
                         referenceURL:[NSString stringWithFormat:@"discovery/watch/discovery/amazfit_watch_skins?userid=%@", userID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, nil, nil);
                });
            }
            return nil;
        }
    
        NSMutableDictionary *parameters = [NSMutableDictionary new];
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
                             desiredDataFormat:HMServiceResultDataFormatArray
                               completionBlock:^(BOOL success, NSString *message, NSArray *watchfaces) {
                                   
                                   if (!completionBlock) {
                                       return;
                                   }
                                   
                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }
                                   
                                   
                                   NSUInteger index = [watchfaces
                                                       indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                                                           NSString *watchServiceName = [obj.hmjson[@"extensions"][@"assets"][@"bins"][0][@"src"].string componentsSeparatedByString:@"/"].lastObject;
                                                           return [serviceName containsString:watchServiceName];
                                                       }];
                                   
                                   if (index == NSNotFound) {
                                       completionBlock(NO, nil, nil);
                                       return;
                                   }
                                   
                                   NSDictionary *watchFace  = watchfaces[index];
                                   
                                   NSString *imageURL       = watchFace.hmjson[@"image"].string;
                                   NSString *title          = watchFace.hmjson[@"title"].string;
                                   completionBlock(YES, imageURL, title);
                               }];
                  }];
    }];
}

@end
