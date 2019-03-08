//
//  HMServiceAPI+Training.m
//  HMNetworkLayer
//
//  Created by 李宪 on 22/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Training.h"
#import <HMService/HMService.h>
#import <HMNetworkLayer/HMNetworkLayer.h>

@implementation HMServiceAPI (Training)

- (id<HMCancelableAPI>)training_userTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/joinedTrainings", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender)} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *trainingDatas = nil;
                                   
                                   if (success) {
                                       trainingDatas = data.hmjson[@"items"].array;
                                       trainingDatas.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, trainingDatas);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_trainingPlanWithGender:(HMServiceAPITrainingUserGender)gender
                                       completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingPlan>trainingPlan))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingPlan", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"isDetail" : @YES} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSDictionary *trainingPlan = nil;
                                   
                                   if (success) {
                                       trainingPlan = data;
                                       trainingPlan.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, (id<HMServiceAPITrainingPlan>)trainingPlan);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_recommendedTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                                       BMIType:(HMServiceAPITrainingBMIType)BMIType
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        HMServiceAPIBMITypeParameterAssert(BMIType);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/recommendedTrainings", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender),
                                             @"BMIType" : @(BMIType).hms_trainingBMITypeString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *trainingDatas = nil;
                                   
                                   if (success) {
                                       trainingDatas = data.hmjson[@"items"].array;
                                       trainingDatas.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, trainingDatas);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_recommendedArticlesWithGender:(HMServiceAPITrainingUserGender)gender
                                                      BMIType:(HMServiceAPITrainingBMIType)BMIType
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingArticle>> *articles))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        HMServiceAPIBMITypeParameterAssert(BMIType);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/recommendedArticles", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender),
                                             @"BMIType" : @(BMIType).hms_trainingBMITypeString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *articles = nil;
                                   
                                   if (success) {
                                       articles = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, articles);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_bannersWithUserGender:(HMServiceAPITrainingUserGender)gender
                                              BMIType:(HMServiceAPITrainingBMIType)BMIType
                                      completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingBanner>> *banners))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        HMServiceAPIBMITypeParameterAssert(BMIType);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingBanners", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender),
                                             @"BMIType" : @(BMIType).hms_trainingBMITypeString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *banners = nil;
                                   if (success) {
                                       banners = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, banners);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_popularTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                                   BMIType:(HMServiceAPITrainingBMIType)BMIType
                                           completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        HMServiceAPIBMITypeParameterAssert(BMIType);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/popularTrainings", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender),
                                             @"BMIType" : @(BMIType).hms_trainingBMITypeString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *trainingDatas = nil;
                                   
                                   if (success) {
                                       trainingDatas = data.hmjson[@"items"].array;
                                       trainingDatas.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, trainingDatas);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_allTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                            difficulty:(HMServiceAPITrainingDifficulty)difficulty
                                              bodyPart:(id<HMServiceAPITrainingBodyPart>)bodyPart
                                            instrument:(id<HMServiceAPITrainingInstrument>)instrument
                                      lastTrainingData:(id<HMServiceAPITrainingData>)lastTrainingData
                                       completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"trainings"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender),
                                             @"limit" : @20,
                                             @"isDetail" : @NO,} mutableCopy];
        if (difficulty != HMServiceAPITrainingDifficultyAny) {
            parameters[@"difficultyDegree"] = @(difficulty);
        }
        
        if (bodyPart.api_trainingBodyPartName.length > 0) {
            parameters[@"location"] = bodyPart.api_trainingBodyPartName;
        }
        else if (bodyPart.api_trainingBodyPartID.length > 0) {
            parameters[@"location"] = bodyPart.api_trainingBodyPartID;
        }
        
        if (instrument.api_trainingInstrumentName.length > 0) {
            parameters[@"instrument"] = instrument.api_trainingInstrumentName;
        }
        else if (instrument.api_trainingInstrumentID.length > 0) {
            parameters[@"instrument"] = instrument.api_trainingInstrumentID;
        }
        
        if (lastTrainingData) {
            parameters[@"next"] = @(lastTrainingData.api_trainingDataOrder);
        }
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *trainingDatas = nil;
                                   
                                   if (success) {
                                       trainingDatas = data.hmjson[@"items"].array;
                                       trainingDatas.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, trainingDatas);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_trainingCollectionsWithGender:(HMServiceAPITrainingUserGender)gender
                                                      BMIType:(HMServiceAPITrainingBMIType)BMIType
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingCollection>> *trainingCollections))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        HMServiceAPIBMITypeParameterAssert(BMIType);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/recommendedCollections", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender),
                                             @"BMIType" : @(BMIType).hms_trainingBMITypeString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *trainingCollections = nil;
                                   
                                   if (success) {
                                       trainingCollections = data.hmjson[@"items"].array;
                                       trainingCollections.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, trainingCollections);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_trainingDetailWithID:(NSString *)trainingID
                                              gender:(HMServiceAPITrainingUserGender)gender
                                     completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingData>trainingData))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(trainingID.length > 0);
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"trainings/%@", trainingID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender)} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                               completionBlock:^(BOOL success, NSString *message, id data) {
                                   
                                   NSDictionary *trainingData = nil;
                                   
                                   if (success) {
                                       trainingData = data;
                                       trainingData.api_cachedTrainingUserGender = gender;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, (id<HMServiceAPITrainingData>)trainingData);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_joinTrainingWithID:(NSString *)trainingID
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(trainingID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/joinTrainings/%@", userID, trainingID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
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

- (id<HMCancelableAPI>)training_uploadRecordWithTrainingID:(NSString *)trainingID
                                            trainingPlanID:(NSString *)trainingPlanID
                                                 beginTime:(NSDate *)beginTime
                                                   endTime:(NSDate *)endTime
                                                  duration:(NSTimeInterval)duration
                                                heartRates:(NSArray<id<HMServiceAPITrainingRecordHeartRate>> *)heartRates
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(trainingID.length > 0);
        NSParameterAssert(beginTime);
        NSParameterAssert(endTime);
        NSParameterAssert(duration > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainings/%@", userID, trainingID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        headers[@"Content-Type"] = @"application/json";
        
        NSMutableDictionary *parameters = [@{@"isFinished" : @YES,
                                             @"startTime" : @((long long)beginTime.timeIntervalSince1970 * 1000),
                                             @"updateTime" : @((long long)endTime.timeIntervalSince1970 * 1000),
                                             @"duration" : @(duration * 1000.f)} mutableCopy];
        if (trainingPlanID.length > 0) {
            parameters[@"trainingPlanId"] = trainingPlanID;
        }
        if (heartRates) {
            
            NSUInteger max = 0;
            NSUInteger sum = 0;
            NSMutableArray *csvSamples = [NSMutableArray new];
            
            NSTimeInterval lastTimestamp = beginTime.timeIntervalSince1970;
            NSUInteger lastValue = 0;
            
            for (id<HMServiceAPITrainingRecordHeartRate>heartRate in heartRates) {
                NSTimeInterval timestamp = heartRate.api_trainingRecordHeartRateTime.timeIntervalSince1970;
                NSUInteger value = heartRate.api_trainingRecordHeartRateValue;
                
                if (max < value) {
                    max = value;
                }
                
                sum += value;
                
                NSString *sample = [NSString stringWithFormat:@"%lld,%d", (long long)(timestamp - lastTimestamp), (int)(value - lastValue)];
                [csvSamples addObject:sample];
                
                lastTimestamp = timestamp;
                lastValue = value;
            }
            
            NSUInteger average = sum / heartRates.count;
            NSString *csvString = [csvSamples componentsJoinedByString:@";"];
            
            parameters[@"heartRateData"] = @{@"startTime" : @((long long)beginTime.timeIntervalSince1970 * 1000),
                                             @"averageHeartRate" : @(average),
                                             @"maxHeartRate" : @(max),
                                             @"heartRate" : csvString};
        }
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
        
        
        return [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPUT
                                                  URL:URL
                                             fromData:jsonData
                                              headers:headers
                                              timeout:0
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

- (id<HMCancelableAPI>)training_quitTrainingWithID:(NSString *)trainingID
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(trainingID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/joinTrainings/%@", userID, trainingID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        return [HMNetworkCore DELETE:URL
                          parameters:parameters
                             headers:headers
                             timeout:0
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

- (id<HMCancelableAPI>)training_createTrainingPlanWithFunction:(HMServiceAPITrainingFunctionType)function
                                                    difficulty:(HMServiceAPITrainingDifficulty)difficulty
                                                        gender:(HMServiceAPITrainingUserGender)gender
                                                          date:(NSDate *)date
                                               completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingPlan>trainingPlan))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        NSParameterAssert(date);
        
        NSString *functionString = @(function).hms_trainingFunctionTypeString;
        NSString *difficultyString = @(difficulty).hms_trainingDifficultyString;
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:date];
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingPlan?isDetail=true", userID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        headers[@"Content-Type"] = @"application/json";
        
        NSMutableDictionary *parameters = [@{@"trainingType" : functionString,
                                             @"difficultyDegree" : difficultyString,
                                             @"gender" : @(gender),
                                             @"startDate" : dateString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
        NSLog(@"jsonData is: %s", (char *)jsonData.bytes);
        
        return [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPOST
                                                  URL:URL
                                             fromData:jsonData
                                              headers:headers
                                              timeout:0
                                      completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                          
                                          [self handleResultForAPI:_cmd
                                                     responseError:error
                                                          response:response
                                                    responseObject:responseObject
                                                 desiredDataFormat:HMServiceResultDataFormatDictionary
                                                   completionBlock:^(BOOL success, NSString *message, id data) {
                                                       
                                                       NSDictionary *trainingPlan = nil;
                                                       
                                                       if (success) {
                                                           trainingPlan = data;
                                                           trainingPlan.api_cachedTrainingUserGender = gender;
                                                       }
                                                       
                                                       if (completionBlock) {
                                                           completionBlock(success, message, (id<HMServiceAPITrainingPlan>)trainingPlan);
                                                       }
                                                   }];
                                      }];
    }];
}

