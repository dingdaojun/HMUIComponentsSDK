//
//  HMServiceAPI+Laboratory.m
//  HMNetworkLayer
//
//  Created by 李宪 on 16/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Laboratory.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


#define HMServiceAPILaboratoryBehaviourTypeParameterAssert(x)       NSParameterAssert(x == HMServiceAPILaboratoryBehaviourSleep ||  \
x == HMServiceAPILaboratoryBehaviourBath || \
x == HMServiceAPILaboratoryBehaviourBrushTeeth ||   \
x == HMServiceAPILaboratoryBehaviourRun ||  \
x == HMServiceAPILaboratoryBehaviourStand ||    \
x == HMServiceAPILaboratoryBehaviourWalk || \
x == HMServiceAPILaboratoryBehaviourBadminton ||    \
x == HMServiceAPILaboratoryBehaviourBasketball ||   \
x == HMServiceAPILaboratoryBehaviourPingpang || \
x == HMServiceAPILaboratoryBehaviourSit ||  \
x == HMServiceAPILaboratoryBehaviourBus ||  \
x == HMServiceAPILaboratoryBehaviourCustomize ||    \
x == HMServiceAPILaboratoryBehaviourRopeSkipping || \
x == HMServiceAPILaboratoryBehaviourSitUp ||    \
x == HMServiceAPILaboratoryBehaviourCycling ||  \
x == HMServiceAPILaboratoryBehaviourDrive ||    \
x == HMServiceAPILaboratoryBehaviourClimbStairs ||  \
x == HMServiceAPILaboratoryBehaviourDining)

#define HMServiceAPILaboratorySensorOptionsParameterAssert(x)       NSParameterAssert(x < (HMServiceAPILaboratorySensorAccelerometer |   \
HMServiceAPILaboratorySensorGyrometer | \
HMServiceAPILaboratorySensorMagnetometer |  \
HMServiceAPILaboratorySensorPhotoplethysmography |  \
HMServiceAPILaboratorySensorElectrocardiograph  |   \
HMServiceAPILaboratorySensorGPS |   \
HMServiceAPILaboratorySensorBarometer))

@implementation NSDictionary (HMServiceAPILaboratoryBehaviourString)

+ (NSDictionary *)hms_laboratoryBehaviourTypeStringMap {
    return @{@"sleep"       : @(HMServiceAPILaboratoryBehaviourSleep),
             @"bath"        : @(HMServiceAPILaboratoryBehaviourBath),
             @"teeth"       : @(HMServiceAPILaboratoryBehaviourBrushTeeth),
             @"run"         : @(HMServiceAPILaboratoryBehaviourRun),
             @"stand"       : @(HMServiceAPILaboratoryBehaviourStand),
             @"walk"        : @(HMServiceAPILaboratoryBehaviourWalk),
             @"badminton"   : @(HMServiceAPILaboratoryBehaviourBadminton),
             @"basketball"  : @(HMServiceAPILaboratoryBehaviourBasketball),
             @"pingpong"    : @(HMServiceAPILaboratoryBehaviourPingpang),
             @"sit"         : @(HMServiceAPILaboratoryBehaviourSit),
             @"bus"         : @(HMServiceAPILaboratoryBehaviourBus),
             @"customize"   : @(HMServiceAPILaboratoryBehaviourCustomize),
             @"rope"        : @(HMServiceAPILaboratoryBehaviourRopeSkipping),
             @"sit-up"      : @(HMServiceAPILaboratoryBehaviourSitUp),
             @"cycling"     : @(HMServiceAPILaboratoryBehaviourCycling),
             @"driving"     : @(HMServiceAPILaboratoryBehaviourDrive),
             @"stairs"      : @(HMServiceAPILaboratoryBehaviourClimbStairs),
             @"dining"      : @(HMServiceAPILaboratoryBehaviourDining),};
}

@end

@implementation NSNumber (HMServiceAPILaboratoryBehaviourString)

- (NSString *)hms_laboratoryBehaviourTypeString {
    
    HMServiceAPILaboratoryBehaviourType behaviourType = self.unsignedIntegerValue;
    __block NSString *behaviourName = nil;
    
    [[NSDictionary hms_laboratoryBehaviourTypeStringMap] enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSNumber *type, BOOL * stop) {
        if (type.unsignedIntegerValue == behaviourType) {
            behaviourName = name;
        }
    }];
    return behaviourName;
}

@end

@implementation NSNumber (HMServiceAPILaboratorySensorOptions)

