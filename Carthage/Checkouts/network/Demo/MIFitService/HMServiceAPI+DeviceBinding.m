//
//  HMServiceAPI+DeviceBinding.m
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+DeviceBinding.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/HMCategoryKit.h>

@interface NSDictionary (HMServiceAPIDeviceBindingDevice) <HMServiceAPIDeviceBindingDevice>
@end

@interface NSDictionary (HMServiceAPIDeviceBindingInfo) <HMServiceAPIDeviceBindingInfo>
@end



@implementation HMServiceAPI (DeviceBinding)

- (id<HMCancelableAPI>)deviceBinding_queryBindableWithDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                             completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIDeviceBindingInfo> info))completionBlock; {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        HMServiceAPIDeviceType deviceType       = device.api_deviceBindingDeviceType;
        HMServiceAPIDeviceSource deviceSource   = device.api_deviceBindingDeviceSource;
        NSString *deviceID                      = device.api_deviceBindingDeviceID;
        NSString *MAC                           = device.api_deviceBindingDeviceMAC;
        NSString *CRC8                          = device.api_deviceBindingDeviceShushanBandCRC8?:@"";
        HMServiceAPIDeviceTypeParameterAssert(deviceType);
        HMServiceAPIDeviceSourceParameterAssert(deviceSource);
        NSParameterAssert(MAC.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/device/binds.json"];
        
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
                                             @"device_type" : @(deviceType),
                                             @"device_source" : @(deviceSource),
                                             @"mac" : MAC,
                                             @"crcedUserId" : CRC8,
                                             @"enableMultiDevice" : @(YES)} mutableCopy];

        if (deviceID.length > 0) {
            [parameters setObject:deviceID forKey:@"deviceid"];
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
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                          if (completionBlock) {
                                              completionBlock(success, message, data);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)deviceBinding_bindWithDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                    completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIDeviceBindingInfo> info))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSDate *appBoundTime                        = device.api_deviceBindingDeviceAppBoundTime;
        NSTimeZone *timeZone                        = device.api_deviceBindingDeviceTimeZone;
        HMServiceAPIDeviceType deviceType           = device.api_deviceBindingDeviceType;
        HMServiceAPIDeviceSource deviceSource       = device.api_deviceBindingDeviceSource;
        NSString *deviceID                          = device.api_deviceBindingDeviceID;
        NSString *MAC                               = device.api_deviceBindingDeviceMAC;
        NSString *shoeSerialNumber                  = device.api_deviceBindingDeviceSN;
        NSString *proBandAuthKey                    = device.api_deviceBindingDeviceAuthKey;
        NSString *firmwareVersion                   = device.api_deviceBindingDeviceFirmwareVersion;
        NSString *heartRateFirmwareVersion          = device.api_deviceBindingDeviceHeartRateFirmwareVersion;
        NSInteger activeStatus                      = device.api_deviceBindingDeviceActiveStatus ? 1 : 0;
        NSString *displayName                       = device.api_deviceBindingDeviceRemarks?:@"";
        NSInteger productVersion                    = device.api_deviceBindingDeviceProductVersion;
        NSString *productID                         = device.api_deviceBindingDeviceProductID?:@"";
        NSInteger brandType                         = device.api_deviceBindingDeviceBrandType;
        HMServiceAPIDeviceTypeParameterAssert(deviceType);
        HMServiceAPIDeviceSourceParameterAssert(deviceSource);
        NSParameterAssert(deviceID.length > 0);
        
        NSString *systemVersion = [NSString stringWithFormat:@"ios_%@", [UIDevice currentDevice].systemVersion];
        NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSString *iOSDeviceModel = [UIDevice deviceName];
        
        NSString *URL = (deviceType == HMServiceAPIDeviceTypeWatch ? @"v1/watch/binds.json" : @"v1/device/binds.json");
        URL = [self.delegate absoluteURLForService:self referenceURL:URL];
        
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
                                             @"device_type" : @(deviceType),
                                             @"deviceid" : deviceID,
                                             @"device_source" : @(deviceSource),
                                             @"mac" : MAC,
                                             @"brand" : @"Apple",
                                             @"sys_version" : systemVersion,
                                             @"soft_version" : appVersion,
                                             @"sys_model" : iOSDeviceModel,
                                             @"activeStatus" : @(activeStatus),
                                             @"displayName" : displayName,
                                             @"deviceType" : @(deviceType),
                                             @"productId" : productID,
                                             @"productVersion" : @(productVersion),
                                             @"brandType" : @(brandType),
                                             @"enableMultiDevice" : @(YES)} mutableCopy];
        if (appBoundTime) {
            parameters[@"app_time"] = @((int64_t)appBoundTime.timeIntervalSince1970);
        }
        if (timeZone) {
            parameters[@"bind_timezone"] = @([timeZone hms_offset]);
        }
        if (shoeSerialNumber.length > 0) {
            parameters[@"sn"] = shoeSerialNumber;
        }
        if (proBandAuthKey.length > 0) {
            parameters[@"auth_key"] = proBandAuthKey;
        }
        if (firmwareVersion.length > 0) {
            parameters[@"fw_version"] = firmwareVersion;
        }
        if (heartRateFirmwareVersion.length > 0) {
            parameters[@"fw_hr_version"] = heartRateFirmwareVersion;
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
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           if (completionBlock) {
                                               completionBlock(success, message, data);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)deviceBinding_unbindDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        HMServiceAPIDeviceType deviceType           = device.api_deviceBindingDeviceType;
        HMServiceAPIDeviceSource deviceSource       = device.api_deviceBindingDeviceSource;
        NSString *deviceID                          = device.api_deviceBindingDeviceID;
        NSString *MAC                               = device.api_deviceBindingDeviceMAC;
        NSString *CRC8                              = device.api_deviceBindingDeviceShushanBandCRC8?:@"";
        HMServiceAPIDeviceTypeParameterAssert(deviceType);
        HMServiceAPIDeviceSourceParameterAssert(deviceSource);
        NSParameterAssert(deviceID.length > 0);
        NSParameterAssert(MAC.length > 0);
        
        
        NSString *URL = (deviceType == HMServiceAPIDeviceTypeWatch ? @"v1/watch/binds.json" : @"v1/device/binds.json");
        URL = [self.delegate absoluteURLForService:self referenceURL:URL];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"device_type" : @(deviceType),
                                             @"deviceid" : deviceID,
                                             @"device_source" : @(deviceSource),
                                             @"mac" : MAC,
                                             @"crcedUserId" : CRC8,
                                             @"enableMultiDevice" : @(YES)} mutableCopy];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore DELETE:URL
                          parameters:parameters
                             headers:headers
                             timeout:0
                     completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                         
                         [self legacy_handleResultForAPI:_cmd
                                           responseError:error
                                                response:response
                                          responseObject:responseObject
                                         completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                             if (completionBlock) {
                                                 completionBlock(success, message);
                                             }
                                         }];
                     }];
    }];
}


