//
//  HMServiceAPI+Discovery.m
//  HMNetworkLayer
//
//  Created by 李宪 on 17/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Discovery.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
@import HMCategory;

static NSString * const kTypeEntrance       = @"MIFIT_ENTRANCE";
static NSString * const kTypeActivity       = @"MIFIT_ACTIVITY";
static NSString * const kTypeAdsBanner      = @"MIFIT_ADS_BANNER";
static NSString * const kTypeIcon           = @"MIFIT_ICON";
static NSString * const kTypeRunInfo        = @"MIFIT_RUN_INFO";

#define HMServiceAPIDiscoveryModuleParameterAssert(x)       NSParameterAssert(module >= HMServiceAPIModuleEntrance &&   \
                                                                              module <= HMServiceAPIModuleMyDevice)    \


static NSString *stringWithDiscoveryModule(HMServiceAPIDiscoveryModule module) {
    switch (module) {
        case HMServiceAPIModuleEntrance: return @"MIFIT_ENTRANCE";
        case HMServiceAPIModuleAdsBanner: return @"MIFIT_ADS_BANNER";
        case HMServiceAPIModuleIcon: return @"MIFIT_ICON";
        case HMServiceAPIModuleActivity: return @"MIFIT_ACTIVITY";
        case HMServiceAPIModuleRunInfo: return @"MIFIT_RUN_INFO";
        case HMServiceAPIModuleTrainingCenter: return @"MIFIT_TRAINNING_CENTER";
        case HMServiceAPIModuleMedal: return @"MIFIT_MEDAL";
        case HMServiceAPIModuleDataReport: return @"MIFIT_DATA_REPORT";
        case HMServiceAPIModuleHealthService: return @"MIFIT_HEALTH_SERVICE";
        case HMServiceAPIModuleSportEvent: return @"MIFIT_SPORT_EVENT";
        case HMServiceAPIModuleShoppingMall: return @"MIFIT_SHOPPING_MALL";
        case HMServiceAPIModuleEnterpriseService: return @"MIFIT_ENTERPRISE_SERVICE";
        case HMServiceAPIModuleMoreLink: return @"MIFIT_MORE_LINK";
        case HMServiceAPIModuleDiscoveryHome: return @"MIFIT_DISCOVERY_HOME";
        case HMServiceAPIModuleRunCircle: return @"MIFIT_RUN_CIRCLE";
        case HMServiceAPIModuleChaohuSkin: return @"CHAOHU_WATCH_SKIN";
        case HMServiceAPIModuleMessageCenter: return @"MIFIT_MESSAGE_CENTER";
        case HMServiceAPIModuleTempoWatchSkin: return @"TEMPO_WATCH_SKIN";
        case HMServiceAPIModuleMyTab: return @"MIFIT_MY_TAB";
        case HMServiceAPIModuleMyDevice: return @"MIFIT_MY_DEVICE";
    }
}

static HMServiceAPIDiscoveryModule discoveryModuleWithString(NSString *string) {
    NSDictionary *map = @{@"MIFIT_ENTRANCE" : @(HMServiceAPIModuleEntrance),
                          @"MIFIT_ADS_BANNER" : @(HMServiceAPIModuleAdsBanner),
                          @"MIFIT_ICON" : @(HMServiceAPIModuleIcon),
                          @"MIFIT_ACTIVITY" : @(HMServiceAPIModuleActivity),
                          @"MIFIT_RUN_INFO" : @(HMServiceAPIModuleRunInfo),
                          @"MIFIT_TRAINNING_CENTER" : @(HMServiceAPIModuleTrainingCenter),
                          @"MIFIT_MEDAL" : @(HMServiceAPIModuleMedal),
                          @"MIFIT_DATA_REPORT" : @(HMServiceAPIModuleDataReport),
                          @"MIFIT_HEALTH_SERVICE" : @(HMServiceAPIModuleHealthService),
                          @"MIFIT_SPORT_EVENT" : @(HMServiceAPIModuleSportEvent),
                          @"MIFIT_SHOPPING_MALL" : @(HMServiceAPIModuleShoppingMall),
                          @"MIFIT_ENTERPRISE_SERVICE" : @(HMServiceAPIModuleEnterpriseService),
                          @"MIFIT_MORE_LINK" : @(HMServiceAPIModuleMoreLink),
                          @"MIFIT_DISCOVERY_HOME" : @(HMServiceAPIModuleDiscoveryHome),
                          @"MIFIT_RUN_CIRCLE" : @(HMServiceAPIModuleRunCircle),
                          @"CHAOHU_WATCH_SKIN" : @(HMServiceAPIModuleChaohuSkin),
                          @"MIFIT_MESSAGE_CENTER" : @(HMServiceAPIModuleMessageCenter),
                          @"TEMPO_WATCH_SKIN" : @(HMServiceAPIModuleTempoWatchSkin),
                          @"MIFIT_MY_TAB" : @(HMServiceAPIModuleMyTab),
                          @"MIFIT_MY_DEVICE" : @(HMServiceAPIModuleMyDevice)};
    return [map[string] integerValue];
}


