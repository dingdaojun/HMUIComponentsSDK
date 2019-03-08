//
//  NSDictionary+HMServiceAPIConfiguration.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "NSDictionary+HMServiceAPIConfiguration.h"
#import "NSDictionary+HMSJSON.h"

#import "HMServiceAPIConfigurationAgreement.h"
#import "NSDictionary+HMServiceAPIConfigurationReserveHeartRate.h"


@interface HMServiceJSONValue (WatchConfigurationStringComponents)
@property (readonly) NSArray<NSNumber *> *configuration_watchSportOrders;
@end

@implementation HMServiceJSONValue (WatchConfigurationStringComponents)

- (NSArray<NSNumber *> *)configuration_watchSportOrders {
    NSString *string = self.string;
    if (string.length == 0) {
        return nil;
    }
    
    NSArray *strings = [string componentsSeparatedByString:@","];
    
    NSMutableArray *numbers = [NSMutableArray new];
    for (NSString *string in strings) {
        if (string.integerValue == 0) {
            return nil;
        }
        
        [numbers addObject:@(string.integerValue)];
    }
    
    return numbers;
}

@end

@interface HMServiceAPIConfigurationSportDisplayItem : NSObject <HMServiceAPIConfigurationSportDisplayItem>
@property (assign, nonatomic) BOOL hidden;
@property (assign, nonatomic) HMServiceAPIConfigurationSportDisplayItemType type;
@end

@implementation HMServiceAPIConfigurationSportDisplayItem

+ (instancetype)displayItemWithType:(HMServiceAPIConfigurationSportDisplayItemType)type hidden:(BOOL)hidden {
    HMServiceAPIConfigurationSportDisplayItem *item = [self new];
    item.type = type;
    item.hidden = hidden;
    return item;
}

#pragma mark - HMServiceAPIConfigurationSportDisplayItem

- (HMServiceAPIConfigurationSportDisplayItemType)api_configurationSportDisplayItemType {
    return self.type;
}

- (BOOL)api_configurationSportDisplayItemHidden {
    return self.hidden;
}

@end


@interface HMServiceAPIConfigurationSportOrder : NSObject <HMServiceAPIConfigurationSportOrder>
@property (assign, nonatomic) HMServiceAPIConfigurationSportDisplayOrderType type;
@property (strong, nonatomic) NSOrderedSet <HMServiceAPIConfigurationSportDisplayItem *> *displayItems;
@end

@implementation HMServiceAPIConfigurationSportOrder

+ (instancetype)displayOrderWithType:(HMServiceAPIConfigurationSportDisplayOrderType)type
                        displayItems:(NSOrderedSet<HMServiceAPIConfigurationSportDisplayItem *> *)displayItems {
    HMServiceAPIConfigurationSportOrder *order = [self new];
    order.type = type;
    order.displayItems = displayItems;
    return order;
}

#pragma mark - HMServiceAPIConfigurationSportOrder

- (HMServiceAPIConfigurationSportDisplayOrderType)api_configurationSportDisplayOrderType {
    return self.type;
}

- (NSOrderedSet<id<HMServiceAPIConfigurationSportDisplayItem>> *)api_configurationSportDisplayOrderItems {
    return self.displayItems;
}

@end


@interface HMServiceJSONValue (HMServiceAPIConfigurationSportOrder)
@property (readonly) NSArray<id<HMServiceAPIConfigurationSportOrder>> *huangheSportDisplayOrders;
@property (readonly) NSArray<id<HMServiceAPIConfigurationSportOrder>> *everestSportDisplayOrders;
@end

@implementation HMServiceJSONValue (HMServiceAPIConfigurationSportOrder)

