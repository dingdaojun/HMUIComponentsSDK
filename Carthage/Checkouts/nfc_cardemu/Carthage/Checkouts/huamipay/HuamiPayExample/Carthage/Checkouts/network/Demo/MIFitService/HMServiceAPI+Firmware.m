//
//  HMServiceAPI+Firmware.m
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Firmware.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Firmware)

- (id<HMCancelableAPI>)firmware_listWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *firmwares))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/firmwares.json"];
        
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
                                             @"app_channel" : @"ios",
                                             @"app_version" : appVersion} mutableCopy];
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


@interface NSDictionary (HMServiceAPIFirmware) <HMServiceAPIFirmware>
@end

@implementation NSDictionary (HMServiceAPIFirmware)

- (NSString *)api_firmwareVersion {
    return self.hmjson[@"firmware_version"].string;
}

- (NSString *)api_firmwareFileURL {
    return self.hmjson[@"file_url"].string;
}

- (NSString *)api_firmwareMD5 {
    return self.hmjson[@"md5_content"].string;
}

- (NSString *)api_firmwareAppVersion {
    return self.hmjson[@"app_version"].string;
}

- (NSString *)api_firmwareChangeLog {
    return self.hmjson[@"change_log"].string;
}

- (HMServiceAPIDeviceType )api_firmwareDeviceType {
    return self.hmjson[@"device_type"].unsignedIntegerValue;
}

- (HMServiceAPIDeviceSource )api_firmwareDeviceSource {
    return self.hmjson[@"source"].unsignedIntegerValue;
}

- (HMServiceAPIProductVersion )api_firmwareProductVersion {
    return self.hmjson[@"productVersion"].unsignedIntegerValue;
}

@end
