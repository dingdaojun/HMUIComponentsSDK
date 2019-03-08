//  HMServiceAPI+ReactNative.m
//  Created on 2018/6/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+ReactNative.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@interface NSDictionary (HMServiceAPIReactNativeFileInfo) <HMServiceAPIReactNativeFileInfo>
@end

@implementation NSDictionary (HMServiceAPIReactNativeFileInfo)

- (NSString *)api_reactNativeFileMode {
    return self.hmjson[@"mode"].string;
}

- (NSString *)api_reactNativeFileKey {
    return self.hmjson[@"key"].string;
}

- (long long)api_reactNativeFileSize {
    return self.hmjson[@"size"].number.longLongValue;
}

- (NSString *)api_reactNativeFileUrl {
    return self.hmjson[@"src"].string;
}

- (NSInteger)api_reactNativeFileVersion {
    return self.hmjson[@"version"].integerValue;
}

@end

@implementation HMServiceAPI (ReactNative)

- (id<HMCancelableAPI>)reactNative_authorizeForJavaScriptWithAppKey:(NSString *)appKey
                                                          timestamp:(NSString *)timestamp
                                                              nonce:(NSString *)nonce
                                                          signature:(NSString *)signature
                                                             webURL:(NSString *)webURL
                                                           apiNames:(NSArray<NSString *> *)apiNames
                                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<NSString *> *authorizedAPINames))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(appKey.length > 0);
        NSParameterAssert(timestamp.length > 0);
        NSParameterAssert(nonce.length > 0);
        NSParameterAssert(signature.length > 0);
        NSParameterAssert(webURL.length > 0);

        NSString *apiNamesString = [apiNames componentsJoinedByString:@","];

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"jsbridge/verify"];

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
                                             @"appkey" : appKey,
                                             @"timestamp" : timestamp,
                                             @"nonceStr" : nonce,
                                             @"signature" : signature,
                                             @"url" : webURL,
                                             @"jsApiList" : apiNamesString} mutableCopy];
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

                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                          NSArray *authorizedAPINames = nil;
                                          if (success) {
                                              authorizedAPINames = data.hmjson[@"jsApiList"].array;
                                          }

                                          if (completionBlock) {
                                              completionBlock(success, message, authorizedAPINames);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)reactNative_updateWithModules:(NSArray<NSString *> *)modules
                                            versions:(NSArray<NSString *> *)versions
                                     completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIReactNativeFileInfo> fileInfo))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(modules.count == versions.count);
    if (modules.count != versions.count) {
        completionBlock(NO, @"modules, versions 不对应", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"discovery/mi/rn/module/update"];
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }

        if (modules.count > 0) {
            [parameters setObject:[self encodeStringWithArray:modules] forKey:@"modules"];
        }
        if (versions.count > 0) {
            [parameters setObject:[self encodeStringWithArray:versions] forKey:@"versions"];
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
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                   NSDictionary *discovery = data.hmjson[@"discovery"].dictionary;
                                   completionBlock(success, message, discovery);
                               }];
                  }];
    }];
}


- (NSString *)encodeStringWithArray:(NSArray<NSString *> *)array {

    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i++) {
        if (i != 0) {
            [string appendString:@","];
        }
        NSString *data = [array objectAtIndex:i];
        [string appendString:data];
    }

    return string;
}

@end





