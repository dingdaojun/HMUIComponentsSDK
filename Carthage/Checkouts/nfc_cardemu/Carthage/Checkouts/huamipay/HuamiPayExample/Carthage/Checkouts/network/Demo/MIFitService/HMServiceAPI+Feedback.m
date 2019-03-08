//
//  HMServiceAPI+Feedback.m
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Feedback.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/HMCategoryKit.h>

@implementation HMServiceAPI (Feedback)

- (id<HMCancelableAPI>)feedback_sendContact:(NSString *)contact
                                    content:(NSString *)content
                                 appVersion:(NSString *)appVersion
                                       area:(NSString *)area
                                   language:(NSString *)language
                            firmwareVersion:(NSString *)firmware
                        shoeFirmwareVersion:(NSString *)shoe
                       scaleFirmwareVersion:(NSString *)scale
                                  isDevelop:(BOOL)isDevelop
                           boundDeviceNames:(NSArray<NSString *> *)deviceNames
                                logFilePath:(id)logFilePath
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(contact);
        NSParameterAssert(content.length > 0);
        NSParameterAssert(area.length > 0);
        NSParameterAssert(language.length > 0);
        
        NSString *systemVersion = [NSString stringWithFormat:@"ios_%@", [UIDevice currentDevice].systemVersion];
        NSString *iOSDeviceModel = [UIDevice deviceName];
        
        NSURL *logFileURL = logFilePath;
        if ([logFileURL isKindOfClass:[NSString class]]) {
            logFileURL = [NSURL fileURLWithPath:logFilePath];
            NSParameterAssert([logFileURL isFileURL]);
        }
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyyMMdd";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *logFileName = [NSString stringWithFormat:@"iOS_%@_%@.zip", userID, dateString];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.uploadlogdata.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }

        NSString *appType = isDevelop ? @"develop" : @"release";
        NSMutableDictionary *parameters = [@{@"appType" : appType,
                                             @"contact" : contact,
                                             @"content" : content,
                                             @"location" : area?:@"",
                                             @"language" : language?:@"",
                                             @"phonesystem" : systemVersion?:@"",
                                             @"appversion" : appVersion?:@"",
                                             @"phonemodel" : iOSDeviceModel?:@"",
                                             @"userid" : userID} mutableCopy];
        if (firmware.length > 0) {
            parameters[@"fitfwversion"] = firmware;
        }
        if (shoe.length > 0) {
            parameters[@"shoesfwversion"] = shoe;
        }
        if (scale) {
            parameters[@"scalefwversion"] = scale;
        }
        if (deviceNames.count > 0) {
            parameters[@"sourcelist"] = [deviceNames componentsJoinedByString:@", "];
        }
        if (logFileURL) {
            parameters[@"log_file_name"] = logFileName;
        }
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore multipartFormRequestWithMethod:HMNetworkHTTPMethodPOST
                                                         URL:URL
                                                  parameters:parameters
                                                     headers:headers
                                                     timeout:0
                                              constructBlock:^(id<HMMultipartFormData> formData) {
                                                  
                                                  if (logFileURL) {
                                                      [formData appendPartWithFileURL:logFileURL
                                                                                 name:@"log_file"
                                                                             fileName:logFileName
                                                                             mimeType:@"application/octet-stream"
                                                                                error:NULL];
                                                  }
                                              } completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                  
                                                  [self legacy_handleResultForAPI:_cmd
                                                                    responseError:error
                                                                         response:response
                                                                   responseObject:responseObject
                                                                  completionBlock:^(BOOL success, NSString *message, id data) {
                                                                      if (completionBlock) {
                                                                          completionBlock(success, message);
                                                                      }
                                                                  }];
                                              }];
    }];
}

