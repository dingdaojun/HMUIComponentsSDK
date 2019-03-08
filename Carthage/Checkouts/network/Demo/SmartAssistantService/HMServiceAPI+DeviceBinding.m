//
//  HMServiceAPI+DeviceBinding.m
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+DeviceBinding.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@interface NSDictionary (HMServiceAPIDeviceBindingDevice) <HMServiceAPIDeviceBindingDevice>
- (BOOL)api_deviceBindingDeviceIsBound;
@end

@implementation HMServiceAPI (DeviceBinding)

- (id<HMCancelableAPI>)deviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBindableDevice>> *devices))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"/users/%@/devices", userID]];

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

        NSMutableDictionary *parameters     = [NSMutableDictionary dictionary];
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
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatAny
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   if (!completionBlock) {
                                       return;
                                   }

                                   NSArray *devices = data.hmjson[@"items"].array;

                                   NSMutableArray *bindedDevices = [NSMutableArray new];
                                   for (NSDictionary<HMServiceAPIBindableDevice> *device in devices) {
                                       if (device.hmjson[@"deviceType"].unsignedIntegerValue != HMServiceAPIDeviceTypeWatch) {
                                           continue;
                                       }
                                       
                                       [bindedDevices addObject:device];
                                   }

                                   completionBlock(success, message, bindedDevices);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)miFitdeviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock {
    
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
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];
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
                                      completionBlock:^(BOOL success, NSString *message, NSArray *devices) {
                                          NSMutableArray *boundDevices = [NSMutableArray new];
                                          
                                          // 过滤未绑定的设备
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
                  }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIBindableDevice) <HMServiceAPIBindableDevice>
@end

@implementation NSDictionary (HMServiceAPIBindableDevice)

- (NSString *)api_bindableDeviceID {
    return self.hmjson[@"deviceId"].string;
}

- (HMServiceAPIDeviceSource)api_bindableDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}

- (NSString *)api_bindableDeviceMACAddress {
    return self.hmjson[@"macAddress"].string;
}

- (NSString *)api_bindableDeviceModelName {
    return self.hmjson[@"additionalInfo"][@"modelNum"].string;
}

- (BOOL)api_bindableDeviceBoundWithIOSDevice {
    return [self.hmjson[@"lastBindingPlatform"].string.lowercaseString isEqualToString:@"ios_phone"];
}

- (BOOL)api_bindableDeviceBound {
    return self.hmjson[@"bindingStatus"].boolean;
}

@end


@implementation NSDictionary (HMServiceAPIDeviceBindingDevice)

- (BOOL)api_deviceBindingDeviceIsBound {
    
    // 这个逻辑从小米运动2.x代码抄来，应该是手表的绑定状态status和其他的不一致导致的
    if (self.api_deviceBindingDeviceSource == HMServiceAPIDeviceSourceWatchHuanghe ||
        self.api_deviceBindingDeviceSource == HMServiceAPIDeviceSourceWatchEverest ||
        self.api_deviceBindingDeviceSource == HMServiceAPIDeviceSourceWatchEverest2S) {
        return self.hmjson[@"status"].boolean && self.hmjson[@"binding_status"].boolean;
    }
    
    return self.hmjson[@"binding_status"].boolean;
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

- (Byte)api_deviceBindingDeviceShushanBandCRC8 {
    return 0;
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
    return YES;
    //    return self.hmjson[@"activeStatus"].boolean;
}

- (NSString *)api_deviceBindingDeviceRemarks {
    return @"";
}


@end