- (id<HMCancelableAPI>)deviceBinding_boundWatchDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock {

    return [self deviceBinding_queryDevicesWithCompletionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices) {

        NSMutableArray *boundDevices = [NSMutableArray array];
        if (success && [devices isKindOfClass:[NSArray class]]) {
            for (NSDictionary *device in devices) {
                if (device.api_deviceBindingDeviceType == HMServiceAPIDeviceTypeWatch) {
                    [boundDevices addObject:device];
                }
            }
        }

        if (completionBlock) {
            completionBlock(success, message, boundDevices);
        }
    }];
}

- (id<HMCancelableAPI>)deviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock {

    return [self deviceBinding_queryDevicesWithCompletionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices) {

        NSMutableArray *boundDevices = [NSMutableArray array];
        if (success && [devices isKindOfClass:[NSArray class]]) {
            for (NSDictionary *device in devices) {
                if (device.api_deviceBindingDeviceIsBound) {
                    [boundDevices addObject:device];
                }
            }
        }

        if (completionBlock) {
            completionBlock(success, message, boundDevices);
        }
    }];
}

- (id<HMCancelableAPI>)deviceBinding_queryDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock {


    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/device/lists.json"];

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
                                             @"enableMultiDevice" : @(YES)} mutableCopy];

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
                                      completionBlock:^(BOOL success, NSString *message, NSArray *devices) {

                                          completionBlock(success, message, devices);
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)deviceBinding_modifyWithDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                      completionBlock:(void (^)(BOOL success, NSString *message, HMServiceBindDeviceState state))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", HMServiceBindDeviceStateUnkown);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        HMServiceAPIDeviceType deviceType = device.api_deviceBindingDeviceType;
        NSString *deviceID  = device.api_deviceBindingDeviceID;
        NSInteger activeStatus = device.api_deviceBindingDeviceActiveStatus ? 1 : 0;
        NSString *displayName = device.api_deviceBindingDeviceRemarks;
        HMServiceAPIDeviceTypeParameterAssert(deviceType);
        NSParameterAssert(deviceID.length > 0);

        NSString *referenceURL = [NSString stringWithFormat:@"/users/%@/devices/%@", userID, deviceID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, HMServiceBindDeviceStateUnkown);
                });
            }
            return nil;
        }
        NSMutableDictionary *parameters = [@{@"activeStatus" : @(activeStatus),
                                             @"displayName" : displayName,
                                             @"deviceType" : @(deviceType)} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, HMServiceBindDeviceStateUnkown);
                });
            }
            return nil;
        }

        return [HMNetworkCore PUT:URL
                       parameters:parameters
                          headers:headers
                          timeout:30
                requestDataFormat:HMNetworkRequestDataFormatJSON
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   if (completionBlock) {
                                       completionBlock(success, message, HMServiceBindDeviceStateUnkown);
                                   }
                               }];

                  }];
    }];
}

