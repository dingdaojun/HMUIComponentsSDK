//
//  HMServiceAPI+DeviceBinding.h
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMServiceAPIBindableDevice <NSObject>

@property (nonatomic, copy, readonly) NSString *api_bindableDeviceID;                       // 设备ID
@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_bindableDeviceSource;  // Source
@property (nonatomic, copy, readonly) NSString *api_bindableDeviceMACAddress;               // MAC 地址
@property (nonatomic, copy, readonly) NSString *api_bindableDeviceModelName;                // 型号名，如Amazfit Sports Watch 2
@property (nonatomic, assign, readonly) BOOL api_bindableDeviceBoundWithIOSDevice;          // 是否和iOS设备绑定
@property (nonatomic, assign, readonly) BOOL api_bindableDeviceBound;                       // 是否已绑定

@end

@protocol HMServiceAPIDeviceBindingDevice <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_deviceBindingDeviceAppBoundTime;                // App绑定设备的时间
@property (nonatomic, strong, readonly) NSTimeZone *api_deviceBindingDeviceTimeZone;                // 设备时区
@property (nonatomic, assign, readonly) HMServiceAPIDeviceType api_deviceBindingDeviceType;         // 设备类型
@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_deviceBindingDeviceSource;     // 设备source
@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceID;                          // 设备ID
@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceMAC;                         // 设备MAC地址

@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceSN;                          // 跑鞋SN
@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceAuthKey;                     // Pro手环鉴权的Key
@property (nonatomic, assign, readonly) Byte api_deviceBindingDeviceShushanBandCRC8;                // 蜀山手环硬件user_id加密CRC8校验码

@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceFirmwareVersion;             // 固件版本号
@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceHeartRateFirmwareVersion;    // 心率固件版本号

@property (nonatomic, strong, readonly) NSDate *api_deviceBindingDeviceLastSyncDataTime;            // 最后一次的同步数据时间
@property (nonatomic, strong, readonly) NSDate *api_deviceBindingDeviceLastSyncHeartRateDataTime;   // 最后一次的同步心率数据时间
@property (nonatomic, strong, readonly) NSDate *api_deviceBindingDeviceLastUpdateTime;              // 最后一次的状态变更时间
@property (nonatomic, assign, readonly) BOOL api_deviceBindingDeviceActiveStatus;                   // 是否是已经激活状态
@property (nonatomic, copy, readonly) NSString *api_deviceBindingDeviceRemarks;                     // 设备的备注名

@end


@protocol HMDeviceBindingServiceAPI <NSObject>

- (id<HMCancelableAPI>)deviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIBindableDevice>> *devices))completionBlock;

@end

@protocol HMServiceDeviceBindingAPI <HMServiceAPI>

/**
 已绑定设备列表
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=57
 PS：API内部会过滤未绑定的设备历史记录，只返回当前状态为已绑定的设备
 */
- (id<HMCancelableAPI>)miFitdeviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock;

@end

@interface HMServiceAPI (DeviceBinding) <HMDeviceBindingServiceAPI, HMServiceDeviceBindingAPI>
@end
