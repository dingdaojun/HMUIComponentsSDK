//
//  HMServiceAPI+HandleResult.m
//  HMNetworkLayer
//
//  Created by 李宪 on 18/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+HandleResult.h"

@implementation HMServiceAPI (HandleResult)

/*
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame.aspx?sourcedoc={C771B11A-2FE1-4FB7-A297-6C89ABF5471C}&file=System%20Level%20common%20parameters.docx&action=default
 */
- (NSError *)errorWithHTTPStatusCode:(NSInteger)statusCode
                      responseObject:(id)responseObject
                   desiredDataFormat:(HMServiceResultDataFormat)dataFormat {
    
    HMServiceAPIError error = HMServiceAPIErrorNone;
    NSDictionary *userInfo = nil;
    
    switch (statusCode) {
        case 200: error = HMServiceAPIErrorNone; break;
        case 400: error = HMServiceAPIErrorParameters; break;
        case 401: {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorInfo = (NSDictionary *)responseObject;

                // 兼容部分接口
                if (errorInfo[@"data"]) {
                    errorInfo = errorInfo[@"data"];
                }

                NSInteger code = [errorInfo[@"code"] integerValue];
                if (code == 108) {
                    NSTimeInterval timeInterval = [errorInfo[@"mutime_long"] doubleValue];
                    if (timeInterval > (1e12)) {
                        timeInterval /= 1000.f;
                    }
                    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                    if (time) {
                        error = HMServiceAPIErrorMutexLogin;
                        userInfo = @{HMServiceAPIErrorUserInfoMutexLoginTimeKey : time};
                    }
                }
                else if (code == 102) {
                    error = HMServiceAPIErrorInvalidToken;
                }
            }
            else {
                error = HMServiceAPIErrorInvalidToken;
            }
        } break;
        case 302:
        case 404: error = HMServiceAPIErrorNetwork; break;
        case -1001: error = HMServiceAPIErrorTimeout; break;
        case 409:
        case 500:
        case 504: error = HMServiceAPIErrorServerInternal; break;
        default: error = HMServiceAPIErrorUnknown; break;
    }
    
    if (error == HMServiceAPIErrorNone) {
        switch (dataFormat) {
            case HMServiceResultDataFormatAny: break;
            case HMServiceResultDataFormatDictionary: {
                if (responseObject && ![responseObject isKindOfClass:[NSDictionary class]]) {
                    error = HMServiceAPIErrorResponseDataFormat;
                }
            } break;
            case HMServiceResultDataFormatArray: {
                if (responseObject && ![responseObject isKindOfClass:[NSArray class]]) {
                    error = HMServiceAPIErrorResponseDataFormat;
                }
            } break;
        }
    }
    
    if (error != HMServiceAPIErrorNone) {
        return [NSError errorWithHMServiceAPIError:error userInfo:userInfo];
    }
    return nil;
}

- (void)handleResultForAPI:(SEL)API
             responseError:(NSError *)responseError
                  response:(NSURLResponse *)response
            responseObject:(id)responseObject
         desiredDataFormat:(HMServiceResultDataFormat)dataFormat
           completionBlock:(void (^)(BOOL success, NSString *message, id data))completionBlock {

    NSInteger statusCode = responseError.code;
    NSString *failureReason = responseError.localizedFailureReason;

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        statusCode = ((NSHTTPURLResponse *)response).statusCode;
    }

    NSError *error = [self errorWithHTTPStatusCode:statusCode
                                    responseObject:responseObject
                                 desiredDataFormat:dataFormat];
    if (error) {
        NSString *localizedMessage;
        
        [self.delegate service:self
                didDetectError:error
                         inAPI:NSStringFromSelector(API)
              localizedMessage:&localizedMessage];
        
        if (completionBlock) {
            completionBlock(NO, localizedMessage ?: failureReason, nil);
        }
        return;
    }
    
    if (completionBlock) {
        completionBlock(YES, nil, responseObject);
    }
}

@end