static NSString *stringWithAdvertisementType(HMServiceAPIAdvertisementType type) {
    switch (type) {
        case HMServiceAPIAdvertisementTypeSleep: return @"sleep_ad";
        case HMServiceAPIAdvertisementTypeBodyFat: return @"body_fat";
    }
    return @"";
}

@implementation HMServiceAPI (Discovery)


- (id<HMCancelableAPI>)discovery_dismissDots:(NSArray<id<HMServiceAPIDiscoveryDotDismissData>> *)disMissDots
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDiscoveryDotData>> *dots))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"apps/com.xiaomi.hm.health/discoveryUpdates"];
        
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
        
        NSMutableArray *parameters = [NSMutableArray new];
        
        for (id<HMServiceAPIDiscoveryDotDismissData>dot in disMissDots) {
            NSDate *dismissTime = dot.api_discoveryDotDismissTime;
            HMServiceAPIDiscoveryModule module = dot.api_discoveryDotModule;
            HMServiceAPIDiscoveryModuleParameterAssert(module);
            NSString *moduleString = stringWithDiscoveryModule(module);
            
            [parameters addObject:@{@"dotDismissTime" : [NSNumber numberWithLongLong:dismissTime.timeIntervalSince1970],
                                    @"type" : moduleString}];
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
                              desiredDataFormat:HMServiceResultDataFormatArray
                                completionBlock:^(BOOL success, NSString *message, id data) {
                                    if (completionBlock) {
                                        completionBlock(success, message, data);
                                    }
                                }];
                   }];
    }];
}


- (id<HMCancelableAPI>)discovery_sleepAdvertisementWithAdcode:(NSString *)adcode
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDiscoverySleepAdvertisementData>> *datas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"discovery/mi/discovery/sleep_ad"];

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

        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];

        if (adcode.length > 0) {
            [parameters setObject:adcode forKey:@"adcode"];
        }

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
                             desiredDataFormat:HMServiceResultDataFormatArray
                               completionBlock:^(BOOL success, NSString *message, id data) {
                                   if (completionBlock) {
                                       completionBlock(success, message, data);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)discovery_advertisementWithAdcode:(NSString *)adcode
                                                    type:(HMServiceAPIAdvertisementType)type
                                         completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIAdvertisementData>> *datas))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"discovery/mi/discovery/%@", stringWithAdvertisementType(type)];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

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

        NSMutableDictionary *parameters = [@{@"userid" : userID} mutableCopy];

        if (adcode.length > 0) {
            [parameters setObject:adcode forKey:@"adcode"];
        }

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
                             desiredDataFormat:HMServiceResultDataFormatArray
                               completionBlock:^(BOOL success, NSString *message, id data) {
                                   if (completionBlock) {
                                       completionBlock(success, message, data);
                                   }
                               }];
                  }];
    }];
}



@end

#pragma mark - Decode response data
@interface NSDictionary (HMServiceAPIDiscoveryDotData) <HMServiceAPIDiscoveryDotData>
@end

@implementation NSDictionary (HMServiceAPIDiscoveryDotData)

- (BOOL)api_discoveryDotDataUpdate {
    return self.hmjson[@"isUpdate"].boolean;
}

- (NSInteger)api_discoveryDotDataMessageCount {
    return self.hmjson[@"messageCount"].integerValue;
}

- (HMServiceAPIDiscoveryModule)api_discoveryDotDataModule {
    return discoveryModuleWithString(self.hmjson[@"type"].string);
}

@end



@interface NSDictionary (HMServiceAPIDiscoverySleepAdvertisementData) <HMServiceAPIDiscoverySleepAdvertisementData>
@end

@implementation NSDictionary (HMServiceAPIDiscoverySleepAdvertisementData)

- (NSString *)api_discoverySleepAdvertisementLogoImageUrl {
    return [self sleepAdvertisementImageUrlWithType:@"fg_logo"];
}

- (NSString *)api_discoverySleepAdvertisementTopImageUrl {
    return [self sleepAdvertisementImageUrlWithType:@"bg_top"];
}

- (NSString *)api_discoverySleepAdvertisementBGImageUrl {
    return [self sleepAdvertisementImageUrlWithType:@"bg_body"];
}

- (NSString *)api_discoverySleepAdvertisementBannerImageUrl {
    return [self sleepAdvertisementImageUrlWithType:@"fg_banner"];
}

- (NSString *)api_discoverySleepAdvertisementWebviewUrl {
    return self.hmjson[@"target"].string;
}

