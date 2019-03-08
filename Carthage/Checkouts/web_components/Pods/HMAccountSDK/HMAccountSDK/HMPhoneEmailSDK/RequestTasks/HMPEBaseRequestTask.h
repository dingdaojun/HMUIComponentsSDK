//
//  HMPEBaseRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <DDWebService/WSRequestTask.h>
#import "HMPETypes.h"
#import "HMAccountTools.h"

@interface HMPEBaseRequestTask : WSRequestTask

/**
 注册类型,本地用于区分是邮箱还是手机号
 */
@property (nonatomic, assign) HMPEAccountType accountType;

/**
 当前账号
 */
@property (nonnull, readonly) NSString *account;

/**
 创建一个HMPEBaseRequestTask子类实例

 @param areaCode 手机区号，邮箱则不传
 @param account 账号：邮箱 or 手机号
 @param region  国家地区码，https://en.wikipedia.org/wiki/ISO_3166-1，采用国际标准
 @return HMPEBaseRequestTask子类实例
 */
- (nonnull instancetype)initWithAreaCode:(nullable NSString *)areaCode
                                 account:(nonnull NSString *)account
                                  region:(nullable NSString *)region;

/**
 服务器请求成功返回的数据
 
 @param infoDict NSDictionary
 */
- (void)parseResponseHanlderWithDictionary:(NSDictionary *_Nonnull)infoDict NS_REQUIRES_SUPER;


//- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;
+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;
@end
