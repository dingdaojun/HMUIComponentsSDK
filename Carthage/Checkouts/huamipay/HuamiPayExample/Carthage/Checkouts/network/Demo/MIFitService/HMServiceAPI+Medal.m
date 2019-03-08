//
//  HMServiceAPI+Medal.m
//  HMServiceAPI+MIFit
//
//  Created by 单军龙 on 2017/10/24.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Medal.h"
#import <objc/runtime.h>
#import <HMNetworkLayer/HMNetworkLayer.h>

@interface NSDictionary (HMServiceAPIWatchData) <HMServiceAPIMedalData>
@end

@implementation NSDictionary (HMServiceAPIWatchData)

- (NSDictionary *)api_medalDataAssetsDictionary {

    NSDictionary *assets = objc_getAssociatedObject(self, "api_medalDataAssetsDictionary");
    if (!assets) {
        assets = self.hmjson[@"assets"].dictionary;
        if (!assets) {
            return nil;
        }

        objc_setAssociatedObject(self, "api_medalDataAssetsDictionary", assets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return assets;
}


- (NSString *)api_medalDataID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_medalDataTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_medalDataSubTitle {
    return self.hmjson[@"sub_title"].string;
}

- (NSString *)api_medalDataTitleImageUrl {
    return self.api_medalDataAssetsDictionary.hmjson[@"title_img"].string;
}

- (NSString *)api_medalDataNotObtainIconUrl {
    return self.api_medalDataAssetsDictionary.hmjson[@"not_obtain_icon"].string;
}

- (NSString *)api_medalDataNotObtainText {
    return self.api_medalDataAssetsDictionary.hmjson[@"not_obtain_text"].string;
}

- (NSString *)api_medalDataObtainIconUrl {
    return self.api_medalDataAssetsDictionary.hmjson[@"obtain_icon"].string;
}

- (NSString *)api_medalDataObtainText {
    return self.api_medalDataAssetsDictionary.hmjson[@"obtain_text"].string;
}

- (NSString *)api_medalDataCategory {
    return self.hmjson[@"category"].string;
}

@end



@implementation HMServiceAPI (Medal)

- (id<HMCancelableAPI>)medal_dataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIMedalData>> *medalDatas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"incentive/mi/users/%@/medals", userID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

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

        NSMutableDictionary *parameters = [@{@"filter" : @"not_received"} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatArray
                               completionBlock:^(BOOL success, NSString *message, NSArray *data) {

                                   if (completionBlock) {
                                       completionBlock(success, message, data);
                                   }
                               }];
                  }];
    }];
}


- (id<HMCancelableAPI>)medal_uploadDataWithMedalID:(NSString *)medalID
                                   completionBlock:(void (^)(BOOL success, NSInteger statusCode, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, 0, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"incentive/mi/medals/%@/take", medalID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];

        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, 0, error.localizedDescription);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"user_id" : userID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];

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
                              desiredDataFormat:HMServiceResultDataFormatAny
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                    NSInteger statusCode = 0;
                                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                        statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                    }

                                    if (completionBlock) {
                                        completionBlock(success, statusCode, message);
                                    }
                                }];
                   }];
    }];
}






@end
