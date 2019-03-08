//
//  HMServiceAPI+Configuration.m
//  HuamiWatch
//
//  Created by 李宪 on 1/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+Configuration.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Configuration)

- (id<HMCancelableAPI>)configuration_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfiguration>configuration))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            return nil;
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userId" : userID,
                                             @"propertyName" : @"huami.watch",
                                             @"mode" : @"RANGE"} mutableCopy];
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
                                   
                                   BOOL isNewUser = data.hmjson[@"huami.watch.companion.phone.account.newuser"].boolean;
                                   if (isNewUser) {
                                       completionBlock(YES, message, nil);
                                       return;
                                   }
                                   
                                   completionBlock(YES, message, (id<HMServiceAPIConfiguration>)data);
                               }];
                  }];
    }];
}


@end



@interface NSDictionary (HMServiceAPIConfiguration) <HMServiceAPIConfiguration>
@end

@implementation NSDictionary (HMServiceAPIConfiguration)

- (NSString *)api_configurationWeatherCityName {
    return self.hmjson[@"huami.watch.companion.phone.weather.city"][@"cityName"].string;
}

- (NSString *)api_configurationWeatherCityLocationKey {
    return self.hmjson[@"huami.watch.companion.phone.weather.city"][@"locationKey"].string;
}

- (NSString *)api_configurationMainDeviceID {
    return self.hmjson[@"huami.watch.companion.phone.device.main"].string;
}

@end

