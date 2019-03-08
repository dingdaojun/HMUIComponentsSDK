//
//  HMNetworkCore+POST.h
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore.h"

@interface HMNetworkCore (POST)

+ (NSURLSessionDataTask *)POST:(NSString *)URL
                    parameters:(id)parameters
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)POST:(NSString *)URL
                    parameters:(id)parameters
                        headers:(NSDictionary<NSString *, NSString *> *)headers
                       timeout:(NSTimeInterval)timeout
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)POST:(NSString *)URL
                    parameters:(id)parameters
                        headers:(NSDictionary<NSString *, NSString *> *)headers
                       timeout:(NSTimeInterval)timeout
             requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
            responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)POST:(NSString *)URL
                    parameters:(id)parameters
                        headers:(NSDictionary<NSString *, NSString *> *)headers
                       timeout:(NSTimeInterval)timeout
             requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
            responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
               completionQueue:(dispatch_queue_t)completionQueue
               completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

@end