@end

@implementation NSDictionary (HMServiceAPIDeviceBindingInfo)

- (NSString *)api_deviceBindingDeviceOtherNickName {
    return self.hmjson[@"nickname"].string;
}

- (NSString *)api_deviceBindingDeviceOtherUserID {
    return self.hmjson[@"userid"].string;
}

- (HMServiceBindDeviceState)api_deviceBindingDeviceState {
    return self.hmjson[@"status"].integerValue;
}

- (NSDate *)api_deviceBindingDeviceOtherBingTime {
    return self.hmjson[@"server_time"].date;
}

@end


@implementation NSDictionary (HMServiceAPIDeviceBindingDevice)

- (BOOL)api_deviceBindingDeviceIsBound {

    NSInteger bindingStatus = self.hmjson[@"binding_status"].integerValue;
    if (bindingStatus != 1) {
        return NO;
    }

    // 手表的设备针对小米运动会有虚拟绑定，当status不为1时没有被小米运动绑定
    if (self.api_deviceBindingDeviceSource == HMServiceAPIDeviceSourceWatchHuanghe ||
        self.api_deviceBindingDeviceSource == HMServiceAPIDeviceSourceWatchEverest ||
        self.api_deviceBindingDeviceSource == HMServiceAPIDeviceSourceWatchEverest2S) {

        NSInteger status = self.hmjson[@"status"].integerValue;
        if (status != 1) {
            return NO;
        }
    }
    
    return YES;
}

- (NSDate *)api_deviceBindingDeviceAppBoundTime {
    return self.hmjson[@"app_time"].date;
}

- (NSTimeZone *)api_deviceBindingDeviceTimeZone {
    NSInteger offset = self.hmjson[@"bind_timezone"].integerValue;
    return [NSTimeZone hms_timeZoneWithOffset:offset];
}

- (HMServiceAPIDeviceType )api_deviceBindingDeviceType {
    return self.hmjson[@"device_type"].unsignedIntegerValue;
}

- (HMServiceAPIDeviceSource )api_deviceBindingDeviceSource {
    return self.hmjson[@"device_source"].unsignedIntegerValue;
}

- (NSString *)api_deviceBindingDeviceID {
    return self.hmjson[@"deviceid"].string;
}

- (NSString *)api_deviceBindingDeviceMAC {
    return self.hmjson[@"mac"].string;
}

- (NSString *)api_deviceBindingDeviceSN {
    return self.hmjson[@"sn"].string;
}

- (NSString *)api_deviceBindingDeviceAuthKey {
    return self.hmjson[@"auth_key"].string;
}

- (NSString *)api_deviceBindingDeviceShushanBandCRC8 {
    return self.hmjson[@"crcedUserId"].string;
}

- (NSString *)api_deviceBindingDeviceFirmwareVersion {
    return self.hmjson[@"fw_version"].string;
}

- (NSString *)api_deviceBindingDeviceHeartRateFirmwareVersion {
    return self.hmjson[@"fw_hr_version"].string;
}

- (NSDate *)api_deviceBindingDeviceLastSyncDataTime {
    return self.hmjson[@"last_sync_data_time"].date;
}

- (NSDate *)api_deviceBindingDeviceLastSyncHeartRateDataTime {
    return self.hmjson[@"hr_last_sync_time"].date;
}

- (NSDate *)api_deviceBindingDeviceLastUpdateTime {
    return self.hmjson[@"last_update_time"].date;
}

- (BOOL)api_deviceBindingDeviceActiveStatus {
    return self.hmjson[@"activeStatus"].boolean;
}

- (NSString *)api_deviceBindingDeviceRemarks {
    return self.hmjson[@"displayName"].string;
}

- (NSString *)api_deviceBindingDeviceProductID {
    return self.hmjson[@"productId"].string;
}

- (NSInteger)api_deviceBindingDeviceProductVersion {
    return self.hmjson[@"productVersion"].integerValue;
}

- (NSInteger)api_deviceBindingDeviceBrandType {
    return self.hmjson[@"brandType"].integerValue;
}

@end
