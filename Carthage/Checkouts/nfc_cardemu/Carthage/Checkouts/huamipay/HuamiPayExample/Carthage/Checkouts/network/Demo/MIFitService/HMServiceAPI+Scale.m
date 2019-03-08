//
//  HMServiceAPI+Scale.m
//  HMNetworkLayer
//
//  Created by 李宪 on 17/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Scale.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Scale)

- (id<HMCancelableAPI>)scale_uploadData:(NSArray<id<HMServiceAPIScaleData>> *)dataItems
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSMutableArray *itemDictionaries = [NSMutableArray arrayWithCapacity:dataItems.count];
        
        for (id<HMServiceAPIScaleData>item in dataItems) {
            
            NSString *userID                        = item.api_scaleDataUserID;
            NSString *familyMemberID                = item.api_scaleDataFamilyMemberID;
            NSDate *time                            = item.api_scaleDataTime;
            NSString *deviceID                      = item.api_scaleDataDeviceID;
            HMServiceAPIDeviceSource deviceSource   = item.api_scaleDataDeviceSource;
            HMServiceScaleUsageMode mode            = item.api_scaleDataUsageMode;
            double weight                           = item.api_scaleDataWeight;
            double height                           = item.api_scaleDataHeight;
            double bodyFatRate                      = item.api_scaleDataBodyFatRate;
            double bodyMuscleRate                   = item.api_scaleDataBodyMuscleRate;
            double boneWeight                       = item.api_scaleDataBoneWeight;
            double metabolism                       = item.api_scaleDataMetabolism;
            double visceralFat                      = item.api_scaleDataVisceralFat;
            double bodyWaterRate                    = item.api_scaleDataBodyWaterRate;
            NSUInteger impedance                    = item.api_scaleDataImpedance;
            double BMI                              = item.api_scaleDataBMI;
            double bodyScore                        = item.api_scaleDataBodyScore;
            HMServiceScaleBodyStyleType bodyStyle   = item.api_scaleDataBodyStyle;
            
            
            NSParameterAssert(userID.length > 0);
            NSParameterAssert(time);
            NSParameterAssert(mode == HMServiceScaleUsageNormally ||
                              mode == HMServiceScaleUsageHodingInfant ||
                              mode == HMServiceScaleUsageManully);
            NSParameterAssert(bodyStyle >= HMServiceScaleBodyStyleNoStyle &&
                              bodyStyle <= HMServiceScaleBodyStyleBodybuildingMuscle);
            NSParameterAssert(deviceSource == HMServiceAPIDeviceSourceScale1 ||
                              deviceSource == HMServiceAPIDeviceSourceBodyFatScale);
            NSParameterAssert(weight > 0);
            
            NSMutableDictionary *itemDictionary = [@{@"uid" : userID,
                                                     @"dt" : @1,
                                                     @"fuid" : familyMemberID.length > 0 ? familyMemberID : @"-1",
                                                     @"ts" : @(time.timeIntervalSince1970),
                                                     @"src" : @(deviceSource),
                                                     @"wdt" : @(mode),
                                                     @"bt" : @(bodyStyle)} mutableCopy];
            if (weight > 0) {
                itemDictionary[@"wt"] = @(weight);
            }
            if (height > 0) {
                NSParameterAssert(height >= 30 && height <= 242);
                itemDictionary[@"ht"] = @(height);
            }
            if (bodyFatRate > 0) {
                itemDictionary[@"fr"] = @(bodyFatRate);
            }
            if (bodyMuscleRate > 0) {
                itemDictionary[@"mr"] = @(bodyMuscleRate);
            }
            if (boneWeight > 0) {
                itemDictionary[@"bw"] = @(boneWeight);
            }
            if (metabolism > 0) {
                itemDictionary[@"ml"] = @(metabolism);
            }
            if (visceralFat > 0) {
                itemDictionary[@"vf"] = @(visceralFat);
            }
            if (bodyWaterRate > 0) {
                itemDictionary[@"bwr"] = @(bodyWaterRate);
            }
            if (deviceID.length > 0) {
                itemDictionary[@"did"] = deviceID;
            }
            if (impedance > 0) {
                itemDictionary[@"im"] = @(impedance);
            }
            if (BMI > 0) {
                itemDictionary[@"bmi"] = @(BMI);
            }
            if (bodyScore) {
                itemDictionary[@"bs"] = @(bodyScore);
            }
            
            [itemDictionaries addObject:itemDictionary];
        }
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.save.json"];
        
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
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemDictionaries options:0 error:NULL];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"devicetype" : @1,
                                             @"jsondata" : json} mutableCopy];
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

