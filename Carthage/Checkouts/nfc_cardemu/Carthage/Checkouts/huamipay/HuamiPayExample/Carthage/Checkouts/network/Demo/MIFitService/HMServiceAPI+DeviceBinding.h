//
//  HMServiceAPI+DeviceBinding.h
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

typedef NS_ENUM(NSInteger, HMServiceBindDeviceState) {
    HMServiceBindDeviceStateUnkown          = 0,    // 未知
    HMServiceBindDeviceStateBind            = 1,    // 可绑定(或绑定成功)
    HMServiceBindDeviceStateAlreayBinded    = -1,   // 当前用户已经绑定其他设备
    HMServiceBindDeviceStateBindedByOther   = -2,   // 被其他人绑定.
    HMServiceBindDeviceStateReBinding       = -3,   // 重复绑定同一个设备
};

@protocol HMServiceAPIDeviceBindingDevice <NSObject>

@property (readonly) NSDate *api_deviceBindingDeviceAppBoundTime;                // App绑定设备的时间
@property (readonly) NSTimeZone *api_deviceBindingDeviceTimeZone;                // 设备时区
@property (readonly) HMServiceAPIDeviceType api_deviceBindingDeviceType;         // 设备类型
@property (readonly) HMServiceAPIDeviceSource api_deviceBindingDeviceSource;     // 设备source
@property (readonly) NSString *api_deviceBindingDeviceID;                          // 设备ID
@property (readonly) NSString *api_deviceBindingDeviceMAC;                         // 设备MAC地址

@property (readonly) NSString *api_deviceBindingDeviceSN;                          // 跑鞋SN
@property (readonly) NSString *api_deviceBindingDeviceAuthKey;                     // 手环(手表)鉴权的Key
@property (readonly) NSString *api_deviceBindingDeviceShushanBandCRC8;           // 蜀山手环硬件user_id加密CRC8校验码

@property (readonly) NSString *api_deviceBindingDeviceFirmwareVersion;             // 固件版本号
@property (readonly) NSString *api_deviceBindingDeviceHeartRateFirmwareVersion;    // 心率固件版本号

@property (readonly) NSDate *api_deviceBindingDeviceLastSyncDataTime;            // 最后一次的同步数据时间
@property (readonly) NSDate *api_deviceBindingDeviceLastSyncHeartRateDataTime;   // 最后一次的同步心率数据时间
@property (readonly) NSDate *api_deviceBindingDeviceLastUpdateTime;              // 最后一次的状态变更时间
@property (readonly) BOOL api_deviceBindingDeviceActiveStatus;                   // 是否是已经激活状态
@property (readonly) NSString *api_deviceBindingDeviceRemarks;                     // 设备的备注名
@property (readonly) NSString *api_deviceBindingDeviceProductID;                   //
@property (readonly) NSInteger api_deviceBindingDeviceProductVersion;            // 同一个设备ID可能会有不同的version，从设备读取
@property (readonly) NSInteger api_deviceBindingDeviceBrandType;                 // 品牌类型
@property (readonly) BOOL api_deviceBindingDeviceIsBound;                        // 是否绑定

@end


@protocol HMServiceAPIDeviceBindingInfo <NSObject>

@property (readonly) NSString *api_deviceBindingDeviceOtherUserID;                      // 手环原来绑定的userID
@property (readonly) HMServiceBindDeviceState api_deviceBindingDeviceState;             // 绑定状态
@property (readonly) NSString *api_deviceBindingDeviceOtherNickName;                    // 是否绑定
@property (readonly) NSDate *api_deviceBindingDeviceOtherBingTime;                      // 绑定时间

@end

@protocol HMServiceDeviceBindingAPI <HMServiceAPI>

/**
 查询能否绑定设备
 @see  http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/device45binding45controller/postUsingPUT；
 */
- (id<HMCancelableAPI>)deviceBinding_queryBindableWithDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                             completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIDeviceBindingInfo> info))completionBlock;

/**
 绑定设备
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=46
 */
- (id<HMCancelableAPI>)deviceBinding_bindWithDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                    completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIDeviceBindingInfo> info))completionBlock;

/**
 解除绑定
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=45
 */
- (id<HMCancelableAPI>)deviceBinding_unbindDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 已绑定设备列表
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=57
 PS：API内部会过滤未绑定的设备历史记录，只返回当前状态为已绑定的设备
 */
- (id<HMCancelableAPI>)deviceBinding_boundDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock;

/**
 已绑定手表设备列表（黄河，珠峰）
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=57
 PS：API内部会过滤未绑定的设备历史记录，只返回当前状态为已绑定的设备
 */
- (id<HMCancelableAPI>)deviceBinding_boundWatchDevicesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDeviceBindingDevice>> *devices))completionBlock;


/**
 修改绑定设备信息
 @see http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/device45binding45controller/putUsingPUT_2
 PS：API内部会过滤未绑定的设备历史记录，只返回当前状态为已绑定的设备
 */
- (id<HMCancelableAPI>)deviceBinding_modifyWithDevice:(id<HMServiceAPIDeviceBindingDevice>)device
                                      completionBlock:(void (^)(BOOL success, NSString *message, HMServiceBindDeviceState state))completionBlock;
@end

@interface HMServiceAPI (DeviceBinding) <HMServiceDeviceBindingAPI>
@end
