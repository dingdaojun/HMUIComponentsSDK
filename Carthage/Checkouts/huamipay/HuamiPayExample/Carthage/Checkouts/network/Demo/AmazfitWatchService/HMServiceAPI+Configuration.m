//
//  HMServiceAPI+Configuration.m
//  HuamiWatch
//
//  Created by 李宪 on 1/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+Configuration.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

#import "NSDictionary+HMServiceAPIConfigurationWatchFace.h"
#import "NSDictionary+HMServiceAPIIntervalRun.h"
#import "NSDictionary+HMServiceAPIConfigurationReserveHeartRate.h"
#import "NSDictionary+HMServiceAPIConfigurationNotificationApplication.h"
#import "NSString+HMServiceAPIConfigurationNotificationApplication.h"
#import "NSDictionary+HMServiceAPIConfiguration.h"
#import "HMServiceAPIConfigurationAgreement.h"



@implementation NSArray (HMServiceConfigurationAPI)

- (NSString *)configuration_stringJoinedByComma {
    
    NSMutableArray *strings = [NSMutableArray new];
    for (NSNumber *value in self) {
        [strings addObject:[NSString stringWithFormat:@"%@", value]];
    }
    
    return [strings componentsJoinedByString:@","];
}

@end

@interface NSDictionary (HMServiceConfigurationAPI)
@property (readonly) NSString *configuration_json;
@end

@implementation NSDictionary (HMServiceConfigurationAPI)