- (id<HMCancelableAPI>)scale_dataWithFamilyMemberID:(NSString *)familyMemberID
                                               date:(NSDate *)date
                                              count:(NSInteger)count
                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIScaleData>> *scaleDatasm, NSDate *nextDataDate))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil, nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/members/%@/weightRecords", userID, familyMemberID]];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, nil);
                });
            }
            return nil;
        }

        NSMutableDictionary *parameters = [@{@"toTime" : @((NSInteger)[date timeIntervalSince1970]),
                                             @"limit" : @100} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil, nil);
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

                                   NSDate *nextDate = nil;
                                   NSArray *historyDatas = nil;
                                   if (success) {
                                       historyDatas = data.hmjson[@"items"].array;
                                       nextDate = data.hmjson[@"next"].date;
                                   }

                                   if (completionBlock) {
                                       completionBlock(success, message, historyDatas, nextDate);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)scale_deleteDatas:(NSArray<id<HMServiceAPIScaleData>> *)dataItems
                         completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSMutableArray *itemDictionarys = [NSMutableArray array];
        for (id<HMServiceAPIScaleData> dataItem in dataItems) {

            NSString *familyMemberID    = dataItem.api_scaleDataFamilyMemberID;
            NSDate *time                = dataItem.api_scaleDataTime;

            NSParameterAssert(time);

            NSDictionary *itemDictionary = @{@"fuid" : familyMemberID.length > 0 ? familyMemberID : @"-1",
                                             @"ts" : @(time.timeIntervalSince1970)};


            [itemDictionarys addObject:itemDictionary];
        }

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.delete.json"];

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

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemDictionarys options:0 error:NULL];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"dt" : @1,
                                             @"jsondata" : json} mutableCopy];
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

- (id<HMCancelableAPI>)scale_updateFamilyMember:(id<HMServiceAPIScaleFamilyMember>)familyMember
                                completionBlock:(void (^)(BOOL success, NSString *message, NSString *avatarURL))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *ID                                = familyMember.api_scaleFamilyMemberID;
        NSParameterAssert(ID.length > 0);
        
        NSString *nickname                          = familyMember.api_scaleFamilyMemberNickname;
        NSDate *birthday                            = familyMember.api_scaleFamilyMemberBirthday;
        HMServiceAPIScaleFamilyMemberGender gender  = familyMember.api_scaleFamilyMemberGender;
        NSString *city                              = familyMember.api_scaleFamilyMemberCity;
        id avatar                                   = familyMember.api_scaleFamilyMemberAvatar;
        double height                               = familyMember.api_scaleFamilyMemberHeight;
        double weight                               = familyMember.api_scaleFamilyMemberWeight;
        double goalWeight                           = familyMember.api_scaleFamilyMemberGoalWeight;
        
        NSParameterAssert(nickname.length > 0 ||
                          birthday ||
                          gender == HMServiceAPIScaleFamilyMemberGenderMale || gender == HMServiceAPIScaleFamilyMemberGenderFemale ||
                          city.length > 0 ||
                          avatar ||
                          height > 0 ||
                          weight > 0 ||
                          goalWeight > 0);
        
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
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.familymember.save.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"fuid" : ID} mutableCopy];
        if (nickname.length > 0) {
            parameters[@"nickname"] = nickname;
        }
        if (birthday) {
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"yyyy-MM";
            // 这个地方的'brithday'接口拼错了
            parameters[@"brithday"] = [formatter stringFromDate:birthday];
        }
        if (gender == HMServiceAPIScaleFamilyMemberGenderMale || gender == HMServiceAPIScaleFamilyMemberGenderFemale) {
            parameters[@"gender"] = gender == HMServiceAPIScaleFamilyMemberGenderMale ? @1 : @0;
        }
        if (city.length > 0) {
            parameters[@"city"] = city;
        }
        if (height > 0) {
            parameters[@"height"] = @(height);
        }
        if (weight > 0) {
            parameters[@"weight"] = @(weight);
        }
        if (goalWeight > 0) {
            parameters[@"targetweight"] = @(goalWeight);
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
                                              } completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                  
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

