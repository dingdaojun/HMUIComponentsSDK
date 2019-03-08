//
//  HMNetworkCore.h
//  HMNetworkLayer
//
//  Created by 李宪 on 11/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMMultipartFormData;

typedef NS_ENUM(NSUInteger, HMNetworkHTTPMethod) {
    HMNetworkHTTPMethodGET,
    HMNetworkHTTPMethodHEAD,
    HMNetworkHTTPMethodPOST,
    HMNetworkHTTPMethodPUT,
    HMNetworkHTTPMethodPATCH,
    HMNetworkHTTPMethodDELETE,
};

typedef NS_ENUM(NSUInteger, HMNetworkRequestDataFormat) {
    HMNetworkRequestDataFormatHTTP, // query string parameters for `GET`, `HEAD`, and `DELETE` requests, or otherwise URL-form-encodes HTTP message bodies
    HMNetworkRequestDataFormatJSON,
};

typedef NS_ENUM(NSUInteger, HMNetworkResponseDataFormat) {
    HMNetworkResponseDataFormatHTTP,
    HMNetworkResponseDataFormatJSON,
    HMNetworkResponseDataFormatXML,
};

typedef void (^HMNetworkCoreCompletionBlock)(NSError *error, NSURLResponse *response, id responseObject);
typedef void (^HMNetworkCoreProgressBlock)(NSProgress *progress);
typedef void (^HMNetworkCoreMultipartFormConstructBlock)(id <HMMultipartFormData> formData);


@interface HMNetworkCore : NSObject

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                    timeout:(NSTimeInterval)timeout
                          requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
                         responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                            completionQueue:(dispatch_queue_t)completionQueue
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

@end


@interface HMNetworkCore (Upload)

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                 responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionQueue:(dispatch_queue_t)completionQueue
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                             headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                 responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionQueue:(dispatch_queue_t)completionQueue
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;

@end


@interface HMNetworkCore (MultipartForm)

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                        responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                             progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                           completionQueue:(dispatch_queue_t)completionQueue
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock;
@end


@protocol HMMultipartFormData <NSObject>

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError *)error;

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

@end


@interface HMNetworkCore (Log)
@property (class, nonatomic, assign) BOOL disableLog;
@end
