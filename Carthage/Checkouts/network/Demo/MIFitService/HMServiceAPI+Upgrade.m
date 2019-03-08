//
//  HMServiceAPI+Upgrade.m
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Upgrade.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Upgrade)

- (id<HMCancelableAPI>)upgrade_newVersionWithVersionCode:(NSUInteger)versionCode
                                         completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIUpgradeVersion>version))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(versionCode > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/apps/upgrades.json"];
        
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
                                             @"versionCode" : @(versionCode),
                                             @"appChannel" : @"ios"} mutableCopy];
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


@interface NSDictionary (HMServiceAPIUpgradeVersion) <HMServiceAPIUpgradeVersion>
@end

@implementation NSDictionary (HMServiceAPIUpgradeVersion)

- (HMServiceAPIUpgradeType)api_upgradeVersionType {
    return self.hmjson[@"upgradeType"].unsignedIntegerValue;
}

- (NSString *)api_upgradeVersionSimplifiedChineseLog {
    return self.hmjson[@"changeLog"][@"cnChangeLog"].string;
}

- (NSString *)api_upgradeVersionTraditionalChineseLog {
    return self.hmjson[@"changeLog"][@"twChangeLog"].string;
}

- (NSString *)api_upgradeVersionEnglishLog {
    return self.hmjson[@"changeLog"][@"enChangeLog"].string;
}

@end
