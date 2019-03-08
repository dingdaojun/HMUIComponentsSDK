//
//  HMServiceAPI+Statistic.m
//  HMNetworkLayer
//
//  Created by 李宪 on 11/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Statistic.h"
#import <ADSupport/AdSupport.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMCategory/HMCategoryKit.h>


@implementation HMServiceAPI (Statistic)

- (id<HMCancelableAPI>)statistic_recordDeviceInfo:(id<HMServiceAPIStatisticDeviceInfo>)deviceInfo
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        id<HMServiceAPIStatisticDeviceProductInfo> productInfo  = deviceInfo.api_statisticDeviceProductInfo;
        HMServiceAPIDeviceType deviceType                       = productInfo.api_statisticDeviceProductDeviceType;
        HMServiceAPIDeviceSource deviceSource                   = productInfo.api_statisticDeviceProductDeviceSource;
        NSString *deviceID                                      = productInfo.api_statisticDeviceProductDeviceID;
        NSString *firmwareVersion                               = productInfo.api_statisticDeviceProductFirmwareVersion;
        NSString *hardwareVersion                               = productInfo.api_statisticDeviceProductHardwareVersion;
        HMServiceAPIDeviceTypeParameterAssert(deviceType);
        HMServiceAPIDeviceSourceParameterAssert(deviceSource);
        NSParameterAssert(deviceID.length > 0);
        NSParameterAssert(firmwareVersion.length > 0);
        NSParameterAssert(hardwareVersion.length > 0);
        
        
        NSString *systemInfoJSONString = ({
            id<HMServiceAPIStatisticDeviceSystemInfo> systemInfo    = deviceInfo.api_statisticDeviceSystemInfo;
            NSTimeInterval runningSeconds                           = systemInfo.api_statisticDeviceSystemInfoRunningSeconds;
            NSTimeInterval wakeUpSeconds                            = systemInfo.api_statisticDeviceSystemInfoWakeUpSeconds;
            NSTimeInterval algorithmRunningSeconds                  = systemInfo.api_statisticDeviceSystemInfoAlgorithmRunningSeconds;
            NSUInteger rebootCount                                  = systemInfo.api_statisticDeviceSystemInfoRebootCount;
            
            NSTimeInterval BLEConnectionSeconds                     = systemInfo.api_statisticDeviceSystemInfoBLEConnectionSeconds;
            NSUInteger BLEDisconnectCount                           = systemInfo.api_statisticDeviceSystemInfoBLEDisconnectCount;
            NSTimeInterval vibrateSeconds                           = systemInfo.api_statisticDeviceSystemInfoVibrateSeconds;
            NSTimeInterval LCDOnSeconds                             = systemInfo.api_statisticDeviceSystemInfoLCDOnSeconds;
            NSTimeInterval FlashReadWriteSeconds                    = systemInfo.api_statisticDeviceSystemInfoFlashReadWriteSeconds;
            NSTimeInterval PPGWorkingSeconds                        = systemInfo.api_statisticDeviceSystemInfoPPGWorkingSeconds;
            
            NSUInteger buttonPressedCount                           = systemInfo.api_statisticDeviceSystemInfoButtonPressedCount;
            NSUInteger liftWristCount                               = systemInfo.api_statisticDeviceSystemInfoLiftWristCount;
            NSUInteger appNotifyCount                               = systemInfo.api_statisticDeviceSystemInfoAppNotifyCount;
            NSUInteger incomingCallNotifyCount                      = systemInfo.api_statisticDeviceSystemInfoIncomingCallNotifyCount;
            NSDate *lastChargeTime                                  = systemInfo.api_statisticDeviceSystemInfoLastChargeTime;
            
            NSDictionary *dictionary = @{@"upTime"              : @(runningSeconds),
                                         @"rebootCount"         : @(rebootCount),
                                         @"disconnectCount"     : @(BLEDisconnectCount),
                                         @"keyCount"            : @(buttonPressedCount),
                                         @"liftWristCount"      : @(liftWristCount),
                                         @"ppgTime"             : @(PPGWorkingSeconds),
                                         @"vibrateTime"         : @(vibrateSeconds),
                                         @"lcdTime"             : @(LCDOnSeconds),
                                         @"flashTime"           : @(FlashReadWriteSeconds),
                                         @"connectionTime"      : @(BLEConnectionSeconds),
                                         @"appNotifyCount"      : @(appNotifyCount),
                                         @"phoneNotifyCount"    : @(incomingCallNotifyCount),
                                         @"resumeTime"          : @(wakeUpSeconds),
                                         @"algorithmTime"       : @(algorithmRunningSeconds),
                                         @"lastcharge"          : @((long long)lastChargeTime.timeIntervalSince1970)};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        });
        
        NSString *productInfoJSONString = ({
            HMServiceAPIProductVersion productVersion               = productInfo.api_statisticDeviceProductVersion;
            //        HMServiceAPIProductVersionParameterAssert(productVersion);
            
            NSString *productID                                     = productInfo.api_statisticDeviceProductID;
            NSString *serialNumber                                  = productInfo.api_statisticDeviceProductSerialNumber;
            
            NSString *firmwareVersion                               = productInfo.api_statisticDeviceProductFirmwareVersion;
            NSString *hardwareVersion                               = productInfo.api_statisticDeviceProductHardwareVersion;
            
            NSString *fontVersion                                   = productInfo.api_statisticDeviceProductFontVersion;
            HMServiceAPIStatisticDeviceProductInfoFontType fontType = productInfo.api_statisticDeviceProductFontType;
            NSParameterAssert(fontType == HMServiceAPIStatisticDeviceProductInfoFontTypeChinese ||
                              fontType == HMServiceAPIStatisticDeviceProductInfoFontTypeEnglish);
            
            NSInteger band1Feature                                  = productInfo.api_statisticDeviceProductBand1Feature;
            NSInteger band1Appearance                               = productInfo.api_statisticDeviceProductBand1Appearance;
            NSString *band1ProfileVersion                           = productInfo.api_statisticDeviceProductBand1ProfileVersion;
            NSString *band1SHeartRateFirmwareVersion                = productInfo.api_statisticDeviceProductBand1SHeartRateFirmwareVersion;
            
            NSString *resourceVersion                               = productInfo.api_statisticDeviceProductResourceVersion;
            NSString *vendorID                                      = productInfo.api_statisticDeviceProductVendorID;
            NSString *vendorSource                                  = productInfo.api_statisticDeviceProductVendorSource;
            
            NSDictionary *dictionary = @{@"deviceType"       : @(deviceType),
                                         @"deviceSource"     : @(deviceSource),
                                         @"feature"          : @(band1Feature),
                                         @"appearance"       : @(band1Appearance),
                                         @"fontVersion"      : fontVersion,
                                         @"fontType"         : @(fontType),
                                         @"resourceVersion"  : resourceVersion ?: @"",
                                         @"vendorId"         : vendorID ?: @"",
                                         @"vendorSource"     : vendorSource ?: @"",
                                         @"productId"        : productID ?: @"",
                                         @"productVersion"   :  @(productVersion),
                                         @"deviceID"         : deviceID,
                                         @"serialNumber"     : serialNumber ?: @"",
                                         @"profileVersion"   : band1ProfileVersion ?: @"",
                                         @"firmwareVersion"  : firmwareVersion ?: @"",
                                         @"firmware2Version" : band1SHeartRateFirmwareVersion ?: @"",
                                         @"hardwareVersion"  : hardwareVersion ?: @""};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        });
        
        NSString *batteryInfoJSONString = ({
            id<HMServiceAPIStatisticDeviceBatteryInfo>batteryInfo   = deviceInfo.api_statisticDeviceBatteryInfo;
            NSUInteger level                                        = batteryInfo.api_statisticDeviceBatteryLevel;
            NSUInteger lastChargeTimeLevel                          = batteryInfo.api_statisticDeviceBatteryLastChargeTimeLevel;
            NSDate *lastChargeTime                                  = batteryInfo.api_statisticDeviceBatteryLastChargeTime;
            NSDate *lastFullyChargedTime                            = batteryInfo.api_statisticDeviceBatteryLastFullyChargedTime;
            
            NSDictionary *dictionary = @{@"level"           : @(level),
                                         @"lastchargeLevel" : @(lastChargeTimeLevel),
                                         @"lastcharge"      : @((long long)lastChargeTime.timeIntervalSince1970),
                                         @"lastchargeFull"  : @((long long)lastFullyChargedTime.timeIntervalSince1970)};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        });
        
        NSString *temperatureInfoJSONDictionary = ({
            
            NSMutableArray *temperatureInfos = [NSMutableArray new];
            for (id<HMServiceAPIStatisticDeviceTemperatureInfo>temperatureInfo in deviceInfo.api_statisticDeviceTemperatureInfos) {
                NSDate *time    = temperatureInfo.api_statisticDeviceTemperatureTime;
                double degree   = temperatureInfo.api_statisticDeviceTemperatureDegreeInCentigrade;
                NSParameterAssert(time);
                
                NSDictionary *dictionary = @{@"timestamp"   : @((long long)time.timeIntervalSince1970),
                                             @"value"       : @(degree)};
                [temperatureInfos addObject:dictionary];
            }
            
            NSDictionary *dictionary = @{@"data" : temperatureInfos};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        });
        
        NSString *deviceInfoJSONString = ({
            NSDictionary *dictionary = @{@"statisticInfo"   : systemInfoJSONString,
                                         @"deviceInfo"      : productInfoJSONString,
                                         @"batteryInfo"     : batteryInfoJSONString,
                                         @"temperatureInfo" : temperatureInfoJSONDictionary};
            
            NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        });
        
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/device/stat.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid"              : userID,
                                             @"device_type"         : @(deviceType),
                                             @"device_source"       : @(deviceSource),
                                             @"deviceid"            : deviceID,
                                             @"fw_version"          : firmwareVersion,
                                             @"hardware_version"    : hardwareVersion,
                                             @"info_version"        : @1,
                                             @"info"                : deviceInfoJSONString} mutableCopy];
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
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self legacy_handleResultForAPI:_cmd
                                         responseError:error
                                              response:response
                                        responseObject:responseObject
                                       completionBlock:^(BOOL success, NSString *message, id data) {
                                           completionBlock(success, message);
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)statistic_recordBecameActiveWithDeviceID:(NSString *)deviceID
                                                   userSecurity:(NSString *)userSecurity
                                                        counrty:(NSString *)country
                                                       language:(NSString *)language
                                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(deviceID.length > 0);
        NSParameterAssert(userSecurity.length > 0);
        NSParameterAssert(country.length > 0);
        NSParameterAssert(language.length > 0);
        
        NSDictionary *detailDictionary = ({
            
            NSString *appVersion    = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            NSString *IDFA          = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
            NSString *iOSVersion    = [NSString stringWithFormat:@"ios%@", [UIDevice currentDevice].systemVersion];
            NSString *carrierName   = [CTCarrier new].carrierName;
            NSString *modelString   = [UIDevice deviceName];
            
            CGSize screenSize       = [UIScreen mainScreen].bounds.size;
            CGFloat scale           = [UIScreen mainScreen].scale;
            NSString *resolution    = [NSString stringWithFormat:@"%.0fX%.0f", screenSize.width * scale, screenSize.height * scale];
            
            HMNetworkReachabilityStatus reachabilityStatus = [HMNetworkReachability reachabilityStatus];
            NSString *networkTypeString = @"";
            if (reachabilityStatus == HMNetworkReachabilityStatusReachableViaWWAN) {
                networkTypeString = @"WWAN";
            }
            else if (reachabilityStatus == HMNetworkReachabilityStatusReachableViaWiFi) {
                networkTypeString = @"Wifi";
            }
            
            @{@"v"      : @2,
              @"id"     : @{@"miphone"     : @"",
                            @"sysphone"    : @"",
                            @"wcopenid"    : @"",
                            @"sysimei"     : deviceID,
                            @"idfa"        : IDFA ?: @""},
              @"phone"  : @{@"brand"       : @"Apple",
                            @"systemtype"  : @"",  // keep empty str
                            @"model"       : modelString,
                            @"osversion"   : iOSVersion,
                            @"country"     : country,
                            @"language"    : language,
                            @"carrier"     : carrierName ?: @"",
                            @"network"     : networkTypeString,
                            @"resolution"  : resolution},
              @"app"    : @{@"appversion"  : appVersion,
#if DEBUG
                            @"channel"     : @"Debug"}
#else
              @"channel"     : @"AppStore"}
#endif
        };
                                          });
        NSData *detailJSONData = [NSJSONSerialization dataWithJSONObject:detailDictionary options:0 error:NULL];
        NSString *detailJSONString = [[NSString alloc] initWithData:detailJSONData encoding:NSUTF8StringEncoding];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/device/active_history.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"device_type" : @"ios",
                                             @"userid" : userID,
                                             @"imei" : deviceID,
                                             @"security" : userSecurity,
                                             @"details" : detailJSONString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore multipartFormRequestWithMethod:HMNetworkHTTPMethodPOST
                                                         URL:URL
                                                  parameters:parameters
                                                     headers:headers
                                              constructBlock:nil
                                             completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                 
                                                 [self legacy_handleResultForAPI:_cmd
                                                                   responseError:error
                                                                        response:response
                                                                  responseObject:responseObject
                                                                 completionBlock:^(BOOL success, NSString *message, id data) {
                                                                     completionBlock(success, message);
                                                                 }];
                                             }];
    }];
}

@end
