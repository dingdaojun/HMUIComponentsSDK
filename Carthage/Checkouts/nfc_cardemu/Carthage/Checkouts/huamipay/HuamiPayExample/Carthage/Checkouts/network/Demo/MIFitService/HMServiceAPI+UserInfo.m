//
//  HMServiceAPI+UserInfo.m
//  HMNetworkLayer
//
//  Created by 李宪 on 13/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+UserInfo.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (UserInfo)

- (id<HMCancelableAPI>)userInfo_dataWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIUserInfoData>userInfo))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.getUserInfo.json"];
        
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
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:completionBlock];
                  }];
    }];
}

- (id<HMCancelableAPI>)userInfo_updateUserInfoData:(id<HMServiceAPIUserInfoData>)data
                                            avatar:(id)inAvatar
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSString *avatarURL))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *nickname                          = data.api_userInfoDataNickname;
        HMServiceAPIUserInfoDataGender gender       = data.api_userInfoDataGender;
        double height                               = data.api_userInfoDataHeight;
        double weight                               = data.api_userInfoDataWeight;
        NSDate *birthday                            = data.api_userInfoDataBirthday;
        NSString *configString                      = data.api_userInfoDataConfigString;
        NSArray *alarmClockConfigs                  = data.api_userInfoDataAlarmClockConfigs;
        
        NSParameterAssert(nickname.length > 0 ||
                          (gender == HMServiceAPIUserInfoDataGenderMale || gender == HMServiceAPIUserInfoDataGenderFemale) ||
                          height > 0 ||
                          weight > 0 ||
                          birthday ||
                          configString.length > 0 ||
                          alarmClockConfigs.count > 0 ||
                          inAvatar);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.bindProfile.json"];
        
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
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        if (nickname.length > 0) {
            parameters[@"nick_name"] = nickname;
        }
        if (gender == HMServiceAPIUserInfoDataGenderMale) {
            parameters[@"gender"] = @1;
        }
        if (gender == HMServiceAPIUserInfoDataGenderFemale) {
            parameters[@"gender"] = @0;
        }
        if (height > 0) {
            parameters[@"height"] = @(height);
        }
        if (weight > 0) {
            parameters[@"weight"] = @(weight);
        }
        if (birthday) {
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"yyyy-MM";
            parameters[@"birthday"] = [formatter stringFromDate:birthday];
        }
        if (configString.length > 0) {
            parameters[@"config"] = configString;
        }
        if (alarmClockConfigs.count > 0) {
            NSMutableArray *dictionaries = [NSMutableArray new];
            for (id<HMServiceAPIUserInfoAlarmClockConfig>alarmClockConfig in alarmClockConfigs) {
                BOOL visible                                                = alarmClockConfig.api_userInfoAlarmClockConfigVisible;
                BOOL enabled                                                = alarmClockConfig.api_userInfoAlarmClockConfigEnabled;
                NSUInteger index                                            = alarmClockConfig.api_userInfoAlarmClockConfigIndex;
                NSDate *time                                                = alarmClockConfig.api_userInfoAlarmClockConfigTime;
                BOOL lazySleepEnabled                                       = alarmClockConfig.api_userInfoAlarmClockConfigLazySleepEnabled;
                NSTimeInterval smartWakeUpDuration                          = alarmClockConfig.api_userInfoAlarmClockConfigSmartWakeUpDuration;
                HMServiceAPIUserInfoAlarmConfigRepeatOptions repeatOptions  = alarmClockConfig.api_userInfoAlarmClockConfigRepeatOptions;
                BOOL intelligenceWakeUp  = alarmClockConfig.api_userInfoAlarmClockConfigIntelligenceWakeUpEnabled;

                NSDateComponents *dateComponenets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:time];
                NSDictionary *calendarDictionary = @{@"year" : @(dateComponenets.year),
                                                     @"month" : @(dateComponenets.month - 1),
                                                     @"dayOfMonth" : @(dateComponenets.day),
                                                     @"hourOfDay" : @(dateComponenets.hour),
                                                     @"minute" : @(dateComponenets.minute),
                                                     @"second" : @(dateComponenets.second)};
                
                [dictionaries addObject:@{@"calendar" : calendarDictionary,
                                          @"enabled" : @(enabled),
                                          @"index" : @(index),
                                          @"isUpdate" : @1,
                                          @"lazySleepEnable" : @(lazySleepEnabled),
                                          @"mDays" : @(repeatOptions),
                                          @"mSmartWakeupDuration" : @(smartWakeUpDuration),
                                          @"visible" : @(visible),
                                          @"isSmart" : @(intelligenceWakeUp)}];
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaries options:0 error:NULL];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *urlEncodedJSONString = [jsonString hms_stringByEncodingPercentEscape];
            
            parameters[@"alarm_clock"] = urlEncodedJSONString;
        }
        
        // Avatar
        
        id avatar = inAvatar;
        if ([avatar isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)avatar;
            if (string.length > 0) {
                avatar = [NSURL fileURLWithPath:string];
                NSParameterAssert([avatar isFileURL]);
            }
        }
        else if ([avatar isKindOfClass:[UIImage class]]) {
            avatar = UIImageJPEGRepresentation(avatar, 0.5);
            NSParameterAssert(((NSData *)avatar).length > 0);
        }
        
        return [HMNetworkCore multipartFormRequestWithMethod:HMNetworkHTTPMethodPOST
                                                         URL:URL
                                                  parameters:parameters
                                                     headers:headers
                                              constructBlock:^(id<HMMultipartFormData> formData) {
                                                  
                                                  if ([avatar isKindOfClass:[NSURL class]]) {
                                                      [formData appendPartWithFileURL:avatar
                                                                                 name:@"icon"
                                                                             fileName:@"icon.jpg"
                                                                             mimeType:@"image/jpeg"
                                                                                error:NULL];
                                                  }
                                                  else if ([avatar isKindOfClass:[NSData class]]) {
                                                      [formData appendPartWithFileData:avatar
                                                                                  name:@"icon"
                                                                              fileName:@"icon.jpg"
                                                                              mimeType:@"image/jpeg"];
                                                  }
                                              }
                                             completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                 
                                                 [self legacy_handleResultForAPI:_cmd
                                                                   responseError:error
                                                                        response:response
                                                                  responseObject:responseObject
                                                                 completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                                                     
                                                                     NSString *avatarURL = nil;
                                                                     if (success) {
                                                                         avatarURL = data.hmjson[@"avatar"].string;
                                                                     }
                                                                     
                                                                     completionBlock(success, message, avatarURL);
                                                                 }];
                                             }];
    }];
}

