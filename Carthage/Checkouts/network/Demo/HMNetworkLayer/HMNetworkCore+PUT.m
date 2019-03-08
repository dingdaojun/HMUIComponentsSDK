//
//  HMNetworkCore+PUT.m
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore+PUT.h"

@implementation HMNetworkCore (PUT)

+ (NSURLSessionDataTask *)PUT:(NSString *)URL
                   parameters:(id)parameters
              completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self PUT:URL parameters:parameters headers:nil timeout:0 completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)PUT:(NSString *)URL
                   parameters:(id)parameters
                       headers:(NSDictionary<NSString *, NSString *> *)headers
                      timeout:(NSTimeInterval)timeout
              completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self PUT:URL parameters:parameters headers:headers timeout:timeout
   requestDataFormat:HMNetworkRequestDataFormatHTTP responseDataFormat:HMNetworkResponseDataFormatJSON completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)PUT:(NSString *)URL
                   parameters:(id)parameters
                       headers:(NSDictionary<NSString *, NSString *> *)headers
                      timeout:(NSTimeInterval)timeout
            requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
           responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
              completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self PUT:URL parameters:parameters headers:headers timeout:timeout requestDataFormat:requestDataFormat responseDataFormat:responseDataFormat completionQueue:nil completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)PUT:(NSString *)URL
                   parameters:(id)parameters
                       headers:(NSDictionary<NSString *, NSString *> *)headers
                      timeout:(NSTimeInterval)timeout
            requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
           responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
              completionQueue:(dispatch_queue_t)completionQueue
              completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self requestWithMethod:HMNetworkHTTPMethodPUT URL:URL parameters:parameters headers:headers timeout:timeout requestDataFormat:requestDataFormat responseDataFormat:responseDataFormat completionQueue:completionQueue completionBlock:completionBlock];
}

@end
