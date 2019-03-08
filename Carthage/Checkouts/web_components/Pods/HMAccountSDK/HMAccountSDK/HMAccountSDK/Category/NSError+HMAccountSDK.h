//
//  NSError+HMAccountSDK.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

//Error UserInfo中具体服务器返回的原始错误信息
FOUNDATION_EXTERN NSString * _Nonnull const HMIDErrorUserInfoResponseKey;

/**
 账号系统错误码
 
 - HMIDErrorTypeStandard:        标准错误     000
 - HMIDErrorTypeNeedLogin:       需要重新登录  401
 - HMIDErrorTypeMutexLogin:      互斥登录     108
 - HMIDErrorTypeBannedAccount:   账号被封禁或不可用    114/115
 */
typedef NS_ENUM(NSInteger, HMIDErrorType) {
    HMIDErrorTypeStandard            = 200000,
    HMIDErrorTypeMutexLogin          = 200108,
    HMIDErrorTypeNeedLogin           = 200401,
    HMIDErrorTypeBannedAccount       = 200500,
};

@interface NSError (HMAccountSDK)

@property (nonatomic, assign) HMIDErrorType idErrorType;

/**
 当且仅当HMIDErrorTypeMutexLogin时有效
 */
@property (nonatomic, assign) uint64_t idMutime;

/**
 当且仅当HMIDErrorTypeBannedAccount时有效
 */
@property (nullable, nonatomic, copy) NSArray *idNextAction;

/**
 请求结束后的HTTPURLResponse，可为nil
 */
@property (nullable, nonatomic, strong) NSHTTPURLResponse *idhttpURLResponse;
/**
 请求的IP地址，可为nil
 */
@property (nullable, nonatomic, copy) NSString *idIpAddress;

+ (nonnull instancetype)idErrorWithIDResponseObject:(nullable NSDictionary *)responseObject;

@end
