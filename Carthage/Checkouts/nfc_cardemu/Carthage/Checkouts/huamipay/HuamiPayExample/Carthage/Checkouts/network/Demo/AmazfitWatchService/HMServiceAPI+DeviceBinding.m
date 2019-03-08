//
//  HMServiceAPI+DeviceBinding.m
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+DeviceBinding.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/UIDevice+Resolutions.h>

@implementation HMServiceAPI (DeviceBinding)

- (id<HMCancelableAPI>)deviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBindableDevice>> *devices))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID", nil);
                });
            }
            return nil;
        }


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

- (id<HMCancelableAPI>)deviceBinding_bindWithDeviceID:(NSString *)deviceID
                                         deviceSource:(HMServiceAPIDeviceSource)deviceSource
                                           romVersion:(NSString *)romVersion
                                           macAddress:(NSString *)macAddress
                                       romBuildNumber:(NSString *)romBuildNumber
                                      romSerialNumber:(NSString *)romSerialNumber
                                        romBuildModel:(NSString *)romBuildModel
                                            modelName:(NSString *)modelName
                                            isOversea:(BOOL)isOversea
                                          romDeviceID:(NSString *)romDeviceID
                                      completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSParameterAssert(deviceID.length > 0);
    NSParameterAssert(deviceSource == HMServiceAPIDeviceSourceWatchHuanghe ||
                      deviceSource == HMServiceAPIDeviceSourceWatchEverest ||
                      deviceSource == HMServiceAPIDeviceSourceWatchEverest2S);
    NSParameterAssert(romVersion.length > 0);
    NSParameterAssert(macAddress.length > 0);
    NSParameterAssert(romBuildNumber.length > 0);
    NSParameterAssert(romSerialNumber.length > 0);
    NSParameterAssert(romBuildModel.length > 0);
    NSParameterAssert(romDeviceID.length > 0);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }


        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/devices", userID]];

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

        NSMutableDictionary *parameters     = [NSMutableDictionary dictionary];

        parameters[@"applicationTime"]      = @((long long)[NSDate date].timeIntervalSince1970);
        parameters[@"bindingStatus"]        = @1;
        parameters[@"brand"]                = @"Apple";
        parameters[@"deviceId"]             = deviceID;
        parameters[@"deviceType"]           = @(HMServiceAPIDeviceTypeWatch);
        parameters[@"deviceSource"]         = @(deviceSource);

        parameters[@"firmwareVersion"]      = romVersion;
        parameters[@"macAddress"]           = macAddress;
        parameters[@"softwareVersion"]      = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        parameters[@"systemModel"]          = UIDevice.deviceName;
        parameters[@"systemVersion"]        = [UIDevice currentDevice].systemVersion;

        NSMutableDictionary *addtional      = [NSMutableDictionary dictionary];
        addtional[@"androidDeviceId"]       = romDeviceID;
        addtional[@"SN"]                    = romSerialNumber;
        addtional[@"buildNum"]              = romBuildNumber;
        addtional[@"buildModel"]            = romBuildModel;
        addtional[@"modelNum"]              = modelName.length > 0 ? modelName : @"";
        addtional[@"overseaEdition"]        = isOversea ? @1: @0;

        NSData *jsonData                    = [NSJSONSerialization dataWithJSONObject:addtional options:0 error:NULL];
        NSString *jsonString                = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        parameters[@"additionalInfo"]       = jsonString;

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
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

                                    if (error.code == 409) {
                                        completionBlock(YES, message);
                                        return;
                                    }

                                    completionBlock(success, message);
                                }];
                   }];
    }];
}

- (id<HMCancelableAPI>)deviceBinding_unbindWithDeviceID:(NSString *)deviceID
                                           deviceSource:(HMServiceAPIDeviceSource)deviceSource
                                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    NSParameterAssert(deviceID.length > 0);
    NSParameterAssert(deviceSource == HMServiceAPIDeviceSourceWatchHuanghe ||
                      deviceSource == HMServiceAPIDeviceSourceWatchEverest ||
                      deviceSource == HMServiceAPIDeviceSourceWatchEverest2S);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"Invalid user ID");
                });
            }
            return nil;
        }
        

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"/users/%@/devices/%@", userID, deviceID]];

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

        NSMutableDictionary *parameters     = [NSMutableDictionary dictionary];
        parameters[@"deviceType"]           = @(HMServiceAPIDeviceTypeWatch);
        parameters[@"deviceSource"]         = @(deviceSource);

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

                                      if (((NSHTTPURLResponse *)response).statusCode == 409) {
                                          completionBlock(YES, message);
                                          return;
                                      }

                                      completionBlock(success, message);
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

- (NSString *)api_bindableDeviceModel {
    return self.hmjson[@"additionalInfo"][@"buildModel"].string;
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

- (HMServiceAPIDeviceSource)api_bindableDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}

@end