- (NSString *)hms_laboratorySensorTypesString {
    HMServiceAPILaboratorySensorOptions sensorsOptions = self.unsignedIntegerValue;
    HMServiceAPILaboratorySensorOptionsParameterAssert(sensorsOptions);
    
    NSMutableArray *sensorTypes = [NSMutableArray new];
    for (int i = 0; i < 16; i++) {
        if (sensorsOptions & (1 << i)) {
            [sensorTypes addObject:@(i + 1)];
        }
    }
    
    return [sensorTypes componentsJoinedByString:@","];
}

@end



@implementation HMServiceAPI (Laboratory)

- (id<HMCancelableAPI>)laboratory_behaviourCountsWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPILaboratoryBehaviourCount>> *behaviourCounts))completionBlock {
    
    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        
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
        
        NSMutableDictionary *parameters = [@{@"propertyName" : @"huami.mifit.user.behaviortagscount",
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
                          headers:headers timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                   
                                   NSArray *counts = nil;
                                   if (success) {
                                       NSDictionary *values = data.hmjson[@"huami.mifit.user.behaviortagscount"].dictionary;
                                       if (values) {
                                           NSMutableArray *countDictionaries = [NSMutableArray new];
                                           
                                           [values enumerateKeysAndObjectsUsingBlock:^(NSString *key, id count, BOOL *stop) {
                                               NSNumber *type = [NSDictionary hms_laboratoryBehaviourTypeStringMap][key];
                                               if (type) {
                                                   [countDictionaries addObject:@{@"type" : type,
                                                                                  @"count" : count}];
                                               }
                                           }];
                                           
                                           counts = countDictionaries;
                                       }
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, counts);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)laboratory_updateBehaviourCounts:(NSArray<id<HMServiceAPILaboratoryBehaviourCount>> *)behaviourCounts
                                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSMutableDictionary *countDictionary = [NSMutableDictionary new];
        [behaviourCounts enumerateObjectsUsingBlock:^(id<HMServiceAPILaboratoryBehaviourCount> obj, NSUInteger idx, BOOL *stop) {
            [[NSDictionary hms_laboratoryBehaviourTypeStringMap] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *type, BOOL *stop) {
                if (type.unsignedIntegerValue == obj.api_laboratoryBehaviourCountType) {
                    countDictionary[key] = @(obj.api_laboratoryBehaviourCountValue);
                }
            }];
        }];
        
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/properties", userID]];
        
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
        
        headers[@"Content-Type"] = @"application/json";
        
        NSMutableDictionary *parameters = [@{@"properties" : @{@"huami.mifit.user.behaviortagscount" : countDictionary}
                                             } mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
        
        return [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPOST
                                                  URL:URL
                                             fromData:jsonData
                                              headers:headers
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

- (id<HMCancelableAPI>)laboratory_historyBehavioursWithLastOne:(id<HMServiceAPILaboratoryBehaviour>)lastBehaviour
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPILaboratoryBehaviour>> *historyBehaviours))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSDate *lastDataBeginTime = lastBehaviour.api_laboratoryDataBeginTime ?: [NSDate date];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/sensorData", userID]];
        
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
        
        NSMutableDictionary *parameters = [@{@"startBehaviorTime" : @((long long)(lastDataBeginTime.timeIntervalSince1970 * 1000)),
                                             @"count" : @20} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            };
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
                                   
                                   NSArray *historyDatas = nil;
                                   if (success) {
                                       historyDatas = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, historyDatas);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)laboratory_uploadZipFile:(NSString *)zipFilePath
                                         putURI:(NSString *)putURI
                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(zipFilePath.length > 0);
        NSParameterAssert(putURI.length > 0);
        
        NSDictionary *headers = @{@"Content-Type" : @""};
        
        return [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPUT
                                                  URL:putURI
                                             fromFile:zipFilePath
                                              headers:headers
                                      completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                                          [self handleResultForAPI:_cmd
                                                     responseError:error
                                                          response:response
                                                    responseObject:responseObject
                                                 desiredDataFormat:HMServiceResultDataFormatAny
                                                   completionBlock:^(BOOL success, NSString *message, id data) {
                                                       if (completionBlock) {
                                                           completionBlock(success, message);
                                                       }
                                                   }];
                                      }];
    }];
}

