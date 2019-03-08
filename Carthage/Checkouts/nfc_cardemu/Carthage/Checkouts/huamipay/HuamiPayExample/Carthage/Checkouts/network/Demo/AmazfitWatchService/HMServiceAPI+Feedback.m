//
//  HMServiceAPI+Feedback.m
//  HuamiWatch
//
//  Created by dingdaojun on 31/7/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+Feedback.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/HMCategoryKit.h>

@implementation HMServiceAPI (Feedback)

- (id<HMCancelableAPI>)feedback_sendContact:(NSString *)contact
                                   question:(NSString *)question
                            firmwareVersion:(NSString *)firmware
                                logFilePath:(id)logFilePath
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }

        NSParameterAssert(contact.length > 0);
        NSParameterAssert(question.length > 0);
        
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSString *iOSDeviceModel = [UIDevice deviceName];
        
        NSURL *logFileURL = logFilePath;
        if ([logFileURL isKindOfClass:[NSString class]]) {
            logFileURL = [NSURL fileURLWithPath:logFilePath];
            NSParameterAssert([logFileURL isFileURL]);
        }
        
        NSDateFormatter *formatter  = [NSDateFormatter new];
        formatter.calendar          = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        formatter.dateFormat        = @"yyyyMMdd";
        NSString *dateString        = [formatter stringFromDate:[NSDate date]];

        NSString *logFileName       = [NSString stringWithFormat:@"iOS_%@_%@.zip", userID, dateString];
        
        NSString *bundleIdentifier  = [NSBundle mainBundle].bundleIdentifier;
        
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"/users/%@/apps/%@/fileAccessURIs", userID, bundleIdentifier]];
        
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
        
        NSMutableDictionary *parameters = [@{@"fileName" : logFileName,
                                             @"fileType" : @"LOG"} mutableCopy];
        NSMutableDictionary *logParameters = [@{@"contact" : contact,
                                                @"content" : question,
                                                @"phoneSystem" : systemVersion,
                                                @"appVersion" : appVersion,
                                                @"phoneModel" : iOSDeviceModel} mutableCopy];
        if (firmware.length > 0) {
            logParameters[@"fitfwVersion"] = firmware;
        }
        
        parameters[@"logFile"] = logParameters;
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore POST:URL
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
                              desiredDataFormat:HMServiceResultDataFormatDictionary
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                    if (!success) {
                                        !completionBlock ?: completionBlock(NO, message);
                                        return;
                                    }
                                    
                                    NSString *putURI = data.hmjson[@"putURI"].string;
                                    
                                    if (putURI.length == 0) {
                                        !completionBlock ?: completionBlock(NO, @"put URI is nil");
                                        return;
                                    }
                                    
                                    NSData *logFileData = [NSData dataWithContentsOfFile:logFileURL.path];
                                    
                                    if(!logFileData || !logFileData.length) {
                                        !completionBlock ?: completionBlock(YES, @"no log file data");
                                        return;
                                    }
                                    [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPUT
                                                                       URL:putURI
                                                                  fromData:logFileData
                                                           completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                               
                                                               [self handleResultForAPI:_cmd
                                                                          responseError:error
                                                                               response:response
                                                                         responseObject:responseObject
                                                                      desiredDataFormat:HMServiceResultDataFormatAny
                                                                        completionBlock:^(BOOL success, NSString *message, id data) {
                                                                            
                                                                            if (!completionBlock) {
                                                                                return;
                                                                            }
                                                                            
                                                                            if (!success) {
                                                                                completionBlock(NO, message);
                                                                                return;
                                                                            }
                                                                            
                                                                            completionBlock(YES, message);
                                                                        }];
                                                           }];
                                }];
                   }];
    }];
}

- (NSURLSessionTask *)feedback_createUploadFileURLWithLogFilePath:(NSString *)logFilePath
                                                  completionBlock:(void (^)(BOOL success, NSString *message, NSString *putURI, NSString *seviceFileName))completionBlock {
    NSParameterAssert(logFilePath.length > 0);

    NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"apps/com.huami.watch/files/LOGIN_FAIL/diagnoseFileAccessURIs"];

    NSError *error = nil;
    NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error];
    if (error) {
        if (completionBlock) {
            completionBlock(NO, error.localizedDescription, nil, nil);
        }
        return nil;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"fileName"]         = logFilePath.lastPathComponent ?: @"";

    [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
    if (error) {
        if (completionBlock) {
            completionBlock(NO, error.localizedDescription, nil, nil);
        }
        return nil;
    }

    return [HMNetworkCore GET:URL
                   parameters:parameters
                      headers:headers
                      timeout:0
           responseDataFormat:HMNetworkResponseDataFormatJSON
              completionQueue:nil
              completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

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
                                           completionBlock(false, localizedMessage, nil, seviceFileName);
                                       }
                                       return;
                                   }
                               }

                               if (completionBlock) {
                                   completionBlock(success, message, putURI, seviceFileName);
                               }
                           }];
              }];
}

- (NSURLSessionTask *)feedback_uploadLoginFailedLogFile:(NSString *)logFilePath
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSString *seviceFileName))completionBlock {
    NSParameterAssert(logFilePath.length > 0);

    return [self feedback_createUploadFileURLWithLogFilePath:logFilePath
                                             completionBlock:^(BOOL success, NSString *message, NSString *putURI, NSString *seviceFileName) {

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


- (id<HMCancelableAPI>)feedback_sendLoginFailLogWithContact:(NSString *)contact
                                                   question:(NSString *)question
                                                logFilePath:(NSString *)logFilePath
                                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    NSParameterAssert(logFilePath.length > 0);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        return [self feedback_uploadLoginFailedLogFile:logFilePath
                                       completionBlock:^(BOOL success, NSString *message, NSString *seviceFileName) {

                                           if (!success) {
                                               if (completionBlock) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completionBlock(success, message);
                                                   });
                                               }
                                               return;
                                           }

                                           NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"/apps/com.huami.watch/files/LOGIN_FAIL/diagnoseFileUpload"];
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

                                           NSDictionary *diagnoseFileInfo = @{@"contact" : contact ?: @"",
                                                                              @"content" : question ?: @""};

                                           NSMutableDictionary *parameters = [@{@"fileName" : seviceFileName ?: @"",
                                                                                @"exists" : @YES,
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
                                                          desiredDataFormat:HMServiceResultDataFormatAny
                                                            completionBlock:^(BOOL success, NSString *message, id data) {
                                                                if (completionBlock) {
                                                                    completionBlock(success, message);
                                                                }
                                                            }];
                                               }];
                                       }];
    }];
}

@end

