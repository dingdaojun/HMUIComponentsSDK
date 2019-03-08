//
//  HMAccountSDK.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMAccountConfig.h"
#import "HMIDAuthItem.h"
#import "HMIDLoginItem.h"
#import "HMIDBindItem.h"
#import "HMIDTypeDefs.h"
#import "HMIDConstants.h"
#import "NSError+HMAccountSDK.h"

/**
 账号系统派遣中心
 */
@interface HMAccountSDK : NSObject

/**
 线下账号系统申请的appname

 @return NSString
 */
+ (NSString *)appName;

/**
 当前登录账户的唯一ID

 @return NSString
 */
+ (NSString *)userId;

/**
 账号系统中使用的设备的唯一标识

 @return NSString
 */
+ (NSString *)uniqueDeviceIdentifier;

/**
 refresh token,使用该token可以兑换apptoken

 @return NSString
 */
+ (NSString *)loginToken;

/**
 获取apptoken

 @param eventHandler 获取token回调方法
 */
+ (void)getAppTokenEventHandler:(HMIDAppTokenEventHandler)eventHandler;

/**
 判断用户是否登录，并没有判断登录有没有过期

 @return YES ？ 已经登录 ：没有登录
 */
+ (BOOL)isLogin;

/**
 针对小米运动设定的升级接口

 @param platForm 登陆的平台
 @param isCN 是否是国内用户
 @param authItem 三方授权信息
 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)loginWithPlatform:(HMIDLoginPlatForm)platForm
                     isCN:(BOOL)isCN
                 authItem:(HMIDAuthItem *)authItem
             eventHandler:(HMIDLoginEventHandler)eventHandler;

/**
 接入华米账号系统登录

 @param platForm 登陆的平台
 @param region 国家区域码，eg US，HK....,System->Settings->Languages & Regions
 @param authItem 三方授权信息
 @param eventHandler 登录回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)loginWithPlatform:(HMIDLoginPlatForm)platForm
                   region:(NSString *)region
                 authItem:(HMIDAuthItem *)authItem
             eventHandler:(HMIDLoginEventHandler)eventHandler;

/**
 接入华米账号系统登录

 @param thirdname 线下在账号系统中申请的第三方名称
 @param region 国家区域码，eg US，HK....,System->Settings->Languages & Regions
 @param grantType 不同平台接入方式不同 @see HMIDTokenGrantTypeOptionKey
 @param authItem 三方授权信息
 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)loginWithThirdname:(NSString *)thirdname
                    region:(NSString *)region
                 grantType:(HMIDTokenGrantTypeOptionKey)grantType
                  authItem:(HMIDAuthItem *)authItem
              eventHandler:(HMIDLoginEventHandler)eventHandler;

/**
 验证apptoken的有效性

 @param eventHandler 验证回调结果
 @return YES？发送成功：发送失败
 */
+ (BOOL)verifyAppTokenEventHandler:(HMIDEventHandler)eventHandler;

/**
 重新刷新appToken

 @param eventHandler 刷新回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)refreshApptokenEventHandler:(HMIDAppTokenEventHandler)eventHandler;

/**
 重新登录账号系统

 @param eventHandler 登录回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)reLoginEventHandler:(HMIDAppTokenEventHandler)eventHandler;

/**
 退出账号系统

 @param force 是否强制退出登录,YES?退出失败也会清除本地登录信息
 @param eventHandler 退出回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)logoutForce:(BOOL)force eventHandler:(HMIDEventHandler)eventHandler;

/**
 强制所有已登录的app退出登录,调用改接口的app必须保证已经登录

 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)allAppForceEventHandler:(HMIDEventHandler)eventHandler;

/**
 绑定指定的账号

 @param platForm 绑定平台
 @param code 获取的账号授权code
 @param region 国家区域码
 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)bindWithPlatForm:(HMIDLoginPlatForm)platForm
                    code:(NSString *)code
                  region:(NSString *)region
            eventHandler:(HMIDBindEventHandler)eventHandler;

/**
 解绑指定账号

 @param platForm 绑定平台
 @param thirdId 三方的id
 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)unbindWithPlatForm:(HMIDLoginPlatForm)platForm
                   thirdId:(NSString *)thirdId
              eventHandler:(HMIDEventHandler)eventHandler;

/**
 获取当前登录账号已绑定的所有账号

 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)getAllBindAccountWithEventHandler:(HMIDBindListEventHandler)eventHandler;


/**
 手机号登录的用户，获取当前用户登录的手机号

 @param eventHandler 回调
 @return YES？发送成功：发送失败
 */
+ (BOOL)getPhoneNumberWithEventHandler:(void(^)(NSString *phoneNumber, NSError *error))eventHandler;





- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
@end
