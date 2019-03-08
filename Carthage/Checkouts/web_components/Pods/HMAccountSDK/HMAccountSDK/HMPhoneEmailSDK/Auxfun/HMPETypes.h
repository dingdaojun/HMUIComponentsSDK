//
//  HMPETypes.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#ifndef HMPETypes_h
#define HMPETypes_h

/**token 选项参数*/
typedef NSString * HMPETokenOptionsKey;

/**获取accessToken*/
static HMPETokenOptionsKey const HMPETokenOptionsKeyAccess  = @"access";
/**获取refreshToken*/
static HMPETokenOptionsKey const HMPETokenOptionsKeyRefresh = @"refresh";

/**state 选项参数*/
typedef NSString * HMPEStateOptionsKey;

/**重定向解析(REDIRECTION)*/
static HMPEStateOptionsKey const HMPEStateOptionsKeyRedirection  = @"REDIRECTION";
/**只返回状态(STATE)*/
static HMPEStateOptionsKey const HMPEStateOptionsKeyState = @"STATE";


/**marketing 选项参数*/
typedef NSString * HMPEMarketingOptionsKey;

/**华米*/
static HMPEMarketingOptionsKey const HMPEMarketingOptionsKeyHuami = @"huami";
/**AMAZFIT*/
static HMPEMarketingOptionsKey const HMPEMarketingOptionsKeyAmazfit = @"amazfit";


typedef NSString HMPEImageCodeType;
/**注册验证码*/
static HMPEImageCodeType *HMPEImageCodeTypeRegister = @"register";
/**重置密码验证码*/
static HMPEImageCodeType *HMPEImageCodeTypeFindPassword = @"findPassword";

typedef NSString HMPECodeType;
/**注册验证码*/
static HMPECodeType *HMPECodeTypeRegister = @"register";
/**重置密码验证码*/
static HMPECodeType *HMPECodeTypeFindPassword = @"findPassword";

/**
 注册登录类型

 - HMPEAccountTypeUnkown: 未知类型
 - HMPEAccountTypePhone: 手机号
 - HMPEAccountTypeEmail: 邮箱
 */
typedef NS_ENUM(NSInteger, HMPEAccountType) {
    HMPEAccountTypeUnkown = -1,
    HMPEAccountTypePhone  = 0,
    HMPEAccountTypeEmail  = 1,
};

#endif /* HMPETypes_h */
