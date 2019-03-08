//
//  HMServiceAPI+Agreement.m
//  AmazfitWatch
//
//  Created by 李宪 on 2018/5/12.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Agreement.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@interface HMServiceAPIAgreement : NSObject <HMServiceAPIAgreement>
@property (assign, nonatomic) HMServiceAPIAgreementType type;
@property (copy, nonatomic) NSString *countryCode;
@property (copy, nonatomic) NSString *version;

@end

@implementation HMServiceAPIAgreement

#pragma mark - HMServiceAPIAgreement

- (HMServiceAPIAgreementType)api_agreementType {
    return self.type;
}

- (NSString *)api_agreementCountryCode {
    return self.countryCode;
}

- (NSString *)api_agreementVersion {
    return self.version;
}

@end


@implementation HMServiceAPI (Agreement)

#pragma mark - HMAgreementServiceAPI


- (id<HMCancelableAPI>)agreement_retrieveWithType:(HMServiceAPIAgreementType)type
                                  completionBlock:(void (^)(BOOL success, NSString *message, NSArray <id<HMServiceAPIAgreement>> * agreements))completionBlock {
    NSParameterAssert(type == HMServiceAPIAgreementTypeUsage ||
                      type == HMServiceAPIAgreementTypePrivacy ||
                      type == HMServiceAPIAgreementTypeImprovement);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:@"apps/pageVersions"];

        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [NSMutableDictionary new];

        switch (type) {
            case HMServiceAPIAgreementTypeUsage:
                parameters[@"redirectType"] = @"agreement";
                break;
            case HMServiceAPIAgreementTypePrivacy:
                parameters[@"redirectType"] = @"privacy";
                break;
            case HMServiceAPIAgreementTypeImprovement:
                parameters[@"redirectType"] = @"experience";
                break;
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error]];
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

                                   if (!completionBlock) {
                                       return;
                                   }

                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }

                                   NSArray *items                   = data.hmjson[@"items"].array;
                                   HMServiceAPIAgreement *agreement = nil;
                                   NSMutableArray *agreements       = [NSMutableArray array];
                                   for (NSDictionary *item in items) {

                                       NSString *version = item.hmjson[@"version"].string;
                                       if (version.length == 0) {
                                           continue;
                                       }

                                       agreement                = [HMServiceAPIAgreement new];
                                       agreement.type           = type;
                                       agreement.countryCode    = item.hmjson[@"language"].string;
                                       agreement.version        = version;
                                       [agreements addObject:agreement];
                                   }

                                   completionBlock(YES, message, agreements.copy);
                               }];
                  }];
    }];
}

@end

