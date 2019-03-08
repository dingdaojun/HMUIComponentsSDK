//  WVJBCommon.h
//  Created on 2018/5/16
//  Description 相关枚举

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#ifndef WVJBCommon_h
#define WVJBCommon_h

#define URL_JS_BRIDGE   @"https://aos-cdn.huami.com/hm-js-bridge/2.0.0/HM_JsBridge.js"
#define HMJSBridgeScriptSourcePrefix  @"var HM_JSBRIDGE_MD5=" // 与前端约定好的固定格式

#define DICT_ATTRIBUTE_FOR_KEY(DICT, KEY) ([[DICT objectForKey: KEY] isEqual: [NSNull null]] ? nil : [DICT objectForKey: KEY])
#define DICT_SETOBJECT_FOR_KEY(DICT,VALUE,KEY) ([VALUE isEqual: [NSNull null]]|| VALUE == nil ?[DICT  setObject:@"" forKey:key] : [DICT  setObject:VALUE forKey:KEY])

#define JBWechatPay     @"JBWechatPayNotification"
#define WEBLoadFail     @"WEBLoadFail"
#define WEB_DIDLOADTIME @"WEB_DIDLOADTIME"

/** Bracelet Type */
typedef NS_ENUM(NSUInteger, HMHtmlBraceletType) {
    HMHtmlBracelet_None,
    HMHtmlBracelet_Bind,
    HMHtmlBracelet_SetRightButtonVisible,
    HMHtmlBracelet_SetTitleContent,
    HMHtmlBracelet_SetTitleColor,
    HMHtmlBracelet_SetNavigationBgColor,
    HMHtmlBracelet_SetBackButtonAction,
    HMHtmlBracelet_Action,
    HMHtmlBracelet_Share,
    HMHtmlBracelet_ShareButton,
    HMHtmlBracelet_SetNavigationVisible,
    HMHtmlBracelet_ExitHtmlWebView,
    HMHtmlBracelet_SetStatusBarColor,
    HMHtmlBracelet_CheckAppInstalled,
    HMHtmlBracelet_Relogin,
    HMHtmlBracelet_Login,
    HMHtmlBracelet_InvalidLogin,
    HMHtmlBracelet_SetLeftButton,
    HMHtmlBracelet_OpenInBrowser,
};

/** jsBridge错误信息类别 */
typedef NS_ENUM(NSUInteger, JSErrorCode) {
    JSErrorCodeSuccess                            = 0,      // success
    JSErrorCodeInvalidJSON                        = 4000000,
    JSErrorCodeParamIsRequired                    = 4020000,
    JSErrorCodeVerifyError                        = 4020101,
    JSErrorCodeParamRGBMustBetween0to255          = 4020201,
    JSErrorCodeParamAMustBetween0to1              = 4020202,
    JSErrorCodeParamDisplayMustBeBool             = 4020301,
    JSErrorCodeUnknownButtonKey                   = 4040401,
    JSErrorCodeInvalidURL                         = 4010401,
    JSErrorCodeNotDefinedPosition                 = 4040601,
    JSErrorCodeUnknownFallbackEvent               = 4040602,
    JSErrorCodeFallbackEventOfPositionUnsupported = 4040603,
    JSErrorCodeNotRegisteredProtocol              = 4040701,
    JSErrorCodeUserHasNotLogin                    = 4030803,
    JSErrorCodeParamGlobalObjectIsRequired        = 4020501,
    JSErrorCodeParamTypeAndCaptureAreRequired     = 4020502,
    JSErrorCodeUnsupportedShareType               = 4040501,
    JSErrorCodeUnknownCaptureValue                = 4040502,
    JSErrorCodeUnsupportedSharePlatform           = 4040503,
    JSErrorCodeCannotUseImgUrlAsShareImage        = 4010501,
    JSErrorCodePlatformUnsupportShareType         = 4010502,
    JSErrorCodeShareTypeMissParameter             = 4010503,
    JSErrorCodeForbidLocate                       = 4030901,
    JSErrorCodeCannotGetLocation                  = 4040902,
    JSErrorCodeDeviceDisConnected                 = 4021201,//设备失去连接
    JSErrorCodeDeviceInfoSyncError                = 4021202,//设备信息写入失败
    JSErrorCodeDeviceNotSupport                   = 4021203,//设备不支持
    JSErrorCodeDeviceFwVersionLow                 = 4021204,//固件版本低
    JSErrorCodeDeviceBand2NotSupport              = 4021205,//不支持的二代手环(此设备的子型号不支持（如：小米手环2 中的一些批次设备)
    JSErrorCodeDeviceNotBinded                    = 4021206,//设备未绑定
    JSErrorCodeDialNetWorkDisConnect              = 4000001,// Network is disconnected
    JSErrorCodeDialMissConnecting                 = 4041001,// Miss connecting
    JSErrorCodeDialDownloadFailed                 = 4001001,// Download failed
    JSErrorCodeDialSyncFailure                    = 4001002,// Sync failure
};

/** content type */
typedef NS_ENUM(NSInteger, JBContentType) {
    JBContentTypeLocation = 0,  //定位信息
    JBContentTypeUserToken,     //用户token
    JBContentTypeDeviceInfo,    //设备信息
    JBContentTypeUserInfo,      //用户信息
};

typedef NS_ENUM(NSInteger, LoginType) {
    Login = 0,  //登录
    QuitLogin,  //退出登录
};

/**
 *  @brief  定义了第三方分享的场景
 */
typedef NS_ENUM(NSUInteger, SSScene) {
    SSSceneWXSession,     /**< 聊天界面       */
    SSSceneWXTimeline,    /**< 朋友圈         */
    SSSceneQQFrined,      /**< QQ好友         */
    SSSceneQZone,         /**< QQ空间         */
    SSSceneSina,          /**< 新浪微博        */
    SSSceneFacebook,      /**< Facebook       */
    SSSceneTwitter,       /**< Twitter        */
    SSSceneLine,          /**< Line           */
    SSSceneInstagram,     /**< Instagram      */
};

/**
 *  @brief  定义了第三方分享类型
 */
typedef NS_ENUM(NSUInteger, SSContentType) {
    SSContentTypeText,        /**< 纯文本 */
    SSContentTypeImage,       /**< 图片 */
    SSContentTypeWebPage,     /**< 网页 */
};


#endif /* WVJBCommon_h */
