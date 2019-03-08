
//  HMServiceAPI+LegacyHandleResult.m
//  HMNetworkLayer
//
//  Created by 李宪 on 18/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+LegacyHandleResult.h"

@implementation HMServiceAPI (LegacyHandleResult)

/**
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=60
 */
- (HMServiceAPIError)legacy_errorWithCode:(NSInteger)code {
    switch (code) {
        case 1:
            return HMServiceAPIErrorNone;
        case 50000:
        case 103001:
            return HMServiceAPIErrorParameters;    // PS: 103001表示无效token仅在发布米动圈接口见过
        case 0:
        case 100302:
            return HMServiceAPIErrorInvalidToken;
        case -1:
            return HMServiceAPIErrorMutexLogin;
        case -1001:
            return HMServiceAPIErrorTimeout;
        default:
            return HMServiceAPIErrorNetwork;
    }
}

- (void)legacy_handleResultForAPI:(SEL)API
                    responseError:(NSError *)responseError
                         response:(NSURLResponse *)response
                   responseObject:(NSDictionary *)responseObject
                  completionBlock:(void (^)(BOOL success, NSString *message, id data))completionBlock {

    NSInteger statusCode = responseError.code;

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        statusCode = ((NSHTTPURLResponse *)response).statusCode;
    }

    HMServiceAPIError errorCode = HMServiceAPIErrorNone;
    NSString *message           = nil;
    NSDictionary *data          = nil;
    NSDictionary *userInfo      = nil;

    if (statusCode != 200) {
        if (statusCode == 400) {
            errorCode = HMServiceAPIErrorParameters;
        }
        else {
            errorCode = HMServiceAPIErrorNetwork;
        }
        message = responseError.localizedFailureReason;
    }
    else if (![responseObject isKindOfClass:[NSDictionary class]]) {
        errorCode = HMServiceAPIErrorResponseDataFormat;
    }
    else {
        NSInteger code = [responseObject[@"code"] integerValue];
        message = responseObject[@"message"];
        data = responseObject[@"data"];
        
        errorCode = [self legacy_errorWithCode:code];
        
        // Read form data if error is mutext logined.
        if (errorCode == HMServiceAPIErrorMutexLogin) {
            NSNumber *timeValue = data[@"login_time"];
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:timeValue.doubleValue];
            userInfo = @{HMServiceAPIErrorUserInfoMutexLoginTimeKey : time};
        }
    }
    
    if (errorCode != HMServiceAPIErrorNone) {
        NSString *localizedMessage;
     
        [self.delegate service:self
                didDetectError:[NSError errorWithHMServiceAPIError:errorCode userInfo:userInfo]
                         inAPI:NSStringFromSelector(API)
              localizedMessage:&localizedMessage];
        
        if (completionBlock) {
            completionBlock(NO, localizedMessage ?: message, nil);
        }
        return;
    }

    if (completionBlock) {
        completionBlock(YES, nil, data);
    }
}

@end