- (NSArray<id<HMServiceAPIConfigurationSportOrder>> *)huangheSportDisplayOrders {
    NSMutableArray *totalOrders = [NSMutableArray array];
    
    NSArray<NSString *> *displayKeys = @[@"running",
                                         @"walking",
                                         @"outdoorride",
                                         @"indoorrun",
                                         @"outdoorride",
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
                                        @"outdoorride.closed",
                                        @"indoorride.closed",
                                        @"elliptical.closed",
                                        @"climbmountains.closed",
                                        @"crosscounty.closed",
                                        @"skiing.closed",
                                        @"soccer.closed",
                                        @"tennis.closed",
                                        @"jumpRope.closed"];
    
    NSArray *sportTypes = @[@(HMServiceAPIConfigurationSportDisplayOrderRunning),
                            @(HMServiceAPIConfigurationSportDisplayOrderWalking),
                            @(HMServiceAPIConfigurationSportDisplayOrderOutdoorRiding),
                            @(HMServiceAPIConfigurationSportDisplayOrderIndoorRunning),
                            @(HMServiceAPIConfigurationSportDisplayOrderOutdoorRiding),
                            @(HMServiceAPIConfigurationSportDisplayOrderIndoorRiding),
                            @(HMServiceAPIConfigurationSportDisplayOrderEllipticalMachine),
                            @(HMServiceAPIConfigurationSportDisplayOrderClimbMountain),
                            @(HMServiceAPIConfigurationSportDisplayOrderCrossCountryRace),
                            @(HMServiceAPIConfigurationSportDisplayOrderSkiing),
                            @(HMServiceAPIConfigurationSportDisplayOrderSoccer),
                            @(HMServiceAPIConfigurationSportDisplayOrderTennis),
                            @(HMServiceAPIConfigurationSportDisplayOrderJumpRope)];
    
    for (NSInteger i = 0; i < displayKeys.count; i++) {
        NSMutableOrderedSet *displayItems = [NSMutableOrderedSet new];
        
        for (NSNumber *number in self[displayKeys[i]].configuration_watchSportOrders) {
            HMServiceAPIConfigurationSportDisplayItem *item = [HMServiceAPIConfigurationSportDisplayItem
                                                               displayItemWithType:number.unsignedIntegerValue
                                                               hidden:NO];
            [displayItems addObject:item];
        }
        
        for (NSNumber *number in self[hiddenKeys[i]].configuration_watchSportOrders) {
            HMServiceAPIConfigurationSportDisplayItem *item = [HMServiceAPIConfigurationSportDisplayItem
                                                               displayItemWithType:number.unsignedIntegerValue
                                                               hidden:YES];
            [displayItems addObject:item];
        }
        
        HMServiceAPIConfigurationSportDisplayOrderType sportType = [sportTypes[i] integerValue];
        
        HMServiceAPIConfigurationSportOrder *sportOrder = [HMServiceAPIConfigurationSportOrder displayOrderWithType:sportType displayItems:displayItems];
        [totalOrders addObject:sportOrder];
    }
    
    return totalOrders;
}

