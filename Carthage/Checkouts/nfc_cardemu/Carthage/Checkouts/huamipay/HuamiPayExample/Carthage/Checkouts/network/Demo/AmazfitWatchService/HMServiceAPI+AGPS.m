//
//  HMServiceAPI+AGPS.m
//  HuamiWatch
//
//  Created by dingdaojun on 2017/8/1.
//  Copyright © 2017年 Huami. All rights reserved.
//

#import "HMServiceAPI+AGPS.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (AGPS)

- (id<HMCancelableAPI>)agps_retrieveAGPSFileInfoWithCompletionBlock:(void (^)(BOOL, NSString *, id<HMServiceAPIAGPS>agps))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"/apps/%@/fileTypes/AGPSZIP/files", bundleIdentifier]];
        
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
                               completionBlock:^(BOOL success, NSString *message, NSArray *data) {
                                   
                                   if (!completionBlock) {
                                       return;
                                   }
                                   
                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }
                                   
                                   completionBlock(YES, message, data.firstObject);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)agps_retrieveBEPFileInfoWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIBEP>bep))completionBlock {
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"/apps/%@/fileTypes/EPHZIP/files", bundleIdentifier]];
        
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
                               completionBlock:^(BOOL success, NSString *message, NSArray *data) {
                                   
                                   if (!completionBlock) {
                                       return;
                                   }
                                   
                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }
                                   
                                   completionBlock(YES, message, data.firstObject);
                               }];
                  }];
    }];
}
@end

#pragma mark - NSDictionary Category -- AGPS
@interface NSDictionary (HMServiceAPIAGPS) <HMServiceAPIAGPS>
@end

@implementation NSDictionary (HMServiceAPIAGPS)

- (NSString *)api_AGPSFileType {
    return self.hmjson[@"fileType"].string;
}

- (NSString *)api_AGPSFileURL {
    return self.hmjson[@"fileUrl"].string;
}

- (NSUInteger)api_AGPSDays {
    return self.hmjson[@"days"].unsignedIntegerValue;
}

@end

#pragma mark - NSDictionary Category -- BEP
@interface NSDictionary (HMServiceAPIBEP) <HMServiceAPIBEP>
@end

@implementation NSDictionary (HMServiceAPIBEP)

- (NSString *)api_BEPFileType {
    return self.hmjson[@"fileType"].string;
}

- (NSString *)api_BEPFileURL {
    return self.hmjson[@"fileUrl"].string;
}

@end
