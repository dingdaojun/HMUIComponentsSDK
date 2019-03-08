//  HMServiceAPI+AZConfiguration.m
//  Created on 2018/2/24
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+AZConfiguration.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <objc/runtime.h>


static NSString *stringWithAZConfigurationModule(HMServiceAPIAZConfigurationModule module) {
    switch (module) {
        case HMServiceAPIAZConfigurationModuleDeviceID: return @"huami.watch.companion.phone.device.main";
        case HMServiceAPIAZConfigurationModuleHealth: return @"huami.watch.health.config";
    }
}

@interface NSDictionary (HMServiceAPIConfiguration) <HMServiceAPIConfiguration>
@property (readonly) NSDictionary *api_healthConfigDictionary;

@end

@implementation NSDictionary (HMServiceAPIConfiguration)

- (NSDictionary *)api_healthConfigDictionary {

    NSDictionary *healthConfig = objc_getAssociatedObject(self, "api_healthConfigDictionary");
    if (healthConfig) {
        return healthConfig;
    }
    healthConfig = self.hmjson[@"huami.watch.health.config"].dictionary;
    if (!healthConfig) {
        return nil;
    }
    objc_setAssociatedObject(self, "api_healthConfigDictionary", healthConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return healthConfig;
}

- (BOOL)api_azConfigurationAllDayHeartRate {

    NSDictionary *healthConfig = self.api_healthConfigDictionary;
    return healthConfig.hmjson[@"allday_heartrate"].boolean;
}

- (NSInteger)api_azConfigurationStepTarget {

    NSDictionary *healthConfig = self.api_healthConfigDictionary;
    return healthConfig.hmjson[@"step_target"].integerValue;
}

- (NSString *)api_azConfigurationMainDeviceID {

    return self.hmjson[@"huami.watch.companion.phone.device.main"].string;
}

@end


@implementation HMServiceAPI (AZConfiguration)

- (id<HMCancelableAPI>)azConfiguration_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfiguration> configuration))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        NSArray *property = @[@(HMServiceAPIAZConfigurationModuleDeviceID),
                              @(HMServiceAPIAZConfigurationModuleHealth)];

        NSMutableString *propertyStr = [NSMutableString string];
        for (NSInteger i = 0; i < [property count]; i++) {
            HMServiceAPIAZConfigurationModule module = [[property objectAtIndex:i] integerValue];
            [propertyStr appendFormat:@"%@", stringWithAZConfigurationModule(module)];
            if (i != [property count] - 1) {
                [propertyStr appendFormat:@","];
            }
        }
        NSMutableDictionary *parameters = [@{@"settingName" : @"huami.watch.system.notification.blacklist.ios",
                                             @"mode" : @"BATCH",
                                             @"propertyName" : propertyStr} mutableCopy];
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
                                   if (!completionBlock) {
                                       return;
                                   }

                                   completionBlock(success, message, data);
                               }];
                  }];
    }];
}


@end