- (NSArray<id<HMServiceAPIConfigurationSportOrder>> *)everestSportDisplayOrders {
    NSMutableArray *totalOrders = [NSMutableArray array];
    
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
    
    NSArray *sportTypes = @[@(HMServiceAPIConfigurationSportDisplayOrderRunning),
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
    
    for (NSInteger i = 0; i < displayKeys.count; i++) {
        NSMutableOrderedSet *displayItems = [NSMutableOrderedSet new];
        
        for (NSNumber *number in self[displayKeys[i]].configuration_watchSportOrders) {
            HMServiceAPIConfigurationSportDisplayItem *item = [HMServiceAPIConfigurationSportDisplayItem
                                                               displayItemWithType:number.unsignedIntegerValue
                                                               hidden:NO];
            [displayItems addObject:item];
        }
        
        for (NSNumber *number in self[hiddenKeys[i]].configuration_watchSportOrders) {
            HMServiceAPIConfigurationSportDisplayItem *item = [HMServiceAPIConfigurationSportDisplayItem
                                                               displayItemWithType:number.unsignedIntegerValue
                                                               hidden:YES];
            [displayItems addObject:item];
        }
        
        HMServiceAPIConfigurationSportDisplayOrderType sportType = [sportTypes[i] integerValue];
        
        HMServiceAPIConfigurationSportOrder *sportOrder = [HMServiceAPIConfigurationSportOrder displayOrderWithType:sportType displayItems:displayItems];
        [totalOrders addObject:sportOrder];
    }
    
    return totalOrders;
}

@end



@implementation NSDictionary (HMServiceAPIConfiguration)

- (NSArray<id<HMServiceAPIConfigurationNotificationApplication>> *)api_configurationNotificationBlacklist {
    return self.hmjson[@"huami.watch.companion.phone.notification.blacklist.ios"][@"AppInBlackList"].array;
}

- (NSArray<id<HMServiceAPIConfigurationNotificationApplication>> *)api_configurationNotificationWhitelist {
    return self.hmjson[@"huami.watch.companion.phone.notification.whitelist.ios"][@"AppInWhiteList"].array;
}

- (BOOL)api_configurationNotificationOn {
    return self.hmjson[@"huami.watch.companion.phone.notification.useron"].boolean;
}

- (BOOL)api_configurationMusicControlOn {
    return self.hmjson[@"huami.watch.music_controller.enable"].boolean;
}

// 新的黄河排序
- (NSArray<id<HMServiceAPIConfigurationSportOrder>> *)api_configurationHuangheSportDisplayOrders {
    return self.hmjson[@"huami.watch.companion.phone.sport.order"].huangheSportDisplayOrders;
}

// 新的珠峰排序
- (NSArray<id<HMServiceAPIConfigurationSportOrder>> *)api_configurationEverestSportDisplayOrders {
    return self.hmjson[@"huami.watch.companion.phone.everest.sport.order"].everestSportDisplayOrders;
}

- (BOOL)api_configurationWeatherAlertOn {
    return self.hmjson[@"huami.watch.companion.phone.weather.alerton"].boolean;
}

- (BOOL)api_configurationWeatherNotificationOn {
    return self.hmjson[@"huami.watch.companion.phone.weather.notificationon"].boolean;
}

- (BOOL)api_configurationNotificationWechatGroupOn {
    return self.hmjson[@"huami.watch.companion.phone.notification.wechat_group"].boolean;
}

- (HMServiceAPIConfigurationWeatherTemperatureUnit)api_configurationWeatherTemperatureUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.weather.tempunit"];
    if (!value) {
        return HMServiceAPIConfigurationWeatherTemperatureUnitUnkonw;
    }
    else {
        return value.boolean ? HMServiceAPIConfigurationWeatherTemperatureUnitCelsius : HMServiceAPIConfigurationWeatherTemperatureUnitFahrenheit;
    }
}

- (NSString *)api_configurationWeatherCityName {
    return self.hmjson[@"huami.watch.companion.phone.weather.city"][@"cityName"].string;
}

- (NSString *)api_configurationWeatherCityLocationKey {
    return self.hmjson[@"huami.watch.companion.phone.weather.city"][@"locationKey"].string;
}

- (id<HMServiceAPIConfigurationWatchFace>)api_configurationHuangheWatchFace {
    NSDictionary *dictionary = self.hmjson[@"huami.watch.companion.phone.watchface.userset"][@"A1602"].dictionary;
    if (dictionary) {
        return (id<HMServiceAPIConfigurationWatchFace>)dictionary;
    }
    
    return (id<HMServiceAPIConfigurationWatchFace>)self.hmjson[@"huami.watch.companion.phone.watchface.userset"].dictionary;
}

- (id<HMServiceAPIConfigurationWatchFace>)api_configurationEverestWatchFace {
    NSDictionary *dictionary = self.hmjson[@"huami.watch.companion.phone.watchface.userset"][@"A1609"].dictionary;
    if (dictionary) {
        return (id<HMServiceAPIConfigurationWatchFace>)dictionary;
    }
    
    return (id<HMServiceAPIConfigurationWatchFace>)self.hmjson[@"huami.watch.companion.phone.watchface.userset"].dictionary;
}

- (NSString *)api_configurationOpaqueHealth {
    return self.hmjson[@"huami.watch.health.config"].string;
}

- (NSString *)api_configurationOpaqueSport {
    return self.hmjson[@"huami.watch.sport.config"].string;
}

- (NSString *)api_configurationOpaqueMedal {
    return self.hmjson[@"huami.watch.sport.medal"].string;
}

- (NSString *)api_configurationOpaqueWearSettings {
    return self.hmjson[@"huami.watch.wearsettings.config"].string;
}

- (NSString *)api_configurationMainDeviceID {
    return self.hmjson[@"huami.watch.companion.phone.device.main"].string;
}

- (HMServiceAPIConfigurationDistanceUnit)api_configurationDistanceUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.unit"][@"CN"][@"distance"];
    if (!value) {
        return HMServiceAPIConfigurationDistanceUnitUnknow;
    }
    else {
        return value.unsignedIntegerValue;
    }
}

