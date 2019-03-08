//  WVJBUtils.m
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "WVJBUtils.h"

NSString *const JSBridgeShareTypeCard = @"card";// 卡片类型 包含 title, desc, link, image (imageUrl or Screen capture)
NSString *const JSBridgeShareTypeImage = @"image";// 图片类型 只分享图片 (imageUrl or Screen capture)
NSString *const JSBridgeShareTypeText = @"text";// 纯文本内容    不含链接和图片的纯文本内容
NSString *const JSBridgeShareTypeMix = @"mix";// 混杂文本内容 不含图片的文本/链接内容

@implementation WVJBUtils

+ (NSString *)getAppLaunguage {
    NSString *localization = [[[NSBundle bundleForClass:[self class]] preferredLocalizations] firstObject];
    NSDictionary *dict = [NSLocale componentsFromLocaleIdentifier:localization];
    
    NSString *lan = dict[NSLocaleLanguageCode];
    if (lan.length == 0) {
        lan = @"en";
    }
    NSString *script = dict[NSLocaleScriptCode];
    if (! script) {
        script = @"";
    }
    NSMutableString *retStr = [NSMutableString string];
    [retStr appendString:lan];
    if (script.length) {
        [retStr appendFormat:@"-%@", script];
    }
    return [retStr copy];
}

+ (NSString *)getErrorMsgWithCode:(JSErrorCode)errorCode {
    NSDictionary *resultDic = @{
                                @"errorCode": [NSString stringWithFormat:@"%lu",errorCode],
                                @"errorMessage": [WVJBUtils errorMesageWithCode:errorCode]
                                };
    NSString *errorStr = [WVJBUtils JSONWithDict:resultDic];
    return errorStr;
}

+ (NSString *)JSONWithDict:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (!jsonData) {
        return @"{}";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (BOOL)isValidURL:(NSString *)url {
    NSString *regex = @"^(http|https)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&%\\$\\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.[a-zA-Z]{2,4})(\\:[0-9]+)?(/[^/][a-zA-Z0-9\\.\\,\\?\\'\\\\/\\+&%\\$\\=~_\\-@]*)*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:url];
    return isValid;
}

+ (void)JBSuccessCallBack:(WVJBResponseCallback)callBack {
    NSDictionary *resultDic = @{ @"status": @"success" };
    NSString *resultString = [self JSONWithDict:resultDic];
    callBack(resultString);
}

+ (void)JBErrorWithCode:(JSErrorCode)errorCode callBack:(WVJBResponseCallback)callBack {
    NSString *errorMessage = [self getErrorMsgWithCode:errorCode];
    NSDictionary *resultDic = @{
                                @"errorCode": [NSString stringWithFormat:@"%lu",JSErrorCodeInvalidJSON],
                                @"errorMessage": errorMessage,
                                };
    NSString *resultString = [self JSONWithDict:resultDic];
    callBack(resultString);
}

+ (void)JBErrorWithMsg:(NSDictionary *)errorMsg callBack:(WVJBResponseCallback)callBack {
    NSString *resultString = [self JSONWithDict:errorMsg];
    callBack(resultString);
}

+ (NSString *)errorMesageWithCode:(JSErrorCode)errorCode {
    switch (errorCode) {
        case JSErrorCodeParamIsRequired:
            return @"Param requiredkey is required.";
        case JSErrorCodeVerifyError:
            return @"Verify sign error.";
        case JSErrorCodeParamDisplayMustBeBool:
            return @"Parameter 'display' must be bool.";
        case JSErrorCodeInvalidURL:
            return @"Invalid url";
        case JSErrorCodeUnknownButtonKey:
            return @"Unknown button key.";
        case JSErrorCodeParamGlobalObjectIsRequired:
            return @"Param global object is required.";
        case JSErrorCodeNotDefinedPosition:
            return @"Not defined";
        case JSErrorCodeUnknownFallbackEvent:
            return @"Unknown the fallbackEvent value";
        case JSErrorCodeFallbackEventOfPositionUnsupported:
            return @"The navigationEvent of position navigationPosition is unsupported";
        case JSErrorCodeNotRegisteredProtocol:
            return @"This protocol is not registered";
        case JSErrorCodeForbidLocate:
            return @"Getting location is forbidden.";
        case JSErrorCodeCannotGetLocation:
            return @"Location is null.";
        case JSErrorCodeParamRGBMustBetween0to255:
            return @"Parameter 'r','g','b' must be int between 0 to 255.";
        case JSErrorCodeParamAMustBetween0to1:
            return @"Parameter 'a' must be float between 0 to 1.";
        case JSErrorCodeDialNetWorkDisConnect:
            return @"Network is disconnected.";
        case JSErrorCodeDialMissConnecting:
            return @"Miss connecting.";
        case JSErrorCodeDialDownloadFailed:
            return @"Download failed.";
        case JSErrorCodeDialSyncFailure:
            return @"Sync failure.";
        case JSErrorCodeDeviceDisConnected:
            return @"Miss connecting.";
        case JSErrorCodeDeviceInfoSyncError:
            return @"Sync error.";
        case JSErrorCodeDeviceNotSupport:
            return @"Device is not supported.";
        case JSErrorCodeDeviceFwVersionLow:
            return @"Firmware version is low.";
        case JSErrorCodeDeviceBand2NotSupport:
            return @"Device's sub models is not supported.";
        case JSErrorCodeDeviceNotBinded:
            return @"Miss binding.";
        case JSErrorCodeUserHasNotLogin:
            return @"User has not login.";
        case JSErrorCodeUnsupportedSharePlatform:
            return @"Unsupported social in especial config";
        case JSErrorCodeParamTypeAndCaptureAreRequired:
            return @"Param type and capture are required.";
        case JSErrorCodeUnknownCaptureValue:
            return @"Unknown capture value, just support 0, 1, 2.";
        case JSErrorCodeUnsupportedShareType:
            return @"Unsupported type, just support {{card, image, text, mix}}.";
        case JSErrorCodeCannotUseImgUrlAsShareImage:
            return @"Cannot use 'imgUrl' as share image.";
        case JSErrorCodeShareTypeMissParameter:
            return @"Share type require use missingParameter.";
        case JSErrorCodePlatformUnsupportShareType:
            return @"cannot support share type.";
        default:
            return @"error";
    }
}

+ (NSString *)JSFileContentFromNative {
    NSString *jsBridgeSource = [[NSUserDefaults standardUserDefaults] objectForKey:@"HM_JsBridge"];
    if (jsBridgeSource) {
        return jsBridgeSource;
    } else {
        NSString *jsBridgePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"HM_JsBridge" ofType:@"js"];
        return [NSString stringWithContentsOfFile:jsBridgePath encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (void)updateNativeJS {
    NSString *jsBridgeScriptSource = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:URL_JS_BRIDGE] encoding:NSUTF8StringEncoding error:nil];
    if ([jsBridgeScriptSource hasPrefix:HMJSBridgeScriptSourcePrefix]) {
        [[NSUserDefaults standardUserDefaults] setObject:jsBridgeScriptSource forKey:@"HM_JsBridge"];
    }
}

@end
