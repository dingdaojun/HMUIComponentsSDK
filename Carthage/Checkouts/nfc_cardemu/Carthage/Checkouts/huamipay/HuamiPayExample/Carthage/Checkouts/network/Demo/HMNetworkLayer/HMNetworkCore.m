//
//  HMNetworkCore.m
//  HMNetworkLayer
//
//  Created by 李宪 on 11/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkCore.h"
#import "HMNetworkLogger.h"
#import <objc/runtime.h>
#import "NSObject+HMNetworkCleanNSNull.h"
#import "NSNumber+HMNetworkHTTPMethod.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation AFHTTPSessionManager (HMNetwork)

+ (NSMutableDictionary *)sharedManagers {
    
    static id managers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managers = [NSMutableDictionary dictionary];
    });
    return managers;
}

+ (AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializerWithDataFormat:(HMNetworkRequestDataFormat)requestDataFormat {
    NSParameterAssert(requestDataFormat == HMNetworkRequestDataFormatHTTP ||
                      requestDataFormat == HMNetworkRequestDataFormatJSON);
    
    switch (requestDataFormat) {
        case HMNetworkRequestDataFormatHTTP: return [AFHTTPRequestSerializer serializer];
        case HMNetworkRequestDataFormatJSON: return [AFJSONRequestSerializer serializer];
    }
}

+ (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializerWithDataFormat:(HMNetworkResponseDataFormat)responseDataFormat {
    NSParameterAssert(responseDataFormat == HMNetworkResponseDataFormatHTTP ||
                      responseDataFormat == HMNetworkResponseDataFormatJSON ||
                      responseDataFormat == HMNetworkResponseDataFormatXML);
    
    switch (responseDataFormat) {
        case HMNetworkResponseDataFormatHTTP: return [AFHTTPResponseSerializer serializer];
        case HMNetworkResponseDataFormatJSON: return [AFJSONResponseSerializer serializer];
        case HMNetworkResponseDataFormatXML: return [AFXMLParserResponseSerializer serializer];
    }
}

+ (instancetype)managerWithRequestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
                          responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat {
    
    NSMutableDictionary *managers = [self sharedManagers];
    NSString *key = [NSString stringWithFormat:@"%d - %d", (int)requestDataFormat, (int)responseDataFormat];
    
    AFHTTPSessionManager *manager = managers[key];
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [self requestSerializerWithDataFormat:requestDataFormat];
        manager.responseSerializer = [self responseSerializerWithDataFormat:responseDataFormat];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/xml", nil];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        manager.securityPolicy = policy;
        
        managers[key] = manager;
    }
    
    return manager;
}

+ (instancetype)managerForMultipartForm {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/xml", nil];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    manager.securityPolicy = policy;
    
    return manager;
}

@end


@interface HMNetworkCore ()
@property (class, nonatomic, strong, readonly) dispatch_queue_t queue;
@end

@implementation HMNetworkCore

+ (void)initialize {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (dispatch_queue_t)queue {
    dispatch_queue_t queue = objc_getAssociatedObject(self, "queue");
    if (!queue) {
        queue = dispatch_queue_create("hmnetwork.core.queue", DISPATCH_QUEUE_SERIAL);
        objc_setAssociatedObject(self, "queue", queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return queue;
}

#pragma mark - handle response

+ (NSString *)formattedDescriptionFromResponseObject:(id)responseObject {
    
    if (!responseObject) {
        return nil;
    }
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (void)handleURLResponse:(NSURLResponse *)response
           responseObject:(id)responseObject
                    error:(NSError *)error
          completionQueue:(dispatch_queue_t)completionQueue
          completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {

    HMNetworkLogInfo(@"RESPONSE --- URL: %@, response: %@, error %@", response.URL, response, error);

    NSString *responseObjectDescription = [self formattedDescriptionFromResponseObject:responseObject];
    HMNetworkLogInfo(@"response object: %@", responseObjectDescription);
    
    responseObject = [responseObject hmn_cleanObject];
    
    if (completionBlock) {
        dispatch_async(completionQueue, ^{
            completionBlock(error, response, responseObject);
        });
    }
}

#pragma mark - public

+ (NSURLSessionDataTask *)requestWithMethod:(HMNetworkHTTPMethod)method
                                        URL:(NSString *)URL
                                 parameters:(id)parameters
                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                    timeout:(NSTimeInterval)timeout
                          requestDataFormat:(HMNetworkRequestDataFormat)requestDataFormat
                         responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                            completionQueue:(dispatch_queue_t)completionQueue
                            completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dispatch_sync(self.queue, ^{
        
        NSString *methodString = @(method).hmn_HTTPMethodString;

        HMNetworkLogInfo(@"DATA TASK REQUEST ---\n"
                         "METHOD:\t%@\n"
                         "URL:\t%@\n"
                         "Parameters:\n%@\n"
                         "Header fields:\n%@\n",
                         methodString, URL, parameters, headers);

        AFHTTPSessionManager *manager = [AFHTTPSessionManager managerWithRequestDataFormat:requestDataFormat
                                                                        responseDataFormat:responseDataFormat];
        manager.completionQueue = self.queue;
        
        AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
        
        NSError *requestSerializeError;
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:methodString
                                                                  URLString:URL
                                                                 parameters:parameters
                                                                      error:&requestSerializeError];
        if (requestSerializeError) {
            HMNetworkLogInfo(@"Serialize request failed with method: %@, URL: %@, parameters: %@, error: %@", methodString, URL, parameters, requestSerializeError);
            if (completionBlock) {
                dispatch_async(completionQueue ?: dispatch_get_main_queue(), ^{
                    completionBlock(requestSerializeError, nil, nil);
                });
            }
            return;
        }
        
        // 由于requestSerializer复用，因此在外部对每个request进行配置
        if (timeout > 0) {
            request.timeoutInterval = timeout;
        }
        
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [request setValue:value forHTTPHeaderField:key];
        }];
        
        dataTask = [manager dataTaskWithRequest:request
                                 uploadProgress:nil
                               downloadProgress:nil
                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                  
                                  [self handleURLResponse:response
                                           responseObject:responseObject
                                                    error:error
                                          completionQueue:completionQueue ?: dispatch_get_main_queue()
                                          completionBlock:completionBlock];
                              }];
        [dataTask resume];
    });
    
    return dataTask;
}