- (HMServiceAPIConfigurationWeightUnit)api_configurationWeightUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.unit"][@"CN"][@"weight"];
    if (!value) {
        return HMServiceAPIConfigurationWeightUnitUnknow;
    }
    else {
        return value.unsignedIntegerValue;
    }
}

- (HMServiceAPIConfigurationHeightUnit)api_configurationHeightUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.unit"][@"CN"][@"height"];
    if (!value) {
        return HMServiceAPIConfigurationHeightUnitUnkonw;
    }
    else {
        return value.unsignedIntegerValue;
    }
}

- (HMServiceAPIConfigurationDistanceUnit)api_configurationUSDistanceUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.unit"][@"US"][@"distance"];
    if (!value) {
        return HMServiceAPIConfigurationDistanceUnitUnknow;
    }
    else {
        return value.unsignedIntegerValue;
    }
}

- (HMServiceAPIConfigurationWeightUnit)api_configurationUSWeightUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.unit"][@"US"][@"weight"];
    if (!value) {
        return HMServiceAPIConfigurationWeightUnitUnknow;
    }
    else {
        return value.unsignedIntegerValue;
    }
}

- (HMServiceAPIConfigurationHeightUnit)api_configurationUSHeightUnit {
    HMServiceJSONValue *value = self.hmjson[@"huami.watch.companion.phone.unit"][@"US"][@"height"];
    if (!value) {
        return HMServiceAPIConfigurationHeightUnitUnkonw;
    }
    else {
        return value.unsignedIntegerValue;
    }
}

- (NSArray<id<HMServiceAPIConfigurationIntervalRun>> *)api_configurationIntervalRun {
    return self.hmjson[@"huami.watch.sport.intervalrun"].array;
}

- (id<HMServiceAPIConfigurationReserveHeartRate>)api_configurationReserveHeartRate {
    return self.hmjson[@"huami.watch.sport.heartrate"].dictionary;
}

- (id<HMServiceAPIConfigurationAgreement>)api_configurationUsageAgreement {
    NSDictionary *value = self.hmjson[@"huami.watch.user.version.agreement"].dictionary;
    if (value.count == 0) {
        return nil;
    }
    
    HMServiceAPIConfigurationAgreement *agreement  = [HMServiceAPIConfigurationAgreement new];
    agreement.type                                  = HMServiceAPIConfigurationAgreementTypeUsage;
    agreement.countryCode                           = value.hmjson[@"country"].string;
    if (agreement.countryCode.length == 0) {
        return nil;
    }
    
    agreement.version                               = value.hmjson[@"version"].string;
    if (agreement.version.length == 0) {
        return nil;
    }
    
    agreement.granted                               = value.hmjson[@"isAgree"].boolean;
    return agreement;
}

- (id<HMServiceAPIConfigurationAgreement>)api_configurationPrivacyAgreement {
    NSDictionary *value = self.hmjson[@"huami.watch.user.version.privacy"].dictionary;
    if (value.count == 0) {
        return nil;
    }
    
    HMServiceAPIConfigurationAgreement *agreement  = [HMServiceAPIConfigurationAgreement new];
    agreement.type                                  = HMServiceAPIConfigurationAgreementTypePrivacy;
    agreement.countryCode                           = value.hmjson[@"country"].string;
    if (agreement.countryCode.length == 0) {
        return nil;
    }
    
    agreement.version                               = value.hmjson[@"version"].string;
    if (agreement.version.length == 0) {
        return nil;
    }
    
    agreement.granted                               = value.hmjson[@"isAgree"].boolean;
    return agreement;
}

- (id<HMServiceAPIConfigurationAgreement>)api_configurationImprovementAgreement {
    NSDictionary *value = self.hmjson[@"huami.watch.user.version.experience"].dictionary;
    if (value.count == 0) {
        return nil;
    }
    
    HMServiceAPIConfigurationAgreement *agreement  = [HMServiceAPIConfigurationAgreement new];
    agreement.type                                  = HMServiceAPIConfigurationAgreementTypeImprovement;
    agreement.countryCode                           = value.hmjson[@"country"].string;
    if (agreement.countryCode.length == 0) {
        return nil;
    }
    
    agreement.version                               = value.hmjson[@"version"].string;
    if (agreement.version.length == 0) {
        return nil;
    }
    
    agreement.granted                               = value.hmjson[@"isAgree"].boolean;
    return agreement;
}

@end
