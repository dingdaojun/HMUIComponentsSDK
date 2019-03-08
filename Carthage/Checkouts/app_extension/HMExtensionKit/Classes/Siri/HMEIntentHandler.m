//
//  HMEIntentHandler.m
//  Pods
//
//  Created by 江杨 on 15/05/2017.
//
//

#import "HMEIntentHandler.h"


@implementation HMEIntentHandler

#pragma mark - INStartWorkoutIntentHandling
- (void)resolveWorkoutNameForStartWorkout:(INStartWorkoutIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion{
    INSpeakableStringResolutionResult *result = nil;
    INSpeakableString *workoutName = intent.workoutName;
    if (workoutName) {
        if ([self validateWorkoutNameSpokenPhrase:workoutName.spokenPhrase]) {
            result = [INSpeakableStringResolutionResult successWithResolvedString:workoutName];
        } else {
            INSpeakableString *possible1 = [[INSpeakableString alloc] initWithIdentifier:@"startRun" spokenPhrase:@"室内跑步" pronunciationHint:@"shi4 nei4 pao3 bu4"];
            INSpeakableString *possible2 = [[INSpeakableString alloc] initWithIdentifier:@"startRun" spokenPhrase:@"户外跑步" pronunciationHint:@"hu4 wai4 pao3 bu4"];

            result = [INSpeakableStringResolutionResult disambiguationWithStringsToDisambiguate:@[possible1, possible2]];
        }
    } else {
        result = [INSpeakableStringResolutionResult needsValue];
    }
    completion(result);
}

- (void)handleStartWorkout:(INStartWorkoutIntent *)intent completion:(void (^)(INStartWorkoutIntentResponse * _Nonnull))completion{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INStartWorkoutIntent class])];
    NSNumber *runType = [NSNumber numberWithInteger:[self getRunTypeWithSpokenPhrase:intent.workoutName.spokenPhrase]];
    NSDictionary *userInfo = @{@"runType":runType};
    userActivity.userInfo = userInfo;
    INStartWorkoutIntentResponse *response = [[INStartWorkoutIntentResponse alloc] initWithCode:INStartWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INEndWorkoutIntentHandling
- (void)resolveWorkoutNameForEndWorkout:(INEndWorkoutIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion{
    INSpeakableStringResolutionResult *result = nil;
    INSpeakableString *workoutName = intent.workoutName;
    if (workoutName) {
        result = [INSpeakableStringResolutionResult successWithResolvedString:workoutName];
    } else {
        result = [INSpeakableStringResolutionResult needsValue];
    }
    completion(result);
}

- (void)handleEndWorkout:(INEndWorkoutIntent *)intent completion:(void (^)(INEndWorkoutIntentResponse * _Nonnull))completion{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INEndWorkoutIntent class])];
    NSDictionary *userInfo = @{@"runType":@(HMESiriCommandStop)};
    userActivity.userInfo = userInfo;
    INEndWorkoutIntentResponse *response = [[INEndWorkoutIntentResponse alloc] initWithCode:INEndWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INPauseWorkoutIntentHandling
- (void)resolveWorkoutNameForPauseWorkout:(INPauseWorkoutIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion{
    INSpeakableStringResolutionResult *result = nil;
    INSpeakableString *workoutName = intent.workoutName;
    if (workoutName) {
        result = [INSpeakableStringResolutionResult successWithResolvedString:workoutName];
    } else {
        result = [INSpeakableStringResolutionResult needsValue];
    }
    completion(result);
}

- (void)handlePauseWorkout:(INPauseWorkoutIntent *)intent completion:(void (^)(INPauseWorkoutIntentResponse * _Nonnull))completion{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INEndWorkoutIntent class])];
    NSDictionary *userInfo = @{@"runType":@(HMESiriCommandPause)};
    userActivity.userInfo = userInfo;
    INPauseWorkoutIntentResponse *response = [[INPauseWorkoutIntentResponse alloc] initWithCode:INPauseWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INResumeWorkoutIntentHandling
- (void)resolveWorkoutNameForResumeWorkout:(INResumeWorkoutIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion{
    INSpeakableStringResolutionResult *result = nil;
    INSpeakableString *workoutName = intent.workoutName;
    if (workoutName) {
        result = [INSpeakableStringResolutionResult successWithResolvedString:workoutName];
    } else {
        result = [INSpeakableStringResolutionResult needsValue];
    }
    completion(result);
}

- (void)handleResumeWorkout:(INResumeWorkoutIntent *)intent completion:(void (^)(INResumeWorkoutIntentResponse * _Nonnull))completion{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INEndWorkoutIntent class])];
    NSDictionary *userInfo = @{@"runType":@(HMESiriCommandResume)};
    userActivity.userInfo = userInfo;
    INResumeWorkoutIntentResponse *response = [[INResumeWorkoutIntentResponse alloc] initWithCode:INResumeWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - INCancelWorkoutIntentHandling
- (void)resolveWorkoutNameForCancelWorkout:(INCancelWorkoutIntent *)intent withCompletion:(void (^)(INSpeakableStringResolutionResult * _Nonnull))completion{
    INSpeakableStringResolutionResult *result = nil;
    INSpeakableString *workoutName = intent.workoutName;
    if (workoutName) {
        result = [INSpeakableStringResolutionResult successWithResolvedString:workoutName];
    } else {
        result = [INSpeakableStringResolutionResult needsValue];
    }
    completion(result);
}

- (void)handleCancelWorkout:(INCancelWorkoutIntent *)intent completion:(void (^)(INCancelWorkoutIntentResponse * _Nonnull))completion{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INEndWorkoutIntent class])];
    NSDictionary *userInfo = @{@"runType":@(HMESiriCommandCancel)};
    userActivity.userInfo = userInfo;
    INCancelWorkoutIntentResponse *response = [[INCancelWorkoutIntentResponse alloc] initWithCode:INCancelWorkoutIntentResponseCodeContinueInApp userActivity:userActivity];
    completion(response);
}

#pragma mark - private
- (BOOL)validateWorkoutNameSpokenPhrase:(NSString*)phrase{
    if ([phrase containsString:@"室内"] || [phrase containsString:@"户外"]) {
        return YES;
    } else {
        return NO;
    }
}

- (HMESiriCommandType)getRunTypeWithSpokenPhrase:(NSString*)phrase{
    if ([phrase containsString:@"室内"]) {
        return HMESiriCommandIndoorStart;
    } else {
        return HMESiriCommandOutdoorStart;
    }
}

@end
