//
//  HMIDTypeDefs.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#ifndef HMIDTypeDefs_h
#define HMIDTypeDefs_h

@class HMIDAppTokenItem;
@class HMIDLoginItem;
@class HMIDBindItem;

/**
 账号系统通用带错误信息的回调

 @param error 错误信息
 */
typedef void(^HMIDEventHandler) (NSError *error);

/**
 登录账号系统回调信息

 @param loginItem HMIDLoginItem
 @param error 错误信息
 */
typedef void(^HMIDLoginEventHandler) (HMIDLoginItem *loginItem, NSError *error);

/**
 获取刷新AppToken的回调函数

 @param tokenItem HMIDAppTokenItem
 @param error 错误信息
 */
typedef void(^HMIDAppTokenEventHandler) (HMIDAppTokenItem *tokenItem, NSError *error);

/**
 绑定账号回调

 @param bindItem HMIDBindItem
 @param error 错误信息
 */
typedef void(^HMIDBindEventHandler) (HMIDBindItem *bindItem, NSError *error);

/**
 获取已绑定的账号回调

 @param bindItems 一组HMIDBindItem
 @param error 错误信息
 */
typedef void(^HMIDBindListEventHandler) (NSArray <HMIDBindItem *> *bindItems, NSError *error);

/**
 账号系统支持的登录平台

 - HMIDLoginPlatFormUnkown:     未知
 - HMIDLoginPlatFormMI:         小米         HMIDTokenGrantTypeOptionKeyRequestToken
 - HMIDLoginPlatFormWeChat:     微信         HMIDTokenGrantTypeOptionKeyRequestToken
 - HMIDLoginPlatFormFacebook:   facebook    HMIDTokenGrantTypeOptionKeyAccessToken
 - HMIDLoginPlatFormGoogle:     Google      HMIDTokenGrantTypeOptionKeyRequestToken
 - HMIDLoginPlatFormEmail:      Email       HMIDTokenGrantTypeOptionKeyAccessToken
 - HMIDLoginPlatFormPhone:      手机号       HMIDTokenGrantTypeOptionKeyAccessToken
 - HMIDLoginPlatFormLine:       Line        HMIDTokenGrantTypeOptionKeyAccessToken
 */
typedef NS_ENUM(NSInteger, HMIDLoginPlatForm) {
    HMIDLoginPlatFormUnkown,         
    HMIDLoginPlatFormMI,             
    HMIDLoginPlatFormWeChat,         
    HMIDLoginPlatFormFacebook,       
    HMIDLoginPlatFormGoogle,         
    HMIDLoginPlatFormEmail,          
    HMIDLoginPlatFormPhone,
    HMIDLoginPlatFormLine,
};

#endif /* HMIDTypeDefs_h */
