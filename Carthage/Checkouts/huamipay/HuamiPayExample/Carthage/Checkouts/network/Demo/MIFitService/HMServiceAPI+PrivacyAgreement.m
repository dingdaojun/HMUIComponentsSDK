//  HMServiceAPI+PrivacyAgreement.m
//  Created on 2018/5/18
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+PrivacyAgreement.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@interface NSDictionary (HMServiceAPIPrivacyAgreementVersion) <HMServiceAPIPrivacyAgreementVersion>
@end

@implementation NSDictionary (HMServiceAPIPrivacyAgreementVersion)

- (NSString *)api_privacyAgreementLanguage {
    return self.hmjson[@"language"].string?:@"";
}

- (NSString *)api_privacyAgreementVersion {
    return self.hmjson[@"version"].string?:@"";
}

@end

@implementation HMServiceAPI (PrivacyAgreement)


- (id<HMCancelableAPI>)privacyAgreement_retrieveWithType:(NSString *)type
                                             countryCode:(NSString *)countryCode
                                                  isAuth:(BOOL)isAuth
                                         completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIPrivacyAgreementVersion>> *privacyAgreements))completionBlock {

    if (!completionBlock) {
        return nil;
    }
    NSString *userID = nil;
    if (isAuth) {
        userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
            return nil;
        }
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:@"apps/pageVersions"];
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"redirectType" : type,
                                             @"lang" : countryCode} mutableCopy];

        if (userID.length > 0) {
            [parameters setObject:userID forKey:@"userId"];
        }
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
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}


@end
