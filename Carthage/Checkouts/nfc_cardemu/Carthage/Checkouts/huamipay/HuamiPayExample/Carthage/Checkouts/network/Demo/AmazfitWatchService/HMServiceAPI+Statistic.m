//
//  HMServiceAPI+Statistic.m
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+Statistic.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <HMCategory/HMCategoryKit.h>

@implementation HMServiceAPI (Statistic)

- (id<HMCancelableAPI>)statistic_recordBecameActiveWithDeviceID:(NSString *)deviceID
                                                watchRomVersion:(NSString *)watchRomVersion
                                                watchMACAddress:(NSString *)watchMACAddress
                                              watchSerialNumber:(NSString *)watchSerialNumber
                                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSParameterAssert(deviceID.length > 0);

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

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"users/%@/mobileAppActivities?activityType=LOGIN_TAG", userID]];

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

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        {
            // 根据GDPR要求取消此参数
//            parameters[@"mobileDeviceId"]   = deviceID;
            parameters[@"mobileDeviceId"]   = @"";

            //details
            NSMutableDictionary *details    = [NSMutableDictionary dictionary];
            details[@"v"]                   = @"3";

            // phone
            NSMutableDictionary *phoneInfo  = [NSMutableDictionary dictionary];

            phoneInfo[@"country"]           = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
            phoneInfo[@"language"]          = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
            phoneInfo[@"osversion"]         = [UIDevice currentDevice].systemVersion;
            phoneInfo[@"model"]             = [UIDevice deviceName];

            // 根据GDPR要求取消此参数
//            CTCarrier *carrier              = [CTTelephonyNetworkInfo new].subscriberCellularProvider;
//            phoneInfo[@"carrier"]           = carrier.carrierName;
            phoneInfo[@"carrier"]           = @"";

            details[@"phone"]               = phoneInfo;

            // app
            NSMutableDictionary *appInfo    = [NSMutableDictionary dictionary];
            appInfo[@"appversion"]          = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];

#if DEBUG
            appInfo[@"channel"]             = @"Debug";
#else
            appInfo[@"channel"]             = @"AppStore";
#endif

            details[@"app"]                 = appInfo;

            //watch
            NSMutableDictionary *watchInfo  = [NSMutableDictionary dictionary];
            watchInfo[@"romversion"]        = watchRomVersion;
            watchInfo[@"sn"]                = watchSerialNumber;
            watchInfo[@"macaddress"]        = watchMACAddress;

            details[@"watch"]               = watchInfo;

            // To JSON
            NSData *jsonData        = [NSJSONSerialization dataWithJSONObject:details options:0 error:NULL];
            NSString *jsonString    = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            parameters[@"details"]  = jsonString;
        }

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

                                    if (completionBlock) {
                                        completionBlock(success, message);
                                    }
                                }];
                   }];
    }];
}

@end