- (NSString *)configuration_json {
    if (self.count == 0) {
        return nil;
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end





@implementation HMServiceAPI (Configuration)

- (id<HMCancelableAPI>)configuration_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfiguration>configuration))completionBlock {
    
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
        
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userId" : userID,
                                             @"propertyName" : @"huami.watch",
                                             @"mode" : @"RANGE"} mutableCopy];
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
                      
                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                   if (!completionBlock) {
                                       return;
                                   }
                                   
                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }
                                   
                                   BOOL isNewUser = data.hmjson[@"huami.watch.companion.phone.account.newuser"].boolean;
                                   if (isNewUser) {
                                       completionBlock(YES, message, nil);
                                       return;
                                   }
                                   
                                   completionBlock(YES, message, (id<HMServiceAPIConfiguration>)data);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)configuration_update:(id<HMServiceAPIConfiguration>)configuration
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
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
                                                referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *properties = [NSMutableDictionary new];
        
        properties[@"huami.watch.companion.phone.account.newuser"] = @"false";
        properties[@"huami.watch.music_controller.enable"] = configuration.api_configurationMusicControlOn ? @(YES) : @(NO);
        // 通知
        {
            properties[@"huami.watch.companion.phone.notification.useron"] = configuration.api_configurationNotificationOn ? @(YES) : @(NO);
            properties[@"huami.watch.companion.phone.notification.wechat_group"] = configuration.api_configurationNotificationWechatGroupOn ? @(YES) : @(NO);
            
            NSMutableArray *blacklist = [NSMutableArray new];
            for (id<HMServiceAPIConfigurationNotificationApplication>application in configuration.api_configurationNotificationBlacklist) {
                NSParameterAssert(application.api_notificaitonApplicationBundleID.length > 0);
                NSParameterAssert(application.api_notificaitonApplicationTitle.length > 0);
                
                [blacklist addObject:[NSString stringWithFormat:@"%@|%@", application.api_notificaitonApplicationBundleID, application.api_notificaitonApplicationTitle]];
            }
            NSDictionary *blacklistDictionary = @{@"AppInBlackList" : blacklist};
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:blacklistDictionary options:0 error:NULL];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            properties[@"huami.watch.companion.phone.notification.blacklist.ios"] = jsonString;
            
            
            NSMutableArray *whitelist = [NSMutableArray new];
            for (id<HMServiceAPIConfigurationNotificationApplication>application in configuration.api_configurationNotificationWhitelist) {
                NSParameterAssert(application.api_notificaitonApplicationBundleID.length > 0);
                
                [whitelist addObject:application.api_notificaitonApplicationBundleID];
            }
            
            NSDictionary *whitelistDictionary = @{@"AppInWhiteList" : whitelist};
            
            jsonData = [NSJSONSerialization dataWithJSONObject:whitelistDictionary options:0 error:NULL];
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            properties[@"huami.watch.companion.phone.notification.whitelist.ios"] = jsonString;
        }
        
        // 黄河运动显示项
        {
            NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
            
            NSArray<NSString *> *displayKeys = @[@"running",
                                                 @"walking",
                                                 @"outdoorride",
                                                 @"indoorrun",
                                                 @"indoorride",
                                                 @"elliptical",
                                                 @"climbmountains",
                                                 @"crosscounty",
                                                 @"skiing",
                                                 @"soccer",
                                                 @"tennis",
                                                 @"jumpRope"];

            NSArray<NSString *> *hiddenKeys = @[@"running.closed",
                                                @"walking.closed",
                                                @"outdoorride.closed",
                                                @"indoorrun.closed",
                                                @"indoorride.closed",
                                                @"elliptical.closed",
                                                @"climbmountains.closed",
                                                @"crosscounty.closed",
                                                @"skiing.closed",
                                                @"soccer.closed",
                                                @"tennis.closed",
                                                @"jumpRope.closed"];

            NSArray<NSNumber *> *sportTypes = @[@(HMServiceAPIConfigurationSportDisplayOrderRunning),
                                                @(HMServiceAPIConfigurationSportDisplayOrderWalking),
                                                @(HMServiceAPIConfigurationSportDisplayOrderOutdoorRiding),
                                                @(HMServiceAPIConfigurationSportDisplayOrderIndoorRunning),
                                                @(HMServiceAPIConfigurationSportDisplayOrderOutdoorRiding),
                                                @(HMServiceAPIConfigurationSportDisplayOrderIndoorRiding),
                                                @(HMServiceAPIConfigurationSportDisplayOrderEllipticalMachine),
                                                @(HMServiceAPIConfigurationSportDisplayOrderClimbMountain),
                                                @(HMServiceAPIConfigurationSportDisplayOrderSkiing),
                                                @(HMServiceAPIConfigurationSportDisplayOrderSoccer),
                                                @(HMServiceAPIConfigurationSportDisplayOrderTennis),
                                                @(HMServiceAPIConfigurationSportDisplayOrderJumpRope)];
            
            NSArray<id<HMServiceAPIConfigurationSportOrder>> *everestDisplayOrders = configuration.api_configurationHuangheSportDisplayOrders;
            
            for (NSInteger i = 0; i < sportTypes.count; i++) {
                HMServiceAPIConfigurationSportDisplayOrderType type = [sportTypes[i] integerValue];
                [everestDisplayOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportOrder>obj, NSUInteger idx, BOOL *stop) {
                    if (obj.api_configurationSportDisplayOrderType == type) {
                        NSOrderedSet *configurationSportOrders = obj.api_configurationSportDisplayOrderItems;
                        NSMutableArray *displaySportItemsArray = [NSMutableArray array];
                        [configurationSportOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportDisplayItem> obj, NSUInteger idx, BOOL *stop) {
                            if (!obj.api_configurationSportDisplayItemHidden) {
                                [displaySportItemsArray addObject:@(obj.api_configurationSportDisplayItemType)];
                            }
                        }];
                        
                        jsonDic[displayKeys[i]] = displaySportItemsArray.configuration_stringJoinedByComma;
                        *stop = YES;
                    }
                }];
            }
            
            for (NSInteger i = 0; i < sportTypes.count; i++) {
                HMServiceAPIConfigurationSportDisplayOrderType type = [sportTypes[i] integerValue];
                [everestDisplayOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportOrder> obj, NSUInteger idx, BOOL *stop) {
                    if (obj.api_configurationSportDisplayOrderType == type) {
                        NSOrderedSet *configurationSportOrders = obj.api_configurationSportDisplayOrderItems;
                        NSMutableArray *hiddenSportItemsArray = [NSMutableArray array];
                        [configurationSportOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportDisplayItem> obj, NSUInteger idx, BOOL *stop) {
                            if (obj.api_configurationSportDisplayItemHidden) {
                                [hiddenSportItemsArray addObject:@(obj.api_configurationSportDisplayItemType)];
                            }
                        }];
                        
                        jsonDic[hiddenKeys[i]] = hiddenSportItemsArray.configuration_stringJoinedByComma;
                        *stop = YES;
                    }
                }];
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:NULL];
            NSString *sportDisplayItems = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            properties[@"huami.watch.companion.phone.sport.order"] = sportDisplayItems;
        }
        
        // 珠峰运动显示项
        {
            NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
            
            NSArray<NSString *> *displayKeys = @[@"running",
                                                 @"walking",
                                                 @"crosscounty",
                                                 @"indoorrun",
                                                 @"outdoorride",
                                                 @"indoorride",
                                                 @"climbmountains",
                                                 @"indoorswim",
                                                 @"openwaterswim",
                                                 @"elliptical",
                                                 @"skiing",
                                                 @"soccer",
                                                 @"tennis",
                                                 @"jumpRope"];
            
            NSArray<NSString *> *hiddenKeys = @[@"running.closed",
                                               @"walking.closed",
                                               @"crosscounty.closed",
                                               @"indoorrun.closed",
                                               @"outdoorride.closed",
                                               @"indoorride.closed",
                                               @"climbmountains.closed",
                                               @"indoorswim.closed",
                                               @"openwaterswim.closed",
                                               @"elliptical.closed",
                                               @"skiing.closed",
                                               @"soccer.closed",
                                               @"tennis.closed",
                                               @"jumpRope.closed"];
            
            NSArray<NSNumber *> *sportTypes = @[@(HMServiceAPIConfigurationSportDisplayOrderRunning),
                                                @(HMServiceAPIConfigurationSportDisplayOrderWalking),
                                                @(HMServiceAPIConfigurationSportDisplayOrderCrossCountryRace),
                                                @(HMServiceAPIConfigurationSportDisplayOrderIndoorRunning),
                                                @(HMServiceAPIConfigurationSportDisplayOrderOutdoorRiding),
                                                @(HMServiceAPIConfigurationSportDisplayOrderIndoorRiding),
                                                @(HMServiceAPIConfigurationSportDisplayOrderClimbMountain),
                                                @(HMServiceAPIConfigurationSportDisplayOrderIndoorSwimming),
                                                @(HMServiceAPIConfigurationSportDisplayOrderOpenwaterSwimming),
                                                @(HMServiceAPIConfigurationSportDisplayOrderEllipticalMachine),
                                                @(HMServiceAPIConfigurationSportDisplayOrderSkiing),
                                                @(HMServiceAPIConfigurationSportDisplayOrderSoccer),
                                                @(HMServiceAPIConfigurationSportDisplayOrderTennis),
                                                @(HMServiceAPIConfigurationSportDisplayOrderJumpRope)];
            
            NSArray<id<HMServiceAPIConfigurationSportOrder>> *everestDisplayOrders = configuration.api_configurationEverestSportDisplayOrders;
            
            for (NSInteger i = 0; i < sportTypes.count; i++) {
                HMServiceAPIConfigurationSportDisplayOrderType type = [sportTypes[i] integerValue];
                [everestDisplayOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportOrder>obj, NSUInteger idx, BOOL *stop) {
                    if (obj.api_configurationSportDisplayOrderType == type) {
                        NSOrderedSet *configurationSportOrders = obj.api_configurationSportDisplayOrderItems;
                        NSMutableArray *displaySportItemsArray = [NSMutableArray array];
                        [configurationSportOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportDisplayItem>obj, NSUInteger idx, BOOL *stop) {
                            if (!obj.api_configurationSportDisplayItemHidden) {
                                [displaySportItemsArray addObject:@(obj.api_configurationSportDisplayItemType)];
                            }
                        }];
                        
                        jsonDic[displayKeys[i]] = displaySportItemsArray.configuration_stringJoinedByComma;
                        *stop = YES;
                    }
                }];
            }
            
            for (NSInteger i = 0; i < sportTypes.count; i++) {
                HMServiceAPIConfigurationSportDisplayOrderType type = [sportTypes[i] integerValue];
                [everestDisplayOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportOrder>obj, NSUInteger idx, BOOL *stop) {
                    if (obj.api_configurationSportDisplayOrderType == type) {
                        NSOrderedSet *configurationSportOrders = obj.api_configurationSportDisplayOrderItems;
                        NSMutableArray *hiddenSportItemsArray = [NSMutableArray array];
                        [configurationSportOrders enumerateObjectsUsingBlock:^(id<HMServiceAPIConfigurationSportDisplayItem> obj, NSUInteger idx, BOOL *stop) {
                            if (obj.api_configurationSportDisplayItemHidden) {
                                [hiddenSportItemsArray addObject:@(obj.api_configurationSportDisplayItemType)];
                            }
                        }];
                        
                        jsonDic[hiddenKeys[i]] = hiddenSportItemsArray.configuration_stringJoinedByComma;
                        *stop = YES;
                    }
                }];
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:NULL];
            NSString *sportDisplayItems = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            properties[@"huami.watch.companion.phone.everest.sport.order"] = sportDisplayItems;
        }
        
        // 天气
        {
            properties[@"huami.watch.companion.phone.weather.alerton"] = configuration.api_configurationWeatherAlertOn ? @"true" : @"false";
            properties[@"huami.watch.companion.phone.weather.notificationon"] = configuration.api_configurationWeatherNotificationOn ? @"true" : @"false";
            
            switch (configuration.api_configurationWeatherTemperatureUnit) {
                case HMServiceAPIConfigurationWeatherTemperatureUnitUnkonw:
                case HMServiceAPIConfigurationWeatherTemperatureUnitCelsius:
                    properties[@"huami.watch.companion.phone.weather.tempunit"] = @"true";
                    break;
                case HMServiceAPIConfigurationWeatherTemperatureUnitFahrenheit:
                    properties[@"huami.watch.companion.phone.weather.tempunit"] = @"false";
                    break;
            }
            
            NSDictionary *dictionary = @{@"cityName" : configuration.api_configurationWeatherCityName ?: @"",
                                         @"locationKey" : configuration.api_configurationWeatherCityLocationKey ?: @""};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            properties[@"huami.watch.companion.phone.weather.city"] = jsonString;
        }
        
        // 表盘
        {
            id<HMServiceAPIConfigurationWatchFace>huangHeWatchFace = configuration.api_configurationHuangheWatchFace;
            id<HMServiceAPIConfigurationWatchFace>everestWatchFace = configuration.api_configurationEverestWatchFace;
            
            NSDictionary *dictionary = @{@"A1602" : @{@"pkgName" : huangHeWatchFace.api_watchFacePackageName ?: @"",
                                                      @"serviceName" : huangHeWatchFace.api_watchFaceServiceName ?: @""},
                                         @"A1609" : @{@"pkgName" : everestWatchFace.api_watchFacePackageName ?: @"",
                                                      @"serviceName" : everestWatchFace.api_watchFaceServiceName ?: @""}};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            properties[@"huami.watch.companion.phone.watchface.userset"] = jsonString;
        }
        
        // 透传
        {
            properties[@"huami.watch.health.config"]        = configuration.api_configurationOpaqueHealth;
            properties[@"huami.watch.sport.config"]         = configuration.api_configurationOpaqueSport;
            properties[@"huami.watch.sport.medal"]          = configuration.api_configurationOpaqueMedal;
            properties[@"huami.watch.wearsettings.config"]  = configuration.api_configurationOpaqueWearSettings;
        }
        
        // 主设备ID
        {
            properties[@"huami.watch.companion.phone.device.main"] = configuration.api_configurationMainDeviceID;
        }
        
        // 单位
        {
            NSDictionary *unit = @{@"CN" : @{@"distance" : @(configuration.api_configurationDistanceUnit),
                                             @"weight" : @(configuration.api_configurationWeightUnit),
                                             @"height" : @(configuration.api_configurationHeightUnit)},
                                   @"US" : @{@"distance" : @(configuration.api_configurationUSDistanceUnit),
                                             @"weight" : @(configuration.api_configurationUSWeightUnit),
                                             @"height" : @(configuration.api_configurationUSHeightUnit)}};
            properties[@"huami.watch.companion.phone.unit"] = unit;
        }
        
        // 储备心率
        {
            if ([configuration respondsToSelector:@selector(api_configurationReserveHeartRate)]) {
                
                id<HMServiceAPIConfigurationReserveHeartRate>configurationReserveHeartRate = configuration.api_configurationReserveHeartRate;
                if (configurationReserveHeartRate) {
                    NSDictionary *reserveHeartRate = @{
                                                       @"heartRateType"     : @(configurationReserveHeartRate.api_configurationReserveHeartRateType),
                                                       @"restingHeartRate"  : @(configurationReserveHeartRate.api_configurationReserveHeartRateRestingHeartRate),
                                                       @"section"           : configurationReserveHeartRate.api_configurationReserveHeartRateSection,
                                                       @"percent"           : configurationReserveHeartRate.api_configurationReserveHeartRatePercent
                                                       };
                    
                    properties[@"huami.watch.sport.heartrate"] = reserveHeartRate;
                }
            }
        }
        
        // 间歇跑
        {
            NSMutableArray *intervalRunArray = [NSMutableArray new];
            for (id <HMServiceAPIConfigurationIntervalRun>intervalRun in configuration.api_configurationIntervalRun) {
                
                NSMutableDictionary *intervalRunDic = [NSMutableDictionary new];
                intervalRunDic[@"id"] = @(intervalRun.api_configurationIntervalRunID);
                intervalRunDic[@"title"] = intervalRun.api_configurationIntervalRunTitle;
                //                switch (intervalRun.api_configurationIntervalRunDeviceType) {
                //                    case HMServiceAPIConfigurationIntervalRunDeviceTypeHuanghe:
                //                        intervalRunDic[@"modelName"] = @"huanghe";
                //                        break;
                //                    case HMServiceAPIConfigurationIntervalRunDeviceTypeEverest:
                //                        intervalRunDic[@"modelName"] = @"everest";
                //                        break;
                //                }
                
                NSMutableArray *groups = [NSMutableArray new];
                
                for (id <HMServiceAPIConfigurationIntervalRunGroup> runGroup in intervalRun.api_configurationIntervalRunGroupList) {
                    NSMutableDictionary *runGroupDic = [NSMutableDictionary new];
                    runGroupDic[@"groupId"] = @(runGroup.api_configurationIntervalRunGroupID);
                    runGroupDic[@"repeatCount"] = @(runGroup.api_configurationIntervalRunRepeatCount);
                    NSMutableArray *items = [NSMutableArray new];
                    for (id <HMServiceAPIConfigurationIntervalRunItem> runItem in runGroup.api_configurationIntervalRunItems) {
                        NSMutableDictionary *runItemDic = [NSMutableDictionary new];
                        runItemDic[@"id"] = @(runItem.api_configurationIntervalRunItemID);
                        runItemDic[@"lengthType"] = @(runItem.api_configurationIntervalRunLengthType);
                        runItemDic[@"lengthValue"] = @(runItem.api_configurationIntervalRunLengthValue);
                        runItemDic[@"reminderType"] = @(runItem.api_configurationIntervalRunReminderType);
                        runItemDic[@"reminderValue"] = runItem.api_configurationIntervalRunReminderValue;
                        [items addObject:runItemDic];
                    }
                    
                    runGroupDic[@"itemInfoList"] = items;
                    [groups addObject:runGroupDic];
                }
                
                intervalRunDic[@"groupList"] = groups;
                [intervalRunArray addObject:intervalRunDic];
            }
            properties[@"huami.watch.sport.intervalrun"] = intervalRunArray;
        }

        // 用户协议
        {
            id<HMServiceAPIConfigurationAgreement> agreement = nil;

            // 使用协议
            agreement = configuration.api_configurationUsageAgreement;
            if (agreement) {
                NSMutableDictionary *dictionary                     = [NSMutableDictionary new];
                dictionary[@"country"]                              = agreement.api_configurationAgreementCountryCode;
                dictionary[@"version"]                              = agreement.api_configurationAgreementVersion;
                dictionary[@"isAgree"]                              = @(agreement.api_configurationAgreementGranted);
                properties[@"huami.watch.user.version.agreement"]   = dictionary.configuration_json;
            }

            // 隐私协议
            agreement = configuration.api_configurationPrivacyAgreement;
            if (agreement) {
                NSMutableDictionary *dictionary                     = [NSMutableDictionary new];
                dictionary[@"country"]                              = agreement.api_configurationAgreementCountryCode;
                dictionary[@"version"]                              = agreement.api_configurationAgreementVersion;
                dictionary[@"isAgree"]                              = @(agreement.api_configurationAgreementGranted);
                properties[@"huami.watch.user.version.privacy"]     = dictionary.configuration_json;
            }

            // 改善计划
            agreement = configuration.api_configurationImprovementAgreement;
            if (agreement) {
                NSMutableDictionary *dictionary                     = [NSMutableDictionary new];
                dictionary[@"country"]                              = agreement.api_configurationAgreementCountryCode;
                dictionary[@"version"]                              = agreement.api_configurationAgreementVersion;
                dictionary[@"isAgree"]                              = @(agreement.api_configurationAgreementGranted);
                properties[@"huami.watch.user.version.experience"]  = dictionary.configuration_json;
            }
        }
        
        NSMutableDictionary *parameters = [@{@"properties" : properties} mutableCopy];
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
                                    
                                    if (!success) {
                                        completionBlock(NO, message);
                                        return;
                                    }
                                    
                                    completionBlock(YES, message);
                                }];
                   }];
    }];
}

