//
//  HMServiceAPI+Advertisement.m
//  AmazfitWatch
//
//  Created by 李宪 on 2018/6/1.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Advertisement.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (Advertisement)

- (id<HMCancelableAPI>)advertisement_advertisementForType:(HMServiceAPIAdvertisementType)type
                                                   userID:(NSString *)userID
                                              addressCode:(NSString *)addressCode
                                          completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIAdvertisement>> *advertisements))completionBlock {

    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        if (completionBlock) {
            completionBlock(NO, @"Invalid user ID", nil);
        }
        return nil;
    }

    NSParameterAssert(type == HMServiceAPIAdvertisementTypeHomeBanner ||
                      type == HMServiceAPIAdvertisementTypeHomePopup);
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = nil;
        switch (type) {
            case HMServiceAPIAdvertisementTypeHomeBanner:
                URL = @"/discovery/watch/discovery/homepage_ad";
                break;
            case HMServiceAPIAdvertisementTypeHomePopup:
                URL = @"/discovery/watch/discovery/homepage_popup";
                break;
        }

        URL = [URL stringByAppendingFormat:@"?userid=%@&adcode=%@", userID, addressCode ?: @""];

        URL = [self.delegate absoluteURLForService:self
                                      referenceURL:URL];

        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, nil, nil);
                });
            }
            return nil;
        }

        headers[@"lang"]                = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        headers[@"country"]             = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];

        headers[@"timezone"]            = [NSTimeZone systemTimeZone].name;


        NSMutableDictionary *parameters = [NSMutableDictionary new];
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

                                   if (!completionBlock) {
                                       return;
                                   }

                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }

                                   NSIndexSet *indexes = [data
                                                          indexesOfObjectsPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                                                              if (obj.hmjson[@"id"].string.length == 0) {
                                                                  return NO;
                                                              }

                                                              if (obj.hmjson[@"mode"].unsignedIntegerValue != 1) {
                                                                  return NO;
                                                              }

                                                              return YES;
                                                          }];
                                   NSArray *advertisements = [data objectsAtIndexes:indexes];

                                   completionBlock(YES, message, advertisements);
                               }];
                  }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIAdvertisement) <HMServiceAPIAdvertisement>
@end

@implementation NSDictionary (HMServiceAPIAdvertisement)

- (NSString *)api_advertisementID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_advertisementTargetURL {
    return self.hmjson[@"target"].string;
}

- (NSString *)api_advertisementTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_advertisementImageURL {
    return self.hmjson[@"image"].string;
}

- (NSString *)api_advertisementLogoURL {
    return self.hmjson[@"extensions"][@"image"].string;
}

@end