- (id<HMCancelableAPI>)laboratory_uploadBehaviour:(id<HMServiceAPILaboratoryBehaviour>)behaviour
                                         tagFiles:(NSArray<id<HMServiceAPILaboratoryBehaviourTagFile>> *)tagFiles
                                      zipFilePath:(NSString *)zipFilePath
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSDate *beginTime                                       = behaviour.api_laboratoryDataBeginTime;
        NSDate *endTime                                         = behaviour.api_laboratoryDataEndTime;
        NSTimeZone *timeZone                                    = behaviour.api_laboratoryDataTimeZone;
        HMServiceAPILaboratoryBehaviourType behaviourType       = behaviour.api_laboratoryDataBehaviourType;
        NSString *customBehaviorName                            = behaviour.api_laboratoryDataCustomBehaviorName;
        HMServiceAPIDeviceSource deviceSource                   = behaviour.api_laboratoryDataDeviceSource;
        HMServiceAPIProductVersion productVersion               = behaviour.api_laboratoryDataProductVersion;
        NSString *deviceID                                      = behaviour.api_laboratoryDataDeviceID;
        HMServiceAPILaboratorySensorOptions sensorsOptions      = behaviour.api_laboratoryDataSensors;
        NSParameterAssert(beginTime);
        NSParameterAssert(endTime);
        NSParameterAssert(timeZone);
        HMServiceAPILaboratoryBehaviourTypeParameterAssert(behaviourType);
        HMServiceAPIDeviceSourceParameterAssert(deviceSource);
        NSParameterAssert(deviceID.length > 0);
        
        NSString *behaviourName = @(behaviourType).hms_laboratoryBehaviourTypeString;
        NSParameterAssert(behaviourName.length > 0);
        
        NSString *sensorTypesString = @(sensorsOptions).hms_laboratorySensorTypesString;
        NSParameterAssert(sensorTypesString.length > 0);
        
        NSString *zipFileName = [NSString stringWithFormat:@"%@_%@_%@.zip", userID, behaviourName, @((long long)(beginTime.timeIntervalSince1970 * 1000))];
        
        NSParameterAssert(tagFiles.count > 0);
        NSMutableArray *tagFileDictionaries = [NSMutableArray new];
        for (id<HMServiceAPILaboratoryBehaviourTagFile>tagFile in tagFiles) {
            NSDate *beginTime                               = tagFile.api_laboratoryBehaviourTagFileBeginTime;
            NSDate *endTime                                 = tagFile.api_laboratoryBehaviourTagFileEndTime;
            NSString *fileName                              = tagFile.api_laboratoryBehaviourTagFileName;
            HMServiceAPILaboratorySensorOptions sensorType  = tagFile.api_laboratoryBehaviourTagFileSensorType;
            NSUInteger sensitivity                          = tagFile.api_laboratoryBehaviourTagFileSensitivity;
            NSUInteger sampleRate = tagFile.api_laboratoryBehaviourTagFileSampleRate;
            NSParameterAssert(beginTime);
            NSParameterAssert(endTime);
            NSParameterAssert(fileName.length > 0);
            NSParameterAssert(sampleRate > 0);
            
            NSString *sensorTypesString = @(sensorType).hms_laboratorySensorTypesString;
            NSParameterAssert(sensorTypesString.length > 0);
            
            [tagFileDictionaries addObject:@{@"sampleRate"        : @(sampleRate),
                                             @"startTaggingTime"  : @((long long)(beginTime.timeIntervalSince1970 * 1000)),
                                             @"endTaggingTime"    : @((long long)(endTime.timeIntervalSince1970 * 1000)),
                                             @"sensorType"        : sensorTypesString,
                                             @"fileName"          : fileName,
                                             @"sensitivity"       : @(sensitivity)}];
        }
        
        NSDictionary *behaviourDictioanry = @{@"protocolVersion"         : @25,
                                              @"deviceId"                : deviceID,
                                              @"deviceSource"            : @(deviceSource),
                                              @"behaviorName"            : behaviourName,
                                              @"customizeBehaviorName"   : customBehaviorName ?: @"",
                                              @"productVersion"          : @(productVersion),
                                              @"zipFileName"             : zipFileName,
                                              @"sensorTypes"             : sensorTypesString,
                                              @"timeZone"                : @([timeZone hms_offset]),
                                              @"startBehaviorTime"       : @((long long)(beginTime.timeIntervalSince1970 * 1000)),
                                              @"endBehaviorTime"         : @((long long)(endTime.timeIntervalSince1970 * 1000)),
                                              @"taggingFiles"            : tagFileDictionaries};
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/apps/com.xiaomi.hm.health/fileAccessURIs", userID]];
        
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
        headers[@"Content-Type"] = @"application/json";
        
        NSMutableDictionary *parameters = [@{@"sensorData" : behaviourDictioanry,
                                             @"fileType" : @"SENSOR_DATA",
                                             @"fileName" : zipFileName} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
        printf("%s", (char *)jsonData.bytes);
        
        return [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPOST
                                                  URL:URL
                                             fromData:jsonData
                                              headers:headers
                                      completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                                          [self handleResultForAPI:_cmd
                                                     responseError:error
                                                          response:response
                                                    responseObject:responseObject
                                                 desiredDataFormat:HMServiceResultDataFormatDictionary
                                                   completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                                       
                                                       if (!success) {
                                                           if (completionBlock) {
                                                               completionBlock(NO, message);
                                                           }
                                                           return;
                                                       }
                                                       
                                                       NSString *putURI = data.hmjson[@"putURI"].string;
                                                       if (putURI.length == 0) {
                                                           
                                                           NSString *localizedMessage = message;
                                                           NSError *error = [NSError errorWithHMServiceAPIError:HMServiceAPIErrorResponseDataFormat userInfo:nil];
                                                           
                                                           [self.delegate service:self
                                                                   didDetectError:error
                                                                            inAPI:NSStringFromSelector(_cmd)
                                                                 localizedMessage:&localizedMessage];
                                                           if (completionBlock) {
                                                               completionBlock(NO, localizedMessage);
                                                           }
                                                       }
                                                       
                                                       [self laboratory_uploadZipFile:zipFilePath
                                                                               putURI:putURI
                                                                      completionBlock:completionBlock];
                                                   }];
                                      }];
    }];
}