- (id<HMCancelableAPI>)scale_familyMembersWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIScaleFamilyMember>> *familyMembers))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.familymember.get.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"fuid" : @"all"} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
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
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           NSArray *dataItems = nil;
                                           if (success) {
                                               dataItems = data.hmjson[@"list"].array;
                                           }
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message, dataItems);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)scale_deleteFamilyMembers:(NSArray<id<HMServiceAPIScaleFamilyMember>> *)familyMembers
                                 completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSMutableArray *itemDictionaries = [NSMutableArray new];
        for (id<HMServiceAPIScaleFamilyMember> familyMember in familyMembers) {
            NSString *ID = familyMember.api_scaleFamilyMemberID;
            NSParameterAssert(ID.length > 0);
            
            [itemDictionaries addObject:@{@"fuid" : ID}];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemDictionaries options:0 error:NULL];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.familymember.delete.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"jsondata" : jsonString} mutableCopy];
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
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)scale_updateWeightGoal:(id<HMServiceAPIScaleWeightGoal>)weightGoal
                              completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *familyMemberID = weightGoal.api_scaleWeightGoalFamilyMemberID;
        double value = weightGoal.api_scaleWeightGoalValue;
        double currentValue = weightGoal.api_scaleWeightGoalWeight;
        double height = weightGoal.api_scaleWeightGoalHeight;
        NSDate *createTime = weightGoal.api_scaleWeightGoalCreateTime;
        
        NSParameterAssert(height > 0);
        NSParameterAssert(createTime);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.usergoal.saveusergoal.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"fuid" : familyMemberID.length > 0 ? familyMemberID : @"-1",
                                             @"goal_type" : @1,
                                             @"goal" : @(value),
                                             @"currentval" : @(currentValue),
                                             @"height" : @(height),
                                             @"date_time" : @((long long)createTime.timeIntervalSince1970)} mutableCopy];
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
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)scale_weightGoalsWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIScaleWeightGoal>> *goals))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.usergoal.getusergoallist.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"fuid" : @"all",
                                             @"goal_type" : @1} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
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
                                       completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                           NSArray *dataItems = nil;
                                           if (success) {
                                               dataItems = data.hmjson[@"list"].array;
                                           }
                                           
                                           if (completionBlock) {
                                               completionBlock(success, message, dataItems);
                                           }
                                       }];
                   }];
    }];
}

- (id<HMCancelableAPI>)scale_deleteWeightGoal:(id<HMServiceAPIScaleWeightGoal>)weightGoal
                              completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *familyMemberID = weightGoal.api_scaleWeightGoalFamilyMemberID;
        NSDate *createTime = weightGoal.api_scaleWeightGoalCreateTime;
        
        NSParameterAssert(createTime);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"huami.health.scale.usergoal.deleteusergoal.json"];
        
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
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"fuid" : familyMemberID.length > 0 ? familyMemberID : @"-1",
                                             @"goal_type" : @1,
                                             @"date_time" : @((long long)createTime.timeIntervalSince1970)} mutableCopy];
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
                                           if (completionBlock) {
                                               completionBlock(success, message);
                                           }
                                       }];
                   }];
    }];
}

@end

#import <objc/runtime.h>

@interface NSDictionary (HMServiceAPIScaleData) <HMServiceAPIScaleData>
@end

@implementation NSDictionary (HMServiceAPIScaleData)


- (NSString *)api_scaleDataUserID {
    return self.hmjson[@"uid"].string;
}

- (NSString *)api_scaleDataFamilyMemberID {
    NSString *ID = self.hmjson[@"memberId"].string;
    return ID;
}

- (NSDate *)api_scaleDataTime {
    return self.hmjson[@"generatedTime"].date;
}

- (NSString *)api_scaleDataDeviceID {
    return self.hmjson[@"deviceId"].string;
}

- (HMServiceAPIDeviceSource)api_scaleDataDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}

- (HMServiceScaleUsageMode)api_scaleDataUsageMode {
    return self.hmjson[@"weightType"].unsignedIntegerValue;
}

- (double)api_scaleDataWeight {
    return self.api_scaleDataSummaryDictionary.hmjson[@"weight"].doubleValue;
}

