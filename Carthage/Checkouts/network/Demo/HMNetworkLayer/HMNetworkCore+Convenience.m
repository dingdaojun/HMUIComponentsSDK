//
//  HMNetworkCore+Convenience.m
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore+Convenience.h"

@implementation HMNetworkCore (Convenience)

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self requestWithMethod:method URL:URL parameters:parameters timeout:0 completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                    timeout:(NSTimeInterval)timeout
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self requestWithMethod:method URL:URL parameters:parameters headers:nil timeout:timeout completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                     headers:(NSDictionary<NSString *, NSString *> *)headers
                                    timeout:(NSTimeInterval)timeout
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self requestWithMethod:method URL:URL parameters:parameters headers:nil timeout:timeout requestDataFormat:HMNetworkRequestDataFormatHTTP responseDataFormat:HMNetworkResponseDataFormatJSON completionBlock:completionBlock];
}

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                     headers:(NSDictionary<NSString *, NSString *> *)headers
                                    timeout:(NSTimeInterval)timeout
                          requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
                         responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    
    return [self requestWithMethod:method URL:URL parameters:parameters headers:headers timeout:timeout requestDataFormat:requestDataFormat responseDataFormat:responseDataFormat completionQueue:nil completionBlock:completionBlock];
}

@end


@implementation HMNetworkCore (UploadConvenience)

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromFile:filePath headers:nil completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromFile:filePath headers:headers timeout:0 completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromFile:filePath headers:headers timeout:timeout progressBlock:nil completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromFile:filePath headers:headers timeout:timeout responseDataFormat:HMNetworkResponseDataFormatJSON progressBlock:uploadProgressBlock completionQueue:nil completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromData:fileData headers:nil completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromData:fileData headers:headers timeout:0 completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromData:fileData headers:headers timeout:timeout progressBlock:nil completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self uploadRequestWithMethod:method URL:URL fromData:fileData headers:headers timeout:timeout responseDataFormat:HMNetworkResponseDataFormatJSON progressBlock:uploadProgressBlock completionQueue:nil completionBlock:completionBlock];
}

@end


@implementation HMNetworkCore (MultipartFormConvenience)

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self multipartFormRequestWithMethod:method URL:URL parameters:nil constructBlock:constuctBlock completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self multipartFormRequestWithMethod:method URL:URL parameters:parameters headers:nil constructBlock:constuctBlock completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self multipartFormRequestWithMethod:method URL:URL parameters:parameters headers:headers timeout:0 constructBlock:constuctBlock completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self multipartFormRequestWithMethod:method URL:URL parameters:parameters headers:headers timeout:timeout constructBlock:constuctBlock responseDataFormat:HMNetworkResponseDataFormatJSON completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                        responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self multipartFormRequestWithMethod:method URL:URL parameters:parameters headers:headers timeout:timeout constructBlock:constuctBlock responseDataFormat:responseDataFormat progressBlock:nil completionBlock:completionBlock];
}

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                        responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                             progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    return [self multipartFormRequestWithMethod:method URL:URL parameters:parameters headers:headers timeout:timeout constructBlock:constuctBlock responseDataFormat:responseDataFormat progressBlock:uploadProgressBlock completionQueue:nil completionBlock:completionBlock];
}

@end
