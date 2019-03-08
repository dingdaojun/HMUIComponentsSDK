//
//  HMServiceAPI+DeviceBinding.h
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMServiceAPIBindableDevice <NSObject>

@property (readonly) NSString *api_bindableDeviceID;                        // 设备ID
@property (readonly) NSString *api_bindableDeviceModel;                     // 型号，如A1601
@property (readonly) NSString *api_bindableDeviceMACAddress;                // MAC 地址
@property (readonly) NSString *api_bindableDeviceModelName;                 // 型号名，如Amazfit Sports Watch 2
@property (readonly) BOOL api_bindableDeviceBoundWithIOSDevice;             // 是否和iOS设备绑定
@property (readonly) BOOL api_bindableDeviceBound;                          // 是否已绑定

@property (readonly) HMServiceAPIDeviceSource api_bindableDeviceSource;     // Source

@end


@protocol HMDeviceBindingServiceAPI <NSObject>

- (id<HMCancelableAPI>)deviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBindableDevice>> *devices))completionBlock;

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
                                      completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

- (id<HMCancelableAPI>)deviceBinding_unbindWithDeviceID:(NSString *)deviceID
                                           deviceSource:(HMServiceAPIDeviceSource)deviceSource
                                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end


@interface HMServiceAPI (DeviceBinding) <HMDeviceBindingServiceAPI>
@end