- (id<HMCancelableAPI>)training_quitTrainingPlanWithID:(NSString *)trainingPlanID
                                       completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(trainingPlanID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingPlans/%@", userID, trainingPlanID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        return [HMNetworkCore DELETE:URL
                          parameters:parameters
                             headers:headers
                             timeout:0
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

- (id<HMCancelableAPI>)training_trainingRecordsFromTime:(NSDate *)beginTime
                                                 toTime:(NSDate *)endTime
                                                 gender:(HMServiceAPITrainingUserGender)gender
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingRecord>> *trainingRecords, NSTimeInterval totalTimeSpent, NSUInteger totalFinishedCount, double totalEnergyBurnedInCalorie))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingRecords", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil, 0, 0, 0);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"limit" : @0} mutableCopy];
        
        if (beginTime) {
            parameters[@"startTime"] = @((long long)beginTime.timeIntervalSince1970 * 1000);
        }
        if (endTime) {
            parameters[@"endTime"] = @((long long)endTime.timeIntervalSince1970 * 1000);
        }
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil, 0, 0, 0);
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
                                   
                                   NSArray *trainingRecords = nil;
                                   NSTimeInterval totalTimeSpent = 0;
                                   NSUInteger totalFinishedCount = 0;
                                   double totalEnergyBurnedInCalorie = 0;
                                   
                                   if (success) {
                                       trainingRecords = data.hmjson[@"userTrainingRecords"].array;
                                       trainingRecords.api_cachedTrainingUserGender = gender;
                                       
                                       totalTimeSpent               = data.hmjson[@"accumulationTime"].doubleValue / 1000.f;
                                       totalFinishedCount           = data.hmjson[@"accumulationNumber"].unsignedIntegerValue;
                                       totalEnergyBurnedInCalorie   = data.hmjson[@"accumulationConsumption"].doubleValue;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, trainingRecords, totalTimeSpent, totalFinishedCount, totalEnergyBurnedInCalorie);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_knowledgesWithLastOne:(id<HMServiceAPITrainingKnowledge>)lastKnowledge
                                      completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingKnowledge>> *knowledges))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingKnowledge", userID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"limit" : @20} mutableCopy];
        if (lastKnowledge) {
            parameters[@"next"] = @(lastKnowledge.api_trainingKnowledgeOrder);
        }
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   
                                   NSArray *knowledges = nil;
                                   
                                   if (success) {
                                       knowledges = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, knowledges);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_recommendedMiDongQuanWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingArticle>> *miDongQuans))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"runCirclePosts"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"limit" : @6} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   NSArray *miDongQuans = nil;
                                   
                                   if (success) {
                                       miDongQuans = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, miDongQuans);
                                   }
                               }];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_collectionTrainingsWithCollecitonID:(NSString *)collectionID
                                                             gender:(HMServiceAPITrainingUserGender)gender
                                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(collectionID.length > 0);
        HMServiceAPITrainingUserGenderParameterAssert(gender);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"trainingCollections/%@", collectionID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"gender" : @(gender)} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   NSArray *miDongQuans = nil;
                                   
                                   if (success) {
                                       miDongQuans = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, miDongQuans);
                                   }
                               }];
                  }];
    }];
}

