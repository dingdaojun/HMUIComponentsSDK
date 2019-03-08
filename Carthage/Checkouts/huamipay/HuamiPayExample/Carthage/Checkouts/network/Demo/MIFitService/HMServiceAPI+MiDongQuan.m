//
//  HMServiceAPI+MiDongQuan.m
//  HMNetworkLayer
//
//  Created by 李宪 on 28/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+MiDongQuan.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@interface NSDictionary (HMServiceAPIMiDongQuanData) <HMServiceAPIMiDongQuanData>
@end

@implementation NSDictionary (HMServiceAPIMiDongQuanData)

- (BOOL)api_miDongQuanContainsSensitiveWords {
    NSInteger code = self.hmjson[@"code"].integerValue;
    if (code == 601002) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSString *)api_miDongQuanID {

    return self.hmjson[@"postID"].string;
}


@end

@implementation HMServiceAPI (MiDongQuan)

- (void)miDongQuan_createUploadFileURLWithUserID:(NSString *)userID
                                 completionBlock:(void (^)(BOOL success, NSString *message, NSString *getURI, NSString *putURI))completionBlock {
    NSParameterAssert(userID.length > 0);
    
    NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/v1/soc/post/xmyd/image"];
    
    NSError *error = nil;
    NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
    if (error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil);
            });
        }
        return;
    }
    
    NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;
    NSString *fileName = [NSString stringWithFormat:@"%f.jpg", timestamp];
    NSMutableDictionary *parameters = [@{@"fileName" : fileName,
                                         @"userid" : userID} mutableCopy];
    [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
    if (error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil);
            });
        }
        return;
    }
    
    [HMNetworkCore POST:URL
             parameters:parameters
                headers:headers
                timeout:0
        completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

            [self legacy_handleResultForAPI:_cmd
                              responseError:error
                                   response:response
                             responseObject:responseObject
                            completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                
                                NSString *getURI = nil;
                                NSString *putURI = nil;
                                if (success) {
                                    getURI = data.hmjson[@"getURI"].string;
                                    putURI = data.hmjson[@"putURI"].string;
                                    
                                    if (getURI.length == 0 ||
                                        putURI.length == 0) {
                                        
                                        NSError *error = [NSError errorWithHMServiceAPIError:HMServiceAPIErrorResponseDataFormat userInfo:nil];
                                        NSString *localizedMessage = nil;
                                        
                                        [self.delegate service:self
                                                didDetectError:error
                                                         inAPI:NSStringFromSelector(_cmd)
                                              localizedMessage:&localizedMessage];
                                        
                                        if (completionBlock) {
                                            completionBlock(false, localizedMessage, nil, nil);
                                        }
                                        return;
                                    }
                                }
                                
                                if (completionBlock) {
                                    completionBlock(success, message, getURI, putURI);
                                }
                            }];
        }];
}

- (void)miDongQuan_uploadImage:(UIImage *)image
                        userID:(NSString *)userID
               completionBlock:(void (^)(BOOL success, NSString *message, NSString *imageURL))completionBlock {
    NSParameterAssert(image);
    NSParameterAssert(userID.length > 0);
    
    [self miDongQuan_createUploadFileURLWithUserID:userID
                                   completionBlock:^(BOOL success, NSString *message, NSString *getURI, NSString *putURI) {
                                       if (!success) {
                                           if (completionBlock) {
                                               completionBlock(false, message, nil);
                                           }
                                           return;
                                       }
                                       
                                       NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                                       [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPUT
                                                                          URL:putURI
                                                                     fromData:imageData
                                                              completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                                                                  [self handleResultForAPI:_cmd
                                                                             responseError:error
                                                                                  response:response
                                                                            responseObject:responseObject
                                                                         desiredDataFormat:HMServiceResultDataFormatAny
                                                                           completionBlock:^(BOOL success, NSString *message, id data) {
                                                                               if (completionBlock) {
                                                                                   completionBlock(success, message, getURI);
                                                                               }
                                                                           }];
                                                              }];
                                   }];
}

- (void)miDongQuan_publishImage:(UIImage *)image
                        content:(NSString *)content
                completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIMiDongQuanData> miDongQuanData))completionBlock {
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return;
    }

    NSParameterAssert(image);
    
    [self miDongQuan_uploadImage:image
                          userID:userID
                 completionBlock:^(BOOL success, NSString *message, NSString *imageURL) {
                     if (!success) {
                         if (completionBlock) {
                             completionBlock(success, message, nil);
                         }
                         return;
                     }
                     
                     NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/v1/soc/post/xmyd"];
                     
                     NSError *error = nil;
                     NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
                     if (error) {
                         if (completionBlock) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completionBlock(NO, error.localizedDescription, nil);
                             });
                         }
                         return;
                     }
                     
                     NSMutableDictionary *parameters = [@{@"userid" : userID,
                                                          @"content" : content ?: @"",  // PS: content必须有
                                                          @"image" : imageURL} mutableCopy];
                     
                     [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
                     if (error) {
                         if (completionBlock) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completionBlock(NO, error.localizedDescription, nil);
                             });
                         }
                         return;
                     }
                     
                     [HMNetworkCore POST:URL
                              parameters:parameters
                                 headers:headers
                                 timeout:0
                         completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                             [self legacy_handleResultForAPI:_cmd
                                               responseError:error
                                                    response:response
                                              responseObject:responseObject
                                             completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                                 if (!success) {
                                                     if (completionBlock) {
                                                         completionBlock(success, message, nil);
                                                     }
                                                     return;
                                                 }

                                                 if (completionBlock) {
                                                     completionBlock(success, message, data);
                                                 }
                                             }];
                         }];
                 }];
}

@end
