//
//  HMServiceAPITrainingData.m
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingData.h"
#import <HMService/HMService.h>

#pragma mark - Helpers

@interface HMServiceJSONValue (HMServiceAPITrainingCalculateType)
@property (nonatomic, assign, readonly) HMServiceAPITrainingCalculateType trainingCalculateType;
@end

@implementation HMServiceJSONValue (HMServiceAPITrainingCalculateType)
- (HMServiceAPITrainingCalculateType)trainingCalculateType {
    
    if ([self.string isEqualToString:@"COUNT"]) {
        return HMServiceAPITrainingCalculateByCount;
    }
    
    return HMServiceAPITrainingCalculateByTime;
}
@end


#pragma mark - Gender

#import <objc/runtime.h>

@implementation NSDictionary (HMServiceAPITrainingUserGender)

- (HMServiceAPITrainingUserGender)api_cachedTrainingUserGender {
    NSNumber *value = objc_getAssociatedObject(self, "api_cachedTrainingUserGender");
    return value.unsignedIntegerValue;
}

- (void)setApi_cachedTrainingUserGender:(HMServiceAPITrainingUserGender)api_cachedTrainingUserGender {
    objc_setAssociatedObject(self, "api_cachedTrainingUserGender", @(api_cachedTrainingUserGender), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj respondsToSelector:@selector(setApi_cachedTrainingUserGender:)]) {
            [obj setApi_cachedTrainingUserGender:api_cachedTrainingUserGender];
        }
    }];
}

@end

@implementation NSArray (HMServiceAPITrainingUserGender)

- (HMServiceAPITrainingUserGender)api_cachedTrainingUserGender {
    NSNumber *value = objc_getAssociatedObject(self, "api_cachedTrainingUserGender");
    return value.unsignedIntegerValue;
}

