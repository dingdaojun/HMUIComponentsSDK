//
//  HMNetworkCore+Convenience.h
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore.h"

@interface HMNetworkCore (Convenience)

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                    timeout:(NSTimeInterval)timeout
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                     headers:(NSDictionary<NSString *, NSString *> *)headers
                                    timeout:(NSTimeInterval)timeout
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                     headers:(NSDictionary<NSString *, NSString *> *)headers
                                    timeout:(NSTimeInterval)timeout
                          requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
                         responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

@end


@interface HMNetworkCore (UploadConvenience)

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                            headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

@end


@interface HMNetworkCore (MultipartFormConvenience)

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                        responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                        responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                             progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;
@end
