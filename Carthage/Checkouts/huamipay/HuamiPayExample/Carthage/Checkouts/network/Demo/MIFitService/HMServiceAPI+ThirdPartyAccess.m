//
//  Created on 2017/11/3
//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+ThirdPartyAccess.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@interface NSDictionary (HMServiceAPIWatchData) <HMServiceAPIThirdPartyAccessData>
@end

@implementation NSDictionary (HMServiceAPIThirdPartyAccessData)

- (NSString *)api_thirdPartyAccessDataAppID {
    return self.hmjson[@"third_appid"].string;
}


- (NSString *)api_thirdPartyAccessDataUserID {
    NSString *userID = self.hmjson[@"third_userid"].string;
    if (userID.length > 0) {
        return userID;
    }
    return self.hmjson[@"third_app_uid"].string;
}

- (NSString *)api_thirdPartyAccessDataAccessToken {
    return self.hmjson[@"access_token"].string;
}

- (NSString *)api_thirdPartyAccessDataNickName {
    return self.hmjson[@"nick_name"].string;
}

- (NSTimeInterval)api_thirdPartyAccessDataExpiresTime {
    return self.hmjson[@"expires_in"].doubleValue;
}

@end


@implementation HMServiceAPI (ThirdPartyAccess)

- (id<HMCancelableAPI>)thirdPartyAccess_bindWithAccessData:(id<HMServiceAPIThirdPartyAccessData>)accessData
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    return [self thirdPartyAccess_bindWithAccessData:accessData
                                              unbind:NO
                                     completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)thirdPartyAccess_unbindWithAccessData:(id<HMServiceAPIThirdPartyAccessData>)accessData
                                             completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    return [self thirdPartyAccess_bindWithAccessData:accessData
                                              unbind:YES
                                     completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)thirdPartyAccess_bindWithAccessData:(id<HMServiceAPIThirdPartyAccessData>)accessData
                                                    unbind:(BOOL)unbind
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.partner.bindThirdApp.json"];

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

        NSString *thirdAppID = accessData.api_thirdPartyAccessDataAppID?:@"";
        NSString *thirdUserID = accessData.api_thirdPartyAccessDataUserID?:@"";
        NSString *accessToken = accessData.api_thirdPartyAccessDataAccessToken?:@"";
        NSString *nickName = accessData.api_thirdPartyAccessDataNickName?:@"";
        NSString *expiresTimeStr = [NSString stringWithFormat:@"%d", (int)accessData.api_thirdPartyAccessDataExpiresTime];

        NSParameterAssert(thirdAppID.length > 0 || thirdUserID > 0);

        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"third_appid" : thirdAppID,
                                             @"third_userid" : thirdUserID,
                                             @"access_token" : accessToken,
                                             @"nick_name" : nickName,
                                             @"expires_in" : expiresTimeStr} mutableCopy];

        if (unbind) {
            [parameters setObject:@(YES) forKey:@"unbind"];
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                           completionBlock(success, message);
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)thirdPartyAccess_dataWithThirdAppID:(NSString *)thirdAppID
                                           completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIThirdPartyAccessData> thirdPartyData))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(thirdAppID.length > 0);

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.partner.getAppToken.json"];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"third_appid" : thirdAppID?:@""} mutableCopy];

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                           if (!completionBlock) {
                                               return;
                                           }
                                           if (!success || !data) {
                                               completionBlock(success, message, data);
                                               return;
                                           }

                                           if (data.hmjson[@"status"].boolean) {
                                               completionBlock(success, message, data);
                                           }
                                           else {
                                               completionBlock(success, message, nil);
                                           }
                                       }];
                   }];
    }];
}


@end