@end


@interface NSDictionary (HMServiceAPIUserInfoAlarmClockConfig) <HMServiceAPIUserInfoAlarmClockConfig>
@end

@implementation NSDictionary (HMServiceAPIUserInfoAlarmClockConfig)

- (BOOL)api_userInfoAlarmClockConfigVisible {
    return self.hmjson[@"visible"].boolean;
}

- (BOOL)api_userInfoAlarmClockConfigEnabled {
    return self.hmjson[@"enabled"].boolean;
}

- (NSUInteger)api_userInfoAlarmClockConfigIndex {
    return self.hmjson[@"index"].unsignedIntegerValue;
}

- (NSDate *)api_userInfoAlarmClockConfigTime {
    
    HMServiceJSONValue *JSON = self.hmjson[@"calendar"].dictionary.hmjson;
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.year     = JSON[@"year"].integerValue;
    dateComponents.month    = JSON[@"month"].integerValue + 1;
    dateComponents.day      = JSON[@"dayOfMonth"].integerValue;
    dateComponents.hour     = JSON[@"hourOfDay"].integerValue;
    dateComponents.minute   = JSON[@"minute"].integerValue;
    dateComponents.second   = JSON[@"second"].integerValue;
    
    return [NSCalendar.autoupdatingCurrentCalendar dateFromComponents:dateComponents];
}

- (HMServiceAPIUserInfoAlarmConfigRepeatOptions)api_userInfoAlarmClockConfigRepeatOptions {
    return self.hmjson[@"mDays"].unsignedIntegerValue;
}

- (NSTimeInterval)api_userInfoAlarmClockConfigSmartWakeUpDuration {
    return self.hmjson[@"mSmartWakeupDuration"].doubleValue;
}

- (BOOL)api_userInfoAlarmClockConfigLazySleepEnabled {
    return self.hmjson[@"lazySleepEnable"].boolean;
}

- (BOOL)api_userInfoAlarmClockConfigIntelligenceWakeUpEnabled {
    return self.hmjson[@"isSmart"].boolean;
}

@end


@interface NSDictionary (HMServiceAPIUserInfoData) <HMServiceAPIUserInfoData>
@end

@implementation NSDictionary (HMServiceAPIUserInfoData)

- (NSString *)api_userInfoDataNickname {
    return self.hmjson[@"nick_name"].string;
}

- (NSString *)api_userInfoDataAvatarURL {
    return self.hmjson[@"avatar"].string;
}

- (NSDate *)api_userInfoDataBirthday {
    return [self.hmjson[@"birthday"] dateWithFormat:@"yyyy-MM"];
}

- (HMServiceAPIUserInfoDataGender)api_userInfoDataGender {
    NSUInteger gender = self.hmjson[@"gender"].unsignedIntegerValue;
    return gender == 0 ? HMServiceAPIUserInfoDataGenderFemale : HMServiceAPIUserInfoDataGenderMale;
}

- (double)api_userInfoDataHeight {
    return self.hmjson[@"height"].doubleValue;
}

- (double )api_userInfoDataWeight {
    double weight = self.hmjson[@"weight_float"].doubleValue;
    if (weight > 0) {
        return weight;
    }
    
    return self.hmjson[@"weight"].doubleValue;
}

- (NSString *)api_userInfoDataConfigString {
    return self.hmjson[@"config"].string;
}

- (NSArray<id<HMServiceAPIUserInfoAlarmClockConfig>> *)api_userInfoDataAlarmClockConfigs {
    NSString *jsonString = [self.hmjson[@"alarm_clock"].string hms_stringByDecodingPercentEscape];
    if (jsonString.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSArray *configs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    }
    
    if (![configs isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return configs;
}

@end