- (double)api_scaleDataHeight {
    return self.api_scaleDataSummaryDictionary.hmjson[@"height"].doubleValue;
}

- (double)api_scaleDataBodyFatRate {
    return self.api_scaleDataSummaryDictionary.hmjson[@"fatRate"].doubleValue;
}

- (double)api_scaleDataBodyMuscleRate {
    return self.api_scaleDataSummaryDictionary.hmjson[@"muscleRate"].doubleValue;
}

- (double)api_scaleDataBoneWeight {
    return self.api_scaleDataSummaryDictionary.hmjson[@"boneMass"].doubleValue;
}

- (double)api_scaleDataMetabolism {
    return self.api_scaleDataSummaryDictionary.hmjson[@"metabolism"].doubleValue;
}

- (double)api_scaleDataVisceralFat {
    return self.api_scaleDataSummaryDictionary.hmjson[@"visceralFat"].doubleValue;
}

- (double)api_scaleDataBodyWaterRate {
    return self.api_scaleDataSummaryDictionary.hmjson[@"bodyWaterRate"].doubleValue;
}

- (NSUInteger)api_scaleDataImpedance {
    return self.api_scaleDataSummaryDictionary.hmjson[@"impedance"].unsignedIntegerValue;
}

- (double)api_scaleDataBMI {
    return self.api_scaleDataSummaryDictionary.hmjson[@"bmi"].doubleValue;
}

- (double)api_scaleDataBodyScore {
    return self.api_scaleDataSummaryDictionary.hmjson[@"bodyScore"].doubleValue;
}

- (HMServiceScaleBodyStyleType)api_scaleDataBodyStyle {
    return self.api_scaleDataSummaryDictionary.hmjson[@"bodyStyle"].unsignedIntegerValue;
}

- (NSDictionary *)api_scaleDataSummaryDictionary {

    NSDictionary *summary = objc_getAssociatedObject(self, "api_scaleDataSummaryDictionary");
    if (summary) {
        return summary;
    }
    summary = self.hmjson[@"summary"].dictionary;
    if (!summary) {
        return nil;
    }
    objc_setAssociatedObject(self, "api_scaleDataSummaryDictionary", summary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return summary;
}

@end

@interface NSDictionary (HMServiceAPIScaleFamilyMember) <HMServiceAPIScaleFamilyMember>
@end

@implementation NSDictionary (HMServiceAPIScaleFamilyMember)

- (NSString *)api_scaleFamilyMemberID {
    return self.hmjson[@"fuid"].string;
}

- (NSString *)api_scaleFamilyMemberNickname {
    return self.hmjson[@"nickname"].string;
}
// 这个地方的'brithday'接口拼错了
- (NSDate *)api_scaleFamilyMemberBirthday {
    return [self.hmjson[@"brithday"] dateWithFormat:@"yyyy-MM"];
}

- (HMServiceAPIScaleFamilyMemberGender)api_scaleFamilyMemberGender {
    return self.hmjson[@"gender"].unsignedIntegerValue;
}

- (NSString *)api_scaleFamilyMemberCity {
    return self.hmjson[@"city"].string;
}

- (id)api_scaleFamilyMemberAvatar {
    return self.hmjson[@"avatar"].string;
}

- (double)api_scaleFamilyMemberHeight {
    return self.hmjson[@"height"].doubleValue;
}

- (double)api_scaleFamilyMemberWeight {
    return self.hmjson[@"weight"].doubleValue;
}
- (double)api_scaleFamilyMemberGoalWeight {
    return self.hmjson[@"targetweight"].doubleValue;
}

@end

@interface NSDictionary (HMServiceAPIScaleWeightGoal) <HMServiceAPIScaleWeightGoal>
@end

@implementation NSDictionary (HMServiceAPIScaleWeightGoal)

- (NSString *)api_scaleWeightGoalFamilyMemberID {
    return self.hmjson[@"fuid"].string;
}

- (double)api_scaleWeightGoalValue {
    return self.hmjson[@"goal"].doubleValue;
}

- (double)api_scaleWeightGoalWeight {
    return self.hmjson[@"currentval"].doubleValue;
}

- (double)api_scaleWeightGoalHeight {
    return self.hmjson[@"height"].doubleValue;
}

- (NSDate *)api_scaleWeightGoalCreateTime {
    return self.hmjson[@"date_time"].date;
}

@end