- (void)setApi_cachedTrainingUserGender:(HMServiceAPITrainingUserGender)api_cachedTrainingUserGender {
    objc_setAssociatedObject(self, "api_cachedTrainingUserGender", @(api_cachedTrainingUserGender), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    for (id obj in self) {
        if ([obj respondsToSelector:@selector(setApi_cachedTrainingUserGender:)]) {
            [obj setApi_cachedTrainingUserGender:api_cachedTrainingUserGender];
        }
    }
}

@end


#pragma mark - Coach

@interface NSDictionary (HMServiceAPITrainingCoach) <HMServiceAPITrainingCoach>
@end

@implementation NSDictionary (HMServiceAPITrainingCoach)

- (NSString *)api_trainingCoachID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingCoachHuamiID {
    return self.hmjson[@"huamiId"].string;
}

- (NSString *)api_trainingCoachName {
    return self.hmjson[@"name"].string;
}

- (HMServiceAPITrainingUserGender)api_trainingCoachGender {
    return self.hmjson[@"gender"].unsignedIntegerValue;
}

- (NSString *)api_trainingCoachAvatarURL {
    return self.hmjson[@"portrait"].string;
}

- (NSString *)api_trainingCoachIntroduction {
    return self.hmjson[@"introduction"].string;
}

- (NSString *)api_trainingCoachHomePageURL {
    return self.hmjson[@"homePageUrl"].string;
}

@end


#pragma mark - Instrument

@interface NSDictionary (HMServiceAPITrainingInstrument) <HMServiceAPITrainingInstrument>
@end

@implementation NSDictionary (HMServiceAPITrainingInstrument)

- (NSString *)api_trainingInstrumentID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingInstrumentName {
    return self.hmjson[@"name"].string;
}

@end


#pragma mark - Function

@interface NSDictionary (HMServiceAPITrainingFunction) <HMServiceAPITrainingFunction>
@end

@implementation NSDictionary (HMServiceAPITrainingFunction)

- (NSString *)api_trainingFunctionID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingFunctionName {
    return self.hmjson[@"name"].string;
}

@end


#pragma mark - Body part

@interface NSDictionary (HMServiceAPITrainingBodyPart) <HMServiceAPITrainingBodyPart>
@end

@implementation NSDictionary (HMServiceAPITrainingBodyPart)

- (NSString *)api_trainingBodyPartID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingBodyPartName {
    return self.hmjson[@"name"].string;
}

@end


#pragma mark - Audio

@interface NSDictionary (HMServiceAPITrainingAudio) <HMServiceAPITrainingAudio>
@end

@implementation NSDictionary (HMServiceAPITrainingAudio)

- (NSString *)api_trainingAudioName {
    return self.hmjson[@"name"].string;
}

- (NSString *)api_trainingAudioContent {
    return self.hmjson[@"content"].string;
}

- (NSString *)api_trainingAudioFileURL {
    return self.hmjson[@"url"].string;
}

- (NSUInteger)api_trainingAudioSize {
    return self.hmjson[@"size"].unsignedIntegerValue;
}

@end


#pragma mark - Video

@interface NSDictionary (HMServiceAPITrainingVideo) <HMServiceAPITrainingVideo>
@end

@implementation NSDictionary (HMServiceAPITrainingVideo)

- (NSString *)api_trainingVideoName {
    return self.hmjson[@"name"].string;
}

- (NSString *)api_trainingVideoThumbnailImageURL {
    return self.hmjson[@"thumbnail"].string;
}

- (HMServiceAPITrainingDifficulty)api_trainingVideoDifficulty {
    return self.hmjson[@"difficultyDegree"].unsignedIntegerValue;
}

- (HMServiceAPITrainingCalculateType)api_trainingVideoCalculateType {
    return self.hmjson[@"type"].trainingCalculateType;
}

- (id<HMServiceAPITrainingInstrument>)api_trainingVideoInstrument {
    return self.hmjson[@"instrument"].dictionary;
}

- (NSTimeInterval)api_trainingVideoDuration {
    return self.hmjson[@"time"].doubleValue / 1000.f;
}

- (NSTimeInterval)api_trainingVideoSingleActionDuration {
    return self.hmjson[@"singleActionTime"].doubleValue / 1000.f;
}

- (id<HMServiceAPITrainingFunction>)api_trainingVideoFunction {
    return self.hmjson[@"function"].dictionary;
}

- (NSArray<id<HMServiceAPITrainingBodyPart>> *)api_trainingVideoBodyParts {
    return self.hmjson[@"location"].array;
}

- (NSString *)api_trainingVideoPlainTextDocument {
    if ([self.hmjson[@""].string.uppercaseString isEqualToString:@"TEXT"]) {
        return self.hmjson[@"interpretationDocument"].string;
    }
    
    return nil;
}

- (NSString *)api_trainingVideoHTMLDocument {
    if ([self.hmjson[@""].string.uppercaseString isEqualToString:@"HTML"]) {
        return self.hmjson[@"interpretationDocument"].string;
    }
    
    return nil;
}

- (NSString *)api_trainingVideoFileURL {
    return self.hmjson[@"url"].string;
}

- (NSUInteger )api_trainingVideoFileSize {
    return self.hmjson[@"size"].unsignedIntegerValue;
}

@end


#pragma mark - Action

@interface NSDictionary (HMServiceAPITrainingAction) <HMServiceAPITrainingAction>
@end

@implementation NSDictionary (HMServiceAPITrainingAction)

- (NSString *)api_trainingActionID {
    return self.hmjson[@"audio"][@"id"].string;
}

- (NSString *)api_trainingActionName {
    return self.hmjson[@"name"].string;
}

- (NSUInteger)api_trainingActionGroup {
    return self.hmjson[@"group"].unsignedIntegerValue;
}

- (NSUInteger)api_trainingActionRound {
    return self.hmjson[@"round"].unsignedIntegerValue;
}

- (NSUInteger)api_trainingActionRepeatNumber {
    return self.hmjson[@"repeatNumber"].unsignedIntegerValue;
}

- (NSTimeInterval)api_trainingActionDuration {
    
    NSDictionary *dictionary = self.hmjson[@"duration"].dictionary;
    if (!dictionary) {
        return 0.f;
    }

    HMServiceAPITrainingUserGender gender = self.api_cachedTrainingUserGender;
    if (gender == HMServiceAPITrainingUserGenderMale) {
        return dictionary.hmjson[@"male"].doubleValue / 1000.f;
    }
    else {
        return dictionary.hmjson[@"female"].doubleValue / 1000.f;
    }
}

- (NSTimeInterval)api_trainingActionBreakTime {
    return self.hmjson[@"nextRestTime"].doubleValue / 1000.f;
}

- (id<HMServiceAPITrainingAudio>)api_trainingActionAudio {
    return self.hmjson[@"audio"].dictionary;
}

- (id<HMServiceAPITrainingVideo>)api_trainingActionVideo {
    
    id<HMServiceAPITrainingVideo>video = nil;
    
    NSArray *videos = self.hmjson[@"videos"].array;
    for (NSDictionary *aVideo in videos) {
        HMServiceAPITrainingUserGender gender = aVideo.hmjson[@"gender"].unsignedIntegerValue;
        
        // 发现匹配的性别视频立即返回
        if (gender == self.api_cachedTrainingUserGender) {
            return aVideo;
        }
        
        if (gender == HMServiceAPITrainingUserGenderBoth) {
            video = aVideo;
            continue;
        }
    }
    
    if (!video) {
        video = videos.firstObject;
    }
    
    return video;
}

@end

#pragma mark - Data

@interface NSDictionary (HMServiceAPITrainingData) <HMServiceAPITrainingData>
@end

@implementation NSDictionary (HMServiceAPITrainingData)

- (NSString *)api_trainingDataID {
    return [self.hmjson objectForPossibleKeys:@[@"trainingId", @"id"]].string;
}

- (NSUInteger)api_trainingDataOrder {
    return self.hmjson[@"sortOrder"].unsignedIntegerValue;
}

- (NSString *)api_trainingDataName {
    return self.hmjson[@"name"].string;
}

- (NSString *)api_trainingDataIntroduction {
    return self.hmjson[@"introduction"].string;
}

- (NSString *)api_trainingDataDetailImageURL {
    return self.hmjson[@"detailImgUrl"].string;
}

- (NSString *)api_trainingDataListImageURL {
    return [self.hmjson objectForPossibleKeys:@[@"listImgUrl", @"listPageIllustrated"]].string;
}

- (NSArray<id<HMServiceAPITrainingAction>> *)api_trainingDataActions {
    NSArray *actions = self.hmjson[@"content"].array;
    for (NSDictionary *action in actions) {
        if ([action isKindOfClass:[NSDictionary class]]) {
            action.api_cachedTrainingUserGender = self.api_cachedTrainingUserGender;
        }
    }
    return actions;
}

- (HMServiceAPITrainingDifficulty)api_trainingDataDifficulty {
    return self.hmjson[@"difficultyDegree"].unsignedIntegerValue;
}

- (NSTimeInterval)api_trainingDataDuration {
    NSDictionary *dictionary = self.hmjson[@"time"].dictionary;
    HMServiceAPITrainingUserGender gender = self.api_cachedTrainingUserGender;
    if (gender == HMServiceAPITrainingUserGenderMale) {
        return dictionary.hmjson[@"male"].doubleValue / 1000.f;
    }
    else {
        return dictionary.hmjson[@"female"].doubleValue / 1000.f;
    }
}

- (double)api_trainingDataEnergyBurnedInCalorie {
    return self.hmjson[@"consumption"].doubleValue * 1000.f;
}

- (NSArray<id<HMServiceAPITrainingBodyPart>> *)api_trainingDataBodyParts {
    return self.hmjson[@"location"].array;
}

- (id<HMServiceAPITrainingInstrument>)api_trainingDataInstrument {
    return self.hmjson[@"instrument"].dictionary;
}

- (id<HMServiceAPITrainingCoach>)api_trainingDataCoach {
    return self.hmjson[@"coach"].dictionary;
}

- (NSUInteger)api_trainingDataParticipantNumber {
    return self.hmjson[@"participantNumber"].unsignedIntegerValue;
}

- (NSUInteger)api_trainingDataFinishedTimesCount {
    return self.hmjson[@"finishNumber"].unsignedIntegerValue;
}

- (BOOL)api_trainingDataParticipated {
    return self.hmjson[@"isParticipate"].boolean;
}

@end


@implementation NSNumber (HMServiceAPITrainingFunction)

- (NSString *)hms_trainingFunctionTypeString {
    
    HMServiceAPITrainingFunctionType function = self.unsignedIntegerValue;
    NSParameterAssert(function == HMServiceAPITrainingFunctionShaping ||
                      function == HMServiceAPITrainingFunctionLoseFat ||
                      function == HMServiceAPITrainingFunctionBuildMuscle);
    
    switch (function) {
        case HMServiceAPITrainingFunctionShaping: return @"SHAPING";
        case HMServiceAPITrainingFunctionLoseFat: return @"LOSE_FAT";
        case HMServiceAPITrainingFunctionBuildMuscle: return @"INCREASE_MUSCLE";
    }
}

@end

@implementation NSNumber (HMServiceAPITrainingDifficulty)

- (NSString *)hms_trainingDifficultyString {
    
    HMServiceAPITrainingDifficulty difficulty = self.unsignedIntegerValue;
    NSParameterAssert(difficulty == HMServiceAPITrainingDifficultyJunior ||
                      difficulty == HMServiceAPITrainingDifficultyMiddle ||
                      difficulty == HMServiceAPITrainingDifficultyHigh);
    
    switch (difficulty) {
        case HMServiceAPITrainingDifficultyJunior: return @"JUNIOR_LEVEL";
        case HMServiceAPITrainingDifficultyMiddle: return @"MIDDLE_LEVEL";
        case HMServiceAPITrainingDifficultyHigh: return @"HIGH_LEVEL";
        case HMServiceAPITrainingDifficultyAny: return @"";
    }
}

@end