@end



@interface NSDictionary (HMServiceAPILaboratoryBehaviourCount) <HMServiceAPILaboratoryBehaviourCount>
@end

@implementation NSDictionary (HMServiceAPILaboratoryBehaviourCount)

- (HMServiceAPILaboratoryBehaviourType)api_laboratoryBehaviourCountType {
    return self.hmjson[@"type"].unsignedIntegerValue;
}

- (NSUInteger)api_laboratoryBehaviourCountValue {
    return self.hmjson[@"count"].unsignedIntegerValue;
}

@end



@interface NSDictionary (HMServiceAPILaboratoryBehaviour) <HMServiceAPILaboratoryBehaviour>
@end

@implementation NSDictionary (HMServiceAPILaboratoryBehaviour)

#pragma mark - HMServiceAPILaboratoryBehaviour

- (NSDate *)api_laboratoryDataBeginTime {
    return self.hmjson[@"startBehaviorTime"].date;
}

- (NSDate *)api_laboratoryDataEndTime {
    return self.hmjson[@"endBehaviorTime"].date;
}

- (NSTimeZone *)api_laboratoryDataTimeZone {
    NSUInteger offset = self.hmjson[@"timeZone"].integerValue;
    return [NSTimeZone hms_timeZoneWithOffset:offset];
}

- (HMServiceAPILaboratoryBehaviourType)api_laboratoryDataBehaviourType {
    NSString *name = self.hmjson[@"behaviorName"].string;
    return [NSDictionary hms_laboratoryBehaviourTypeStringMap].hmjson[name].unsignedIntegerValue;
}

- (NSString *)api_laboratoryDataCustomBehaviorName {
    return self.hmjson[@"customizeBehaviorName"].string;
}

- (HMServiceAPIDeviceSource)api_laboratoryDataDeviceSource {
    return self.hmjson[@"deviceSource"].unsignedIntegerValue;
}

- (HMServiceAPIProductVersion)api_laboratoryDataProductVersion {
    return self.hmjson[@"productVersion"].unsignedIntegerValue;
}

- (NSString *)api_laboratoryDataDeviceID {
    return self.hmjson[@"deviceId"].string;
}

- (HMServiceAPILaboratorySensorOptions)api_laboratoryDataSensors {
    NSString *typesString = self.hmjson[@"sensorTypes"].string;
    NSArray *types = [typesString componentsSeparatedByString:@","];
    
    HMServiceAPILaboratorySensorOptions sensorOptions = 0;
    for (NSString *valueString in types) {
        
        NSUInteger type = valueString.integerValue;
        if (type == 0) {
            continue;
        }
        
        sensorOptions |= 1 << (type - 1);
    }
    
    return sensorOptions;
}

@end