- (void)training_dataItemWithKey:(NSString *)key
                 completionBlock:(void (^)(BOOL success, NSString *message, NSArray *items))completionBlock {
    
    [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(key.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"dictionaries/%@", key]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                                   NSArray *items = nil;
                                   
                                   if (success) {
                                       items = data.hmjson[@"items"].array;
                                   }
                                   
                                   if (completionBlock) {
                                       completionBlock(success, message, items);
                                   }
                               }];
                  }];
    }];
}

- (void)training_dataItemsWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingBodyPart>> *bodyParts, NSArray<id<HMServiceAPITrainingInstrument>> *instruments))completionBlock {
    
    [self training_dataItemWithKey:@"TRAINING_LOCATION"
                   completionBlock:^(BOOL success, NSString *message, NSArray *items) {
                       if (!success) {
                           if (completionBlock) {
                               completionBlock(NO, message, nil, nil);
                           }
                           return;
                       }
                       
                       NSArray *bodyParts = items;
                       
                       [self training_dataItemWithKey:@"TRAINING_INSTRUMENT"
                                      completionBlock:^(BOOL success, NSString *message, NSArray *items) {
                                          
                                          NSArray *instruments = items;
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, bodyParts, instruments);
                                          }
                                      }];
                   }];
}

- (id<HMCancelableAPI>)training_trainingRecordWithID:(NSString *)ID
                                          trainingID:(NSString *)trainingID
                                              gender:(HMServiceAPITrainingUserGender)gender
                                     completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingRecord>trainingRecord))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(ID.length > 0);
        NSParameterAssert(trainingID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingRecords/%@", userID, trainingID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"finishTime" : ID,
                                             @"gender" : @(gender)} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
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
                               completionBlock:completionBlock];
                  }];
    }];
}

- (id<HMCancelableAPI>)training_jsonTrainingPlanWithID:(NSString *)trainingPlanID
                                                  date:(NSDate *)date
                                       completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(trainingPlanID.length > 0);
        NSParameterAssert(date > 0);
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:date];
        
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingPlans/%@", userID, trainingPlanID]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        headers[@"Content-Type"] = @"application/json";
        
        NSMutableDictionary *parameters = [@{@"startDay" : dateString} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
        
        return [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPOST
                                                  URL:URL
                                             fromData:jsonData
                                              headers:headers
                                              timeout:0
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

- (id<HMCancelableAPI>)training_deleteTrainingRecordWithID:(NSString *)ID
                                                trainingID:(NSString *)trainingID
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSParameterAssert(ID.length > 0);
        NSParameterAssert(trainingID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"users/%@/trainingRecords/%@", userID, trainingID]];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"finishTime" : ID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            !completionBlock ?: completionBlock(NO, error.localizedDescription);
            return nil;
        }
        
        return [HMNetworkCore DELETE:URL
                          parameters:parameters
                             headers:headers
                             timeout:0
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