@end

@implementation HMNetworkCore (Upload)

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromFile:(NSString *)filePath
                                            headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                 responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionQueue:(dispatch_queue_t)completionQueue
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {

    __block NSURLSessionUploadTask *uploadTask = nil;
    
    dispatch_sync(self.queue, ^{
        
        NSString *methodString = @(method).hmn_HTTPMethodString;
        
        HMNetworkLogInfo(@"UPLOAD REQUEST ---\n"
                         "METHOD:\t%@\n"
                         "URL:\t%@\n"
                         "File Path:\t%@\n"
                         "Header fields:\n%@\n",
                         methodString, URL, filePath, headers);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
        request.HTTPMethod = methodString;
        
        if (timeout > 0) {
            request.timeoutInterval = timeout;
        }
        
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [request setValue:value forHTTPHeaderField:key];
        }];
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.completionQueue = self.queue;
        
        manager.responseSerializer = [AFHTTPSessionManager responseSerializerWithDataFormat:responseDataFormat];
        manager.securityPolicy.allowInvalidCertificates = YES; // very important
        manager.securityPolicy.validatesDomainName = NO; // very important
        
        uploadTask = [manager uploadTaskWithRequest:request
                                           fromFile:fileURL
                                           progress:uploadProgressBlock
                                  completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                      
                                      [self handleURLResponse:response
                                               responseObject:responseObject
                                                        error:error
                                              completionQueue:completionQueue ?: dispatch_get_main_queue()
                                              completionBlock:completionBlock];
                                  }];
        [uploadTask resume];
    });
    
    return uploadTask;
}