- (id<HMCancelableAPI>)configuration_retrieveIntelligentBlacklistWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIConfigurationNotificationApplication>> *blacklist))completionBlock {
    
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
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"apps/%@/settings", [NSBundle mainBundle].bundleIdentifier]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"settingName" : @"huami.watch.system.notification.blacklist.ios",
                                             @"mode" : @"SINGLE"} mutableCopy];
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
                      
                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                   if (!completionBlock) {
                                       return;
                                   }
                                   
                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }
                                   
                                   NSArray *blacklist = data.hmjson[@"huami.watch.system.notification.blacklist.ios"].array;
                                   completionBlock(YES, message, blacklist);
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)configuration_retrieveUserAgreementWithType:(HMServiceAPIConfigurationAgreementType)type
                                                       countryCode:(NSString *)countryCode
                                                   completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIConfigurationAgreement>agreement))completionBlock {
    NSParameterAssert(type == HMServiceAPIConfigurationAgreementTypeUsage ||
                      type == HMServiceAPIConfigurationAgreementTypePrivacy ||
                      type == HMServiceAPIConfigurationAgreementTypeImprovement);
    NSParameterAssert(countryCode.length == 2);

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:@"apps/pageVersions"];

        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [NSMutableDictionary new];

        switch (type) {
            case HMServiceAPIConfigurationAgreementTypeUsage:
                parameters[@"redirectType"] = @"agreement";
                break;
            case HMServiceAPIConfigurationAgreementTypePrivacy:
                parameters[@"redirectType"] = @"privacy";
                break;
            case HMServiceAPIConfigurationAgreementTypeImprovement:
                parameters[@"redirectType"] = @"experience";
                break;
        }

        parameters[@"lang"]             = countryCode;
        [parameters addEntriesFromDictionary:[self.delegate uniformHeaderFieldValuesForService:self auth:NO error:&error]];
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

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   if (!completionBlock) {
                                       return;
                                   }

                                   if (!success) {
                                       completionBlock(NO, message, nil);
                                       return;
                                   }

                                   NSArray *items = data.hmjson[@"items"].array;
                                   HMServiceAPIConfigurationAgreement *agreement = nil;

                                   for (NSDictionary *item in items) {
                                       if (![item.hmjson[@"language"].string isEqualToString:countryCode]) {
                                           continue;
                                       }

                                       NSString *version = item.hmjson[@"version"].string;
                                       if (version.length == 0) {
                                           continue;
                                       }

                                       agreement                = [HMServiceAPIConfigurationAgreement new];
                                       agreement.type           = type;
                                       agreement.countryCode    = countryCode;
                                       agreement.version        = version;
                                       break;
                                   }

                                   completionBlock(YES, message, agreement);
                               }];
                  }];
    }];
}

@end