- (void)loginFailFeedback_createUploadFileURLWithLogFilePath:(NSString *)logFilePath
                                             completionBlock:(void (^)(BOOL success, NSString *message, NSString *getURI, NSString *putURI, NSString *seviceFileName))completionBlock {
    NSParameterAssert(logFilePath.length > 0);

    NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"apps/com.xiaomi.hm.health/files/LOGIN_FAIL/diagnoseFileAccessURIs"];

    NSError *error = nil;
    NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error];
    if (error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil, nil);
            });
        }
        return;
    }

    NSMutableDictionary *parameters = [@{@"fileName" : [logFilePath lastPathComponent]?:@""}mutableCopy];

    [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
    if (error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil, nil, nil);
            });
        }
        return;
    }
    __block NSURLSessionDataTask *task;
    task = [HMNetworkCore GET:URL
                   parameters:parameters
                      headers:headers
                      timeout:0
           responseDataFormat:HMNetworkResponseDataFormatJSON
              completionQueue:nil
              completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                  task = task;

                  [self handleResultForAPI:_cmd
                             responseError:error
                                  response:response
                            responseObject:responseObject
                         desiredDataFormat:HMServiceResultDataFormatDictionary
                           completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                               NSString *getURI = nil;
                               NSString *putURI = nil;
                               NSString *seviceFileName = nil;

                               if (success) {
                                   getURI = data.hmjson[@"getURI"].string;
                                   putURI = data.hmjson[@"putURI"].string;
                                   seviceFileName = data.hmjson[@"fileName"].string;

                                   if (getURI.length == 0 ||
                                       putURI.length == 0 ||
                                       seviceFileName.length == 0) {

                                       NSError *error = [NSError errorWithHMServiceAPIError:HMServiceAPIErrorResponseDataFormat userInfo:nil];
                                       NSString *localizedMessage = nil;

                                       [self.delegate service:self
                                               didDetectError:error
                                                        inAPI:NSStringFromSelector(_cmd)
                                             localizedMessage:&localizedMessage];

                                       if (completionBlock) {
                                           completionBlock(false, localizedMessage, nil, nil, seviceFileName);
                                       }
                                       return;
                                   }
                               }

                               if (completionBlock) {
                                   completionBlock(success, message, getURI, putURI, seviceFileName);
                               }
                           }];
              }];
}

- (void)loginFailFeedback_uploadFile:(NSString *)logFilePath
                     completionBlock:(void (^)(BOOL success, NSString *message, NSString *seviceFileName))completionBlock {
    NSParameterAssert(logFilePath.length > 0);

    [self loginFailFeedback_createUploadFileURLWithLogFilePath:logFilePath
                                               completionBlock:^(BOOL success, NSString *message, NSString *getURI, NSString *putURI, NSString *seviceFileName) {

                                                   if (!success) {
                                                       if (completionBlock) {
                                                           completionBlock(false, message, nil);
                                                       }
                                                       return;
                                                   }

                                                   NSData *fileData = [NSData dataWithContentsOfFile:logFilePath];
                                                   [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPUT
                                                                                      URL:putURI
                                                                                 fromData:fileData
                                                                          completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                                                                              [self handleResultForAPI:_cmd
                                                                                         responseError:error
                                                                                              response:response
                                                                                        responseObject:responseObject
                                                                                     desiredDataFormat:HMServiceResultDataFormatAny
                                                                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                                                                           if (completionBlock) {
                                                                                               completionBlock(success, message, seviceFileName);
                                                                                           }
                                                                                       }];
                                                                          }];
                                               }];
}


- (void)loginFailFeedback_logFilePath:(NSString *)logFilePath
                      completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    NSParameterAssert(logFilePath.length > 0);

    [self loginFailFeedback_uploadFile:logFilePath
                       completionBlock:^(BOOL success, NSString *message, NSString *seviceFileName) {

                           if (!success) {
                               if (completionBlock) {
                                   completionBlock(success, message);
                               }
                               return;
                           }

                           NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/apps/com.xiaomi.hm.health/files/LOGIN_FAIL/diagnoseFileUpload"];
                           NSError *error = nil;
                           NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error];
                           if (error) {
                               if (completionBlock) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completionBlock(NO, error.localizedDescription);
                                   });
                               }
                               return;
                           }

                           NSDictionary *diagnoseFileInfo =@{@"contact" : @"",
                                                             @"content" : @""};

                           NSMutableDictionary *parameters = [@{@"fileName" : seviceFileName?:@"",
                                                                @"exists" : @(YES),
                                                                @"fileType" : @"LOGIN_FAIL",
                                                                @"diagnoseFileInfo" : diagnoseFileInfo} mutableCopy];

                           [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
                           if (error) {
                               if (completionBlock) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completionBlock(NO, error.localizedDescription);
                                   });
                               }
                               return;
                           }

                           [HMNetworkCore POST:URL
                                    parameters:parameters
                                       headers:headers
                                       timeout:0
                             requestDataFormat:HMNetworkRequestDataFormatJSON
                            responseDataFormat:HMNetworkResponseDataFormatJSON
                               completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                                   [self handleResultForAPI:_cmd
                                              responseError:error
                                                   response:response
                                             responseObject:responseObject
                                          desiredDataFormat:HMServiceResultDataFormatArray
                                            completionBlock:^(BOOL success, NSString *message, id data) {
                                                if (completionBlock) {
                                                    completionBlock(success, message);
                                                }
                                            }];
                               }];
                       }];
}

@end