+ (NSURLSessionUploadTask *)uploadRequestWithMethod:(HMNetworkHTTPMethod)method
                                                URL:(NSString *)URL
                                           fromData:(NSData *)fileData
                                            headers:(NSDictionary<NSString *, NSString *> *)headers
                                            timeout:(NSTimeInterval)timeout
                                 responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                      progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                    completionQueue:(dispatch_queue_t)completionQueue
                                    completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    
    dispatch_sync(self.queue, ^{
        
        NSString *methodString = @(method).hmn_HTTPMethodString;
        
        HMNetworkLogInfo(@"UPLOAD REQUEST ---\n"
                         "METHOD:\t%@\n"
                         "URL:\t%@\n"
                         "File Data size:\t%d\n"
                         "Header fields:\n%@\n",
                         methodString, URL, (int)fileData.length, headers);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
        request.HTTPMethod = methodString;
        
        if (timeout > 0) {
            request.timeoutInterval = timeout;
        }
        
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [request setValue:value forHTTPHeaderField:key];
        }];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.completionQueue = self.queue;
        
        manager.responseSerializer = [AFHTTPSessionManager responseSerializerWithDataFormat:responseDataFormat];
        manager.securityPolicy.allowInvalidCertificates = YES; // very important
        manager.securityPolicy.validatesDomainName = NO; // very important
        
        uploadTask = [manager uploadTaskWithRequest:request
                                           fromData:fileData
                                           progress:uploadProgressBlock
                                  completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                      
                                      [self handleURLResponse:response
                                               responseObject:responseObject
                                                        error:error
                                              completionQueue:completionQueue ?: dispatch_get_main_queue()
                                              completionBlock:completionBlock];
                                  }];
        [uploadTask resume];
    });
    
    return uploadTask;
}

@end

@implementation HMNetworkCore (MultipartForm)

+ (NSURLSessionUploadTask *)multipartFormRequestWithMethod:(HMNetworkHTTPMethod)method
                                                       URL:(NSString *)URL
                                                parameters:(id)parameters
                                                   headers:(NSDictionary<NSString *, NSString *> *)headers
                                                   timeout:(NSTimeInterval)timeout
                                            constructBlock:(HMNetworkCoreMultipartFormConstructBlock)constuctBlock
                                        responseDataFormat:(HMNetworkResponseDataFormat)responseDataFormat
                                             progressBlock:(HMNetworkCoreProgressBlock)uploadProgressBlock
                                           completionQueue:(dispatch_queue_t)completionQueue
                                           completionBlock:(HMNetworkCoreCompletionBlock)completionBlock {
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    
    dispatch_sync(self.queue, ^{
        
        NSString *methodString = @(method).hmn_HTTPMethodString;
        
        HMNetworkLogInfo(@"MULTIPART FORM REQUEST ---\n"
                         "METHOD:\t%@\n"
                         "URL:\t%@\n"
                         "Parameters:\n%@\n"
                         "Header fields:\n%@\n",
                         methodString, URL, parameters, headers);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager managerForMultipartForm];
        manager.completionQueue = self.queue;
        
        AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
        
        NSError *requestSerializeError;
        NSString *methodText = methodString;
        NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:methodText
                                                                               URLString:URL
                                                                              parameters:parameters
                                                               constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
                                                                   if (constuctBlock) {
                                                                       constuctBlock((id<HMMultipartFormData>)formData);
                                                                   }
                                                               } error:&requestSerializeError];
        if (requestSerializeError) {
            HMNetworkLogError(@"Serialize failure with method: %@, URL: %@, parameters: %@", methodText, URL, parameters);
            if (completionBlock) {
                dispatch_async(completionQueue ?: dispatch_get_main_queue(), ^{
                    completionBlock(requestSerializeError, nil, nil);
                });
            }
            return;
        }
        
        // 由于requestSerializer复用，因此在外部对每个request进行配置
        if (timeout > 0) {
            request.timeoutInterval = timeout;
        }
        
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [request setValue:value forHTTPHeaderField:key];
        }];
        
        uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                   progress:uploadProgressBlock
                                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                              
                                              [self handleURLResponse:response
                                                       responseObject:responseObject
                                                                error:error
                                                      completionQueue:completionQueue ?: dispatch_get_main_queue()
                                                      completionBlock:completionBlock];
                                          }];
        [uploadTask resume];
    });
    
    return uploadTask;
}

@end



@implementation HMNetworkCore (Log)

+ (void)setDisableLog:(BOOL)disableLog {
    objc_setAssociatedObject(self, "disableLog", @(disableLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)disableLog {
    NSNumber *value = objc_getAssociatedObject(self, "disableLog");
    return value.boolValue;
}

@end