- (NSString *)api_discoverySleepAdvertisementLogoWebviewUrl {
    NSDictionary *assets = [self sleepAdvertisementAssets];
    return assets.hmjson[@"text"].string;
}

- (NSString *)api_discoverySleepAdvertisementTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_discoverySleepAdvertisementSubTitle {
    return self.hmjson[@"sub_title"].string;
}

- (NSString *)api_discoverySleepAdvertisementID {
    return self.hmjson[@"id"].string;
}

- (NSDate *)api_discoverySleepAdvertisementEndTime {
    NSDictionary *extensions = self.hmjson[@"extensions"].dictionary;
    return extensions.hmjson[@"endtime"].date;
}

- (UIColor *)api_discoverySleepAdvertisementHomeColor {
    return [self api_discoverySleepAdvertisementColorWithType:@"home"];
}

- (UIColor *)api_discoverySleepAdvertisementThemeColor {
    return [self api_discoverySleepAdvertisementColorWithType:@"theme"];
}

- (UIColor *)api_discoverySleepAdvertisementBGColor {
    return [self api_discoverySleepAdvertisementColorWithType:@"bg"];
}

- (UIColor *)api_discoverySleepAdvertisementColorWithType:(NSString *)type {
    NSArray *colors = [self sleepAdvertisementColors];

    for (NSDictionary *color in colors) {
        NSString *colorType = color.hmjson[@"position"].string;
        if ([colorType isEqualToString:type]) {
            NSString *string = color.hmjson[@"value"].string;
            return [UIColor colorWithHEXString:string];
        }
    }

    return nil;
}

- (NSString *)sleepAdvertisementImageUrlWithType:(NSString *)type {

    NSArray *images = [self sleepAdvertisementImages];
    for (NSDictionary *image in images) {
        NSString *imageType = image.hmjson[@"position"].string;
        if ([imageType isEqualToString:type]) {
            return image.hmjson[@"src"].string;
        }
    }
    return nil;
}

- (NSDictionary *)sleepAdvertisementAssets {

    NSDictionary *extensions = self.hmjson[@"extensions"].dictionary;
    return extensions.hmjson[@"assets"].dictionary;
}

- (NSArray *)sleepAdvertisementImages {

    NSDictionary *assets = [self sleepAdvertisementAssets];
    return assets.hmjson[@"images"].array;
}

- (NSArray *)sleepAdvertisementColors {

    NSDictionary *assets = [self sleepAdvertisementAssets];
    return assets.hmjson[@"colors"].array;
}

@end


@interface NSDictionary (HMServiceAPIAdvertisementImageData) <HMServiceAPIAdvertisementImageData>
@end

@implementation NSDictionary (HMServiceAPIAdvertisementImageData)

- (NSString *)api_advertisementImageUrl {
    return self.hmjson[@"src"].string;
}

- (NSString *)api_advertisementImagePosition {
    return self.hmjson[@"position"].string;
}

@end

@interface NSDictionary (HMServiceAPIAdvertisementColorData) <HMServiceAPIAdvertisementColorData>
@end

@implementation NSDictionary (HMServiceAPIAdvertisementColorData)

- (NSString *)api_advertisementColor {
    return self.hmjson[@"value"].string;;
}

- (NSString *)api_advertisementColorPosition {
    return self.hmjson[@"position"].string;
}

@end


@interface NSDictionary (HMServiceAPIAdvertisementData) <HMServiceAPIAdvertisementData>
@end

@implementation NSDictionary (HMServiceAPIAdvertisementData)

- (NSString *)api_advertisementWebviewUrl {
    return self.hmjson[@"target"].string;
}

- (NSString *)api_advertisementLogoWebviewUrl {
    NSDictionary *assets = [self sleepAdvertisementAssets];
    return assets.hmjson[@"text"].string;
}

- (NSString *)api_advertisementTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_advertisementSubTitle {
    return self.hmjson[@"sub_title"].string;
}

- (NSString *)api_advertisementID {
    return self.hmjson[@"id"].string;
}

- (NSDate *)api_advertisementEndTime {
    NSDictionary *extensions = self.hmjson[@"extensions"].dictionary;
    return extensions.hmjson[@"endtime"].date;
}

- (NSArray<id<HMServiceAPIAdvertisementImageData>> *)api_advertisementImages {

    NSDictionary *assets = [self advertisementAssets];
    return assets.hmjson[@"images"].array;
}

- (NSArray<id<HMServiceAPIAdvertisementColorData>> *)api_advertisementColors {
    NSDictionary *assets = [self advertisementAssets];
    return assets.hmjson[@"colors"].array;
}

- (NSDictionary *)advertisementAssets {

    NSDictionary *extensions = self.hmjson[@"extensions"].dictionary;
    return extensions.hmjson[@"assets"].dictionary;
}

- (NSString *)api_advertisementImage {
    return self.hmjson[@"image"].string;
}


@end



