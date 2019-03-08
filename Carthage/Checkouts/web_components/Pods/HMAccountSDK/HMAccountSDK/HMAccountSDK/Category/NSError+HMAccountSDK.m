//
//  NSError+HMAccountSDK.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "NSError+HMAccountSDK.h"
#import <objc/runtime.h>

NSString * const HMIDErrorUserInfoResponseKey = @"response";

static const void *HMIDErrorMainCodeKey = &HMIDErrorMainCodeKey;

static const void *HMIDErrorMutimeKey = &HMIDErrorMutimeKey;

static const void *HMIDErrorNextAction = &HMIDErrorNextAction;

static const void *HMIDErrorHTTPURLResponseKey = &HMIDErrorHTTPURLResponseKey;

static const void *HMIDErrorIPAddressKey = &HMIDErrorIPAddressKey;

void HMIDSwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation NSError (HMAccountSDK)

+ (void)load {
    HMIDSwizzleMethod([self class], @selector(description), @selector(hmId_description));
    HMIDSwizzleMethod([self class], @selector(debugDescription), @selector(hmId_debugDescription));
}

+ (instancetype)idErrorWithIDResponseObject:(nullable NSDictionary *)responseObject{
    NSString *errorCode = responseObject[@"code"];
    uint64_t mutime = 0;
    if ([errorCode isEqualToString:@"0108"]) {
        mutime = [responseObject[@"mutime_long"] longLongValue];
        NSError *error = [NSError errorWithDomain:@"HMAcount Mutex Domain" code:[errorCode integerValue] userInfo:@{NSLocalizedDescriptionKey:@"Mutex login failure (0108)",@"response":responseObject}];
        error.idErrorType = HMIDErrorTypeMutexLogin;
        error.idMutime = mutime;
        return error;
    } else if ([errorCode isEqualToString:@"0114"] || [errorCode isEqualToString:@"0115"]) {
        NSString *localizedDescriptionKey = @"";
        if ([errorCode isEqualToString:@"0114"]){
            localizedDescriptionKey = @"Disable app login (0114)";
        } else if ([errorCode isEqualToString:@"0115"]){
            localizedDescriptionKey = @"Account is disabled (0115)";
        }
        NSError *error = [NSError errorWithDomain:@"HMAcount Banned Domain" code:[errorCode integerValue] userInfo:@{NSLocalizedDescriptionKey:localizedDescriptionKey,@"response":responseObject}];
        error.idErrorType = HMIDErrorTypeBannedAccount;
        error.idNextAction = responseObject[@"nextActions"];
        return error;
    } else {
        NSString *localizedDescriptionKey = @"";
        if ([errorCode isEqualToString:@"0100"]) {
            localizedDescriptionKey = @"Invalid request data, e.g. null required data or wrong data format (0100)";
        } else if ([errorCode isEqualToString:@"0101"]){
            localizedDescriptionKey = @"Invalid app_name (0101)";
        } else if ([errorCode isEqualToString:@"0102"]){
            localizedDescriptionKey = @"Invalid app_token (0102)";
        } else if ([errorCode isEqualToString:@"0103"]){
            localizedDescriptionKey = @"Invalid verification code (0103)";
        } else if ([errorCode isEqualToString:@"0105"]){
            localizedDescriptionKey = @"Invalid login_token (0105)";
        } else if ([errorCode isEqualToString:@"0106"]){
            localizedDescriptionKey = @"Three party verification failure (0106)";
        } else if ([errorCode isEqualToString:@"0107"]){
            localizedDescriptionKey = @"Registration failure (0107)";
        } else if ([errorCode isEqualToString:@"0109"]){
            localizedDescriptionKey = @"Invalid third id (0109)";
        } else if ([errorCode isEqualToString:@"0110"]){
            localizedDescriptionKey = @"Third bond not found (0110)";
        } else if ([errorCode isEqualToString:@"0111"]){
            localizedDescriptionKey = @"Third id already bonded (0111)";
        } else if ([errorCode isEqualToString:@"0112"]){
            localizedDescriptionKey = @"Can't unbond because of one thirdBond left (0112)";
        } else if ([errorCode isEqualToString:@"0113"]){
            localizedDescriptionKey = @"Can't register user in this region (0113)";
        }
        NSError *error = [NSError errorWithDomain:@"HMAcount NeedLogin Domain" code:[errorCode integerValue] userInfo:@{NSLocalizedDescriptionKey:localizedDescriptionKey,@"response":responseObject}];
        error.idErrorType = HMIDErrorTypeNeedLogin;
        return error;
    }
}

- (NSString *)hmId_description {
    NSString *description = [self hmId_description];
    if (self.idIpAddress) {
        description = [description stringByAppendingFormat:@"\nIP:%@",self.idIpAddress];
    }
    if (self.idhttpURLResponse) {
        description = [description stringByAppendingFormat:@"\nURLResponse:%@",self.idhttpURLResponse];
    }
    return description;
}

- (NSString *)hmId_debugDescription {
    NSString *description = [self hmId_debugDescription];
    if (self.idIpAddress) {
        description = [description stringByAppendingFormat:@"\nIP:%@",self.idIpAddress];
    }
    if (self.idhttpURLResponse) {
        description = [description stringByAppendingFormat:@"\nURLResponse:%@",self.idhttpURLResponse];
    }
    return description;
}

#pragma mark -  Getter and Setter

- (HMIDErrorType)idErrorType{
    HMIDErrorType errorType = [objc_getAssociatedObject(self, HMIDErrorMainCodeKey) integerValue];
    if (errorType == 0) {
        errorType = HMIDErrorTypeStandard;
    }
    return errorType;
}

- (void)setIdErrorType:(HMIDErrorType)idErrorType{
    objc_setAssociatedObject(self, HMIDErrorMainCodeKey, @(idErrorType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (uint64_t)idMutime{
    return [objc_getAssociatedObject(self, HMIDErrorMutimeKey) longLongValue];
}

- (void)setIdMutime:(uint64_t)idMutime{
    objc_setAssociatedObject(self, HMIDErrorMutimeKey, @(idMutime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIdNextAction:(NSArray *)idNextAction {
    objc_setAssociatedObject(self, HMIDErrorNextAction, idNextAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)idNextAction {
    return objc_getAssociatedObject(self, HMIDErrorNextAction);
}

- (void)setIdhttpURLResponse:(NSHTTPURLResponse *)idhttpURLResponse {
    objc_setAssociatedObject(self, HMIDErrorHTTPURLResponseKey, idhttpURLResponse, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHTTPURLResponse *)idhttpURLResponse {
    return objc_getAssociatedObject(self, HMIDErrorHTTPURLResponseKey);
}

- (void)setIdIpAddress:(NSString *)idIpAddress {
    objc_setAssociatedObject(self, HMIDErrorIPAddressKey, idIpAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)idIpAddress {
    return objc_getAssociatedObject(self, HMIDErrorIPAddressKey);
}
@end
