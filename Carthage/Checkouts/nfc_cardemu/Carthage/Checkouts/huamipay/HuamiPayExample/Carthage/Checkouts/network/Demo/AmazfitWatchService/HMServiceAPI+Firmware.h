//
//  HMServiceAPI+Firmware.h
//  HuamiWatch
//
//  Created by 李宪 on 28/7/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMServiceAPIFirmware <NSObject>

@property (readonly) NSString *api_firmwareTargetVersion;
@property (readonly) NSString *api_firmwareDeviceVersion;
@property (readonly) NSString *api_firmwareSensorVersion;
@property (readonly) NSString *api_firmwareFileURL;
@property (readonly) NSUInteger api_firmwareFileSize;
@property (readonly) NSString *api_firmwareFileMD5;
@property (readonly) NSString *api_firmwareChangeLog;
@property (readonly) NSUInteger api_firmwareUpgradeType;

@end


@protocol HMFirmwareServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)firmware_checkNewVersionWithUserID:(NSString *)userID
                                   currentFirmwareVersion:(NSString *)currentFirmwareVersion
                                            deviceVersion:(NSString *)deviceVersion
                                             serialNumber:(NSString *)serialNumber
                                          completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIFirmware>firmware))completionBlock;

@end


@interface HMServiceAPI (Firmware) <HMFirmwareServiceAPI>
@end
