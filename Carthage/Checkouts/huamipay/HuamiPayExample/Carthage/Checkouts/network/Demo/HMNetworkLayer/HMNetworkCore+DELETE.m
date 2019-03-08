//
//  HMNetworkCore+DELETE.m
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore+DELETE.h"

@implementation HMNetworkCore (DELETE)

+ (NSURLSessionDataTask *)DELETE:(NSString *)URL
                      parameters:(id)parameters
                 completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self DELETE:URL parameters:parameters headers:nil timeout:0 completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)URL
                      parameters:(id)parameters
                          headers:(NSDictionary<NSString *, NSString *> *)headers
                         timeout:(NSTimeInterval)timeout
                 completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self DELETE:URL parameters:parameters headers:headers timeout:timeout responseDataFormat:HMNetworkResponseDataFormatJSON completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)URL
                      parameters:(id)parameters
                          headers:(NSDictionary<NSString *, NSString *> *)headers
                         timeout:(NSTimeInterval)timeout
              responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                 completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self DELETE:URL parameters:parameters headers:headers timeout:timeout responseDataFormat:HMNetworkResponseDataFormatJSON completionQueue:nil completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)URL
                      parameters:(id)parameters
                          headers:(NSDictionary<NSString *, NSString *> *)headers
                         timeout:(NSTimeInterval)timeout
              responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                 completionQueue:(dispatch_queue_t)completionQueue
                 completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    
    return [self requestWithMethod:HMNetworkHTTPMethodDELETE URL:URL parameters:parameters headers:headers timeout:timeout requestDataFormat:HMNetworkRequestDataFormatHTTP responseDataFormat:responseDataFormat completionQueue:completionQueue completionBlock:completionBlock];
}

@end
