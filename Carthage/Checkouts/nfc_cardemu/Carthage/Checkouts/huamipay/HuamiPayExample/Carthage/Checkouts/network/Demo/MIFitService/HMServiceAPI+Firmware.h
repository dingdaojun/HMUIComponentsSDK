//
//  HMServiceAPI+Firmware.h
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

//"firmware_version":"1.0",
//"file_url":"http://www.baidu.com",
//"md5_content ":"NKJSHDASNAAS",
//"app_version":"1.0",
//"change_log":"测试固件升级相关功能",
//"device_type":0,
//"source":0,
//"productVersion":258,

@protocol HMServiceAPIFirmware <NSObject>

@property (nonatomic, copy, readonly) NSString *api_firmwareVersion;
@property (nonatomic, copy, readonly) NSString *api_firmwareFileURL;
@property (nonatomic, copy, readonly) NSString *api_firmwareMD5;
@property (nonatomic, copy, readonly) NSString *api_firmwareAppVersion;
@property (nonatomic, copy, readonly) NSString *api_firmwareChangeLog;
@property (nonatomic, assign, readonly) HMServiceAPIDeviceType api_firmwareDeviceType;
@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_firmwareDeviceSource;
@property (nonatomic, assign, readonly) HMServiceAPIProductVersion api_firmwareProductVersion;

@end

@protocol HMServiceFirmwareAPI <HMServiceAPI>

/**
 获取固件列表
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=53
 */
- (id<HMCancelableAPI>)firmware_listWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIFirmware>> *firmwares))completionBlock;

@end

@interface HMServiceAPI (Firmware) <HMServiceFirmwareAPI>
@end
