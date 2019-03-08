//
//  HMNetworkCore+HEAD.m
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore+HEAD.h"

@implementation HMNetworkCore (HEAD)

+ (NSURLSessionDataTask *)HEAD:(NSString *)URL
                    parameters:(id)parameters
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self HEAD:URL parameters:parameters headers:nil timeout:0 completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)HEAD:(NSString *)URL
                    parameters:(id)parameters
                        headers:(NSDictionary<NSString *, NSString *> *)headers
                       timeout:(NSTimeInterval)timeout
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self HEAD:URL parameters:parameters headers:headers timeout:timeout responseDataFormat:HMNetworkResponseDataFormatJSON completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)HEAD:(NSString *)URL
                    parameters:(id)parameters
                        headers:(NSDictionary<NSString *, NSString *> *)headers
                       timeout:(NSTimeInterval)timeout
            responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self HEAD:URL parameters:parameters headers:headers timeout:timeout responseDataFormat:HMNetworkResponseDataFormatJSON completionQueue:nil completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)HEAD:(NSString *)URL
                    parameters:(id)parameters
                        headers:(NSDictionary<NSString *, NSString *> *)headers
                       timeout:(NSTimeInterval)timeout
            responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
               completionQueue:(dispatch_queue_t)completionQueue
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    
    return [self requestWithMethod:HMNetworkHTTPMethodHEAD URL:URL parameters:parameters headers:headers timeout:timeout requestDataFormat:HMNetworkRequestDataFormatHTTP responseDataFormat:responseDataFormat completionQueue:completionQueue completionBlock:completionBlock];
}

@end
