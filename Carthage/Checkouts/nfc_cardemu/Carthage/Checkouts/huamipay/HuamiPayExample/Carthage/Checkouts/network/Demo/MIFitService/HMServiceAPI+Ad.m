//
//  HMServiceAPI+Ad.m
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Ad.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Ad)

- (id<HMCancelableAPI>)ad_launchPageAdsWithCountry:(NSString *)country
                                          province:(NSString *)province
                                              city:(NSString *)city
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPILaunchPageAd>> *ads))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(country.length > 0);
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat scale = [UIScreen mainScreen].scale;
        NSString *resolution = [NSString stringWithFormat:@"%dx%d", (int)(screenSize.height * scale), (int)(screenSize.width * scale)];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/app/startpages.json"];
        
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
                                             @"country" : country,
                                             @"resolution" : resolution,
                                             @"device" : @"ios_phone"} mutableCopy];
        if (province.length > 0) {
            parameters[@"province"] = province;
        }
        if (city.length > 0) {
            parameters[@"city"] = city;
        }
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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


@interface NSDictionary (HMServiceAPILaunchPageAd) <HMServiceAPILaunchPageAd>
@end

@implementation NSDictionary (HMServiceAPILaunchPageAd)

- (NSString *)api_launchPageAdID {
    return self.hmjson[@"id"].string;
}

- (NSDate *)api_launchPageAdStartTime {
    return self.hmjson[@"start_time"].date;
}

- (NSDate *)api_launchPageAdExpireTime {
    return self.hmjson[@"expire_time"].date;
}

- (NSUInteger )api_launchPageAdSort {
    return self.hmjson[@"sort"].unsignedIntegerValue;
}

- (NSString *)api_launchPageAdTitle {
    return self.hmjson[@"title"].string;
}

- (HMServiceAPILaunchPageAdMediaType )api_launchPageAdMediaType {
    return self.hmjson[@"ad_type"].unsignedIntegerValue;
}

- (NSString *)api_launchPageAdJumpURL {
    return self.hmjson[@"jump_url"].string;
}

- (NSString *)api_launchPageAdBackgroundImageURL {
    return self.hmjson[@"bg_img_url"].string;
}

- (NSString *)api_launchPageAdProvince {
    return self.hmjson[@"province"].string;
}

- (NSString *)api_launchPageAdCity {
    return self.hmjson[@"city"].string;
}

- (HMServiceAPILaunchPageAdShareType )api_launchPageAdShareType {
    return self.hmjson[@"share"].unsignedIntegerValue;
}

- (NSString *)api_launchPageAdShareTitle {
    return self.hmjson[@"share_title"].string;
}

- (NSString *)api_launchPageAdShareSubtitle {
    return self.hmjson[@"share_subtitle"].string;
}

- (NSString *)api_launchPageAdShareLink {
    return self.hmjson[@"share_url"].string;
}

- (NSString *)api_launchPageAdThirdPartyAppID {
    return self.hmjson[@"appid"].string;
}

- (BOOL )api_launchPageAdShouldWriteCookie {
    return self.hmjson[@"cookie"].boolean;
}

- (BOOL )api_launchPageAdCanOpenViaGPRS {
    return self.hmjson[@"isLoadWithGPRS"].boolean;
}

@end
