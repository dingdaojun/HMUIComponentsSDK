//
//  HMServiceAPI+Firmware.m
//  HuamiWatch
//
//  Created by 李宪 on 28/7/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+Firmware.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Firmware)

- (id<HMCancelableAPI>)firmware_checkNewVersionWithUserID:(NSString *)userID
                                   currentFirmwareVersion:(NSString *)currentFirmwareVersion
                                            deviceVersion:(NSString *)deviceVersion
                                             serialNumber:(NSString *)serialNumber
                                          completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIFirmware>firmware))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
       
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", nil);
                });
            }
            return nil;
        }
        
        NSParameterAssert(currentFirmwareVersion.length > 0);
        NSParameterAssert(deviceVersion.length > 0);
        NSParameterAssert(serialNumber.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"devices/WATCH/hasNewVersion"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userId" : userID,
                                             @"firmwareVersion" : currentFirmwareVersion,
                                             @"sensorType" : @"ECG",
                                             @"sensorVersion" : @"ALL",
                                             @"country" : @"CN",
                                             @"lang" : @"zh_CN",
                                             @"deviceVersion" : deviceVersion,
                                             @"appName" : [NSBundle mainBundle].bundleIdentifier,
                                             @"appVersion" : @"1.0",
                                             @"sn" : serialNumber} mutableCopy];
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
                               completionBlock:completionBlock];
                  }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIFirmware) <HMServiceAPIFirmware>
@end

@implementation NSDictionary (HMServiceAPIFirmware)

- (NSString *)api_firmwareTargetVersion {
    return self.hmjson[@"targetFirmwareVersion"].string;
}

- (NSString *)api_firmwareDeviceVersion {
    return self.hmjson[@"deviceVersion"].string;
}

- (NSString *)api_firmwareSensorVersion {
    return self.hmjson[@"sensorVersion"].string;
}

- (NSString *)api_firmwareFileURL {
    return self.hmjson[@"fileUrl"].string;
}

- (NSUInteger)api_firmwareFileSize {
    return self.hmjson[@"fileSize"].unsignedIntegerValue;
}

- (NSString *)api_firmwareFileMD5 {
    return self.hmjson[@"fileMD5"].string;
}

- (NSString *)api_firmwareChangeLog {
    return self.hmjson[@"changeLog"].string;
}

- (NSUInteger )api_firmwareUpgradeType {
    return self.hmjson[@"upgradeType"].unsignedIntegerValue;
}

@end
