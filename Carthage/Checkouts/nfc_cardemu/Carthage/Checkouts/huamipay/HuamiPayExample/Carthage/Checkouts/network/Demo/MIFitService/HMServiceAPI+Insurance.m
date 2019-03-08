//
//  HMServiceAPI+Insurance.m
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Insurance.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Run)

- (id<HMCancelableAPI>)insurance_runInsurancePolicysWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunInsurancePolicy>> *insurancePolicys))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/user/findpolicy.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];
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
                                      completionBlock:completionBlock];
                  }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIRunInsurancePolicy) <HMServiceAPIRunInsurancePolicy>
@end

@implementation NSDictionary (HMServiceAPIRunInsurancePolicy)

- (NSString *)api_runInsurancePolicyCampaignID {
    return self.hmjson[@"campaignId"].string;
}

- (NSString *)api_runInsurancePolicyProductPackageID {
    return self.hmjson[@"productPackageId"].string;
}

- (NSString *)api_runInsurancePolicyBuyURL {
    return self.hmjson[@"buyUrl"].string;
}

- (NSString *)api_runInsurancePolicyChannelOrderNumber {
    return self.hmjson[@"channelOrderNo"].string;
}

- (NSDate *)api_runInsurancePolicyJoinDate {
    return self.hmjson[@"insureDate"].date;
}

- (NSDate *)api_runInsurancePolicyBecomeEffectiveDate {
    return self.hmjson[@"policyBeginDate"].date;
}

- (NSDate *)api_runInsurancePolicyLoseEffectiveDate {
    return self.hmjson[@"policyEndDate"].date;
}

- (NSString *)api_runInsurancePolicyNumber {
    return self.hmjson[@"policyNo"].string;
}

- (double)api_runInsurancePolicyCoverage {
    return self.hmjson[@"sumInsured"].doubleValue;
}

- (double)api_runInsurancePolicyPremium {
    return self.hmjson[@"premium"].doubleValue;
}

- (NSString *)api_runInsurancePolicyClientCredentialNumber {
    return self.hmjson[@"insuredCertiNo"].string;
}

- (NSString *)api_runInsurancePolicyClientCredentialType {
    return self.hmjson[@"insuredCertiType"].string;
}

- (NSString *)api_runInsurancePolicyClientPhone {
    return self.hmjson[@"insuredPhone"].string;
}

- (NSString *)api_runInsurancePolicyClientName {
    return self.hmjson[@"insuredUserName"].string;
}

- (NSString *)api_runInsurancePolicyClientXiaomiID {
    return self.hmjson[@"xiaomiId"].string;
}

@end
