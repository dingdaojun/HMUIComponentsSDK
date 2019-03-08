//  HMServiceAPI+QQDataUploading.m
//  Created on 2018/4/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+QQDataUploading.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/NSDate+HMCompare.h>
#import <HMCategory/NSDate+HMExtremes.h>

static NSString const *baseHostURL = @"https://openmobile.qq.com/v3/health/";


@implementation HMServiceAPI (QQDataUploading)

- (id<HMCancelableAPI> _Nullable)QQDataUploading_sleep:(id<HMServiceAPIQQDataUploadingSleepProtocol>)sleep
                                         authorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization
                                       completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {
    NSParameterAssert(sleep);
    if (!sleep) {
        !completionBlock ?: completionBlock(NO, @"没有上传的睡眠数据");
        return nil;
    }

    NSParameterAssert(authorization);
    if (!authorization) {
        !completionBlock ?: completionBlock(NO, @"没有qq的授权信息");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [NSString stringWithFormat:@"%@report_sleep", baseHostURL];

        long long startTime = (long long)[sleep.api_qqDataUploadingSleepStartDate timeIntervalSince1970];
        long long endTime = (long long)[sleep.api_qqDataUploadingSleepEndDate timeIntervalSince1970];
        long long totalTime = (long long)sleep.api_qqDataUploadingSleepTotalTime / 60;
        long long lightsTime = (long long)sleep.api_qqDataUploadingSleepLightsTime / 60;
        long long deepTime = (long long)sleep.api_qqDataUploadingSleepDeepTime / 60;
        long long awakeTime = (long long)sleep.api_qqDataUploadingSleepAwakeTime / 60;
        NSMutableDictionary *parameters = [@{@"start_time" : @(startTime),
                                             @"end_time" : @(endTime),
                                             @"total_time" : @(totalTime),
                                             @"light_sleep" : @(lightsTime),
                                             @"deep_sleep" : @(deepTime),
                                             @"awake_time" : @(awakeTime)} mutableCopy];

        NSArray<id<HMServiceAPIQQDataUploadingSleepDetailProtocol>> *details = sleep.api_qqDataUploadingSleepDetails;
        NSMutableString *detailStr = [NSMutableString string];
        for (NSInteger i = 0; i < details.count; i++) {

            id<HMServiceAPIQQDataUploadingSleepDetailProtocol> detail = [details objectAtIndex:i];
            long long time = (long long)[detail.api_qqDataUploadingSleepDetailDate timeIntervalSince1970];
            HMServiceQQSleepDetailType type = detail.api_qqDataUploadingSleepDetailType;
            [detailStr appendFormat:@"[%lld,%d]", (long long)time, (int)type];

            if (i != details.count - 1) {
                [detailStr appendFormat:@","];
            }
        }

        if (detailStr.length > 0) {
            [parameters setObject:detailStr forKey:@"detail"];
        }
        [parameters addEntriesFromDictionary:[self dictionaryWithAuthorization:authorization]];

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:nil
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatHTTP
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self handleResultForResponseError:error
                                           responseObject:responseObject
                                          completionBlock:completionBlock];
                   }];
    }];
}

- (id<HMCancelableAPI> _Nullable)QQDataUploading_step:(id<HMServiceAPIQQDataUploadingStepProtocol>)step
                                        authorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization
                                      completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock; {
    NSParameterAssert(step);
    if (!step) {
        !completionBlock ?: completionBlock(NO, @"没有上传的步数数据");
        return nil;
    }

    NSParameterAssert(authorization);
    if (!authorization) {
        !completionBlock ?: completionBlock(NO, @"没有qq的授权信息");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [NSString stringWithFormat:@"%@report_steps", baseHostURL];

        NSDate *stepDate = step.api_qqDataUploadingStepDate;
        if (![stepDate isToday]) {
            stepDate = [stepDate endOfDay];
        }

        long long time = (long long)[stepDate timeIntervalSince1970];
        NSMutableDictionary *parameters = [@{@"time" : @(time),
                                             @"distance" : @(step.api_qqDataUploadingStepDistance),
                                             @"steps" : @(step.api_qqDataUploadingStep),
                                             @"duration" : @(step.api_qqDataUploadingStepDuration),
                                             @"calories" : @(step.api_qqDataUploadingStepCalories)} mutableCopy];
        [parameters addEntriesFromDictionary:[self dictionaryWithAuthorization:authorization]];

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:nil
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatHTTP
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self handleResultForResponseError:error
                                           responseObject:responseObject
                                          completionBlock:completionBlock];
                   }];
    }];
}

- (id<HMCancelableAPI> _Nullable)QQDataUploading_weight:(id<HMServiceAPIQQDataUploadingWeightProtocol>)weight
                                          authorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization
                                        completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock {
    NSParameterAssert(weight);
    if (!weight) {
        !completionBlock ?: completionBlock(NO, @"没有上传的体重数据");
        return nil;
    }

    NSParameterAssert(authorization);
    if (!authorization) {
        !completionBlock ?: completionBlock(NO, @"没有qq的授权信息");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [NSString stringWithFormat:@"%@report_weight", baseHostURL];
        long long time = (long long)[weight.api_qqDataUploadingWeightDate timeIntervalSince1970];
        NSMutableDictionary *parameters = [@{@"time" : @(time),
                                             @"weight" : @(weight.api_qqDataUploadingWeight),
                                             @"bmi" : @(weight.api_qqDataUploadingWeightBMI),
                                             @"fat_per" : @"0.00"} mutableCopy];
        [parameters addEntriesFromDictionary:[self dictionaryWithAuthorization:authorization]];

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:nil
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatHTTP
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self handleResultForResponseError:error
                                           responseObject:responseObject
                                          completionBlock:completionBlock];
                   }];
    }];
}

- (void)handleResultForResponseError:(NSError *)responseError
                      responseObject:(id)responseObject
                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    if (!completionBlock) {
        return;
    }

    NSString *message = nil;
    BOOL success = NO;
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger ret = [[responseObject objectForKey:@"ret"] integerValue];
        if (ret == 0) {
            success = YES;
        }
    }
    if (responseError) {
        message = responseError.localizedDescription;
    }
    completionBlock(success, message);
}

- (NSDictionary *)dictionaryWithAuthorization:(id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)authorization {

    return  @{@"access_token" : authorization.api_qqDataUploadingAuthorizationToken,
              @"openid" : authorization.api_qqDataUploadingAuthorizationOpenID,
              @"oauth_consumer_key" : authorization.api_qqDataUploadingAuthorizationAppID,
              @"pf" : @"qzone"};
}

@end
