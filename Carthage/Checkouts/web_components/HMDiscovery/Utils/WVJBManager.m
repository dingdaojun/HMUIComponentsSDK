//  WVJBManager.m
//  Created on 2018/5/16
//  Description webView JSBridge Manager.

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "WVJBManager.h"
#import <ADSupport/AdSupport.h>
#import <CoreLocation/CoreLocation.h>
#import "WVJBUtils.h"
@import ReactiveObjC;
@import MIFitService;
@import HMLog;

typedef void (^handlerCallBack)(NSDictionary *rootDict, WVJBResponseCallback responseCallback);

@interface WVJBManager ()

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation WVJBManager

- (instancetype)initWithJSBridge:(WKWebViewJavascriptBridge *)JSBridge {
    self = [super init];
    if (self) {
        self.bridge = JSBridge;
        // 默认状态值
        self.isShareButtonDisplay = NO;
        self.navigationVisible = YES;
        self.isAuthorizeButtonDisplay = NO;
    }
    return self;
}

- (void)dealloc {
    HMLogD(discovery,@"WVJBManager 释放了.");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bridge setWebViewDelegate:nil];
    _bridge = nil;
}

- (void)registerJSApiWithURL:(NSString *)URLString isNeedAuth:(BOOL)isNeedAuth {
    [self verifyJSApiWithURL:URLString];
    if (!isNeedAuth) {
        [self registerJSApi:[self JSApis]];
    }
}

/** 网络校验JSApi */
- (void)verifyJSApiWithURL:(NSString *)URLString {
    NSRange range = [URLString rangeOfString:@"#"];
    if (range.location != NSNotFound) {
        URLString = [URLString substringToIndex:range.location];
    }
    @weakify(self);
    [self regActionJSAPIHandler:@"preVerifyJsApi" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSArray *requiredkeys = @[@"appkey", @"timestamp", @"nonceStr", @"signature"];
        
        for (NSString *requiredkey in requiredkeys) {
            id value = rootDict[requiredkey];
            BOOL isStringClass = [value isKindOfClass:[NSString class]];
            if (!isStringClass) {
                NSString *tmp = [NSString stringWithFormat:@"%@",value];
                [rootDict setValue:tmp forKey:requiredkey];
            }
            if (!value || (isStringClass && [value isEqualToString:@""])) {
                [WVJBUtils JBErrorWithCode:JSErrorCodeParamIsRequired callBack:responseCallback];
                return;
            }
        }
        
        if (![rootDict[@"jsApiList"] isKindOfClass:[NSArray class]]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeInvalidJSON callBack:responseCallback];
            return;
        }
        
        //请求js授权验证
        [[HMServiceAPI defaultService] reactNative_authorizeForJavaScriptWithAppKey:rootDict[@"appkey"] timestamp:rootDict[@"timestamp"] nonce:rootDict[@"nonceStr"] signature:rootDict[@"signature"] webURL:URLString apiNames:rootDict[@"jsApiList"] completionBlock:^(BOOL success, NSString *message, NSArray<NSString *> *authorizedAPINames) {
            @strongify(self);
            if (success) {
                [self registerJSApi:authorizedAPINames];
                [WVJBUtils JBSuccessCallBack:responseCallback];
            }else{
                HMLogW(discovery,@"js授权失败, %@",message);
                [WVJBUtils JBErrorWithCode:JSErrorCodeVerifyError callBack:responseCallback];
            }
        }];
    }];
}

#pragma mark - private funcs
- (void)regActionJSAPIHandler:(NSString *)JSApiName handlerCallBack:(handlerCallBack)funcBack{
    [self.bridge registerHandler:JSApiName handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![data isKindOfClass:[NSString class]]) {
            HMLogD(discovery,@"Data is Null, JSApiName -- %@",JSApiName);
            funcBack([NSDictionary dictionary],responseCallback);
            return ;
        }
        
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (!rootDict ||
            ![rootDict isKindOfClass:[NSDictionary class]]) {
            HMLogD(discovery,@"RootDict is Null, JSApiName -- %@",JSApiName);
            funcBack([NSDictionary dictionary],responseCallback);
        } else {
            rootDict = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            funcBack(rootDict,responseCallback);
        }
    }];
}

- (void)registerJSApi:(NSArray *)JSApis {
    for (NSString *apiName in JSApis) {
        if ([apiName isEqualToString:@"setTitleBgColor"]) {
            [self JBSetTitleBgColor];
        } else if ([apiName isEqualToString:@"setTitleFgColor"]) {
            [self JBSetTitleFgColor];
        } else if ([apiName isEqualToString:@"setTitleVisibility"]) {
            [self JBTitleVisibility];
        } else if ([apiName isEqualToString:@"setCancelAuth"]) {
            [self JBSetCancelAuth];
        } else if ([apiName isEqualToString:@"setFunctionButtons"]) {
            [self JBSetFunctionButton];
        } else if ([apiName isEqualToString:@"functionButtonsEvent"]) {
            [self JBFunctionButtonEvent];
        } else if ([apiName isEqualToString:@"share"]) {
            [self JBShare];
        } else if ([apiName isEqualToString:@"shareEvent"]) {
            [self JBShareEvent];
        } else if ([apiName isEqualToString:@"exit"]) {
            [self JBExitWV];
        } else if ([apiName isEqualToString:@"navigateTo"]) {
            [self JBNavigationToPosition];
        } else if ([apiName isEqualToString:@"openExternalApp"]) {
            [self JBOpenExternalApp];
        } else if ([apiName isEqualToString:@"checkAppInstall"]) {
            [self JBCheckAppInstall];
        } else if ([apiName isEqualToString:@"openInBrowser"]) {
            [self JBOpenURLInBrowser];
        } else if ([apiName isEqualToString:@"getUserToken"]) {
            [self JBGetUserToken];
        } else if ([apiName isEqualToString:@"getLocation"]) {
            [self JBGetLocation];
        } else if ([apiName isEqualToString:@"weixinPay"]) {
            [self JBWeChatPay];
        } else if ([apiName isEqualToString:@"getDevicesInfo"]) {
            [self JBGetDeviceInfo];
        } else if ([apiName isEqualToString:@"getUsersInfo"]) {
            [self JBGetUserInfo];
        } else if ([apiName isEqualToString:@"chooseImage"]) {
            [self JBChooseImage];
        } else if ([apiName isEqualToString:@"syncWatchSkin"]){
            [self JBSyncWatchSkin];
        } else if ([apiName isEqualToString:@"pushDeviceNotice"]){
            [self JBPushDeviceNotice];
        }
    }
}

- (NSArray *)JSApis{
    return @[
             @"setTitleBgColor",
             @"setTitleFgColor",
             @"setTitleVisibility",
             @"setCancelAuth",
             @"setFunctionButtons",
             @"functionButtonsEvent",
             @"share",
             @"shareEvent",
             @"exit",
             @"navigateTo",
             @"openExternalApp",
             @"checkAppInstall",
             @"openInBrowser",
             @"getLocation",
             @"getUserToken",
             @"weixinPay",
             @"getDevicesInfo",
             @"getUsersInfo",
             @"chooseImage",
             @"syncWatchSkin",
             @"pushDeviceNotice",
             ];
}

- (NSArray *)navigationPositions {
    return @[@"login", @"status", @"discovery", @"smartplay:clock", @"mine", @"mine:profile", @"mine:friends", @"mine:friends:qrcode", @"mine:friends:scan", @"sport", @"relogin", @"sport:history", @"mine:settings", @"dev:disclaimer:confirm"];
}

- (NSArray *)navigationEvents {
    return @[@"exit", @"keep", @"refresh"];
}

- (NSArray *)rootNavigationPositions {
    return @[@"status", @"sport", @"discovery", @"mine", @"login"];
}

- (NSArray *)navigationParamsPositions {
    return @[@"sport:training:", @"sport:course:", @"sport:yoga:"];
}

- (UIColor *)setupNavColorData:(NSDictionary *)rootDict isBGColor:(BOOL)isBGColor callBack:(WVJBResponseCallback)responseCallback{
    NSInteger red = [rootDict[@"r"] integerValue];
    NSInteger green = [rootDict[@"g"] integerValue];
    NSInteger blue = [rootDict[@"b"] integerValue];
    CGFloat alpha = [rootDict[@"a"] floatValue];
    
    if (red < 0 || red >255 || green < 0 || green >255 || blue < 0 || blue >255 ) {
        [WVJBUtils JBErrorWithCode:JSErrorCodeParamRGBMustBetween0to255 callBack:responseCallback];
        return nil;
    } else if (alpha < 0 || alpha > 1) {
        [WVJBUtils JBErrorWithCode:JSErrorCodeParamAMustBetween0to1 callBack:responseCallback];
        return nil;
    }else{
        return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    }
}

// 分享错误处理
- (BOOL)isValidShareEventWithGlobalDict:(NSDictionary *)globalDict
                           especialDict:(NSMutableDictionary **)especialDict
                       responseCallback:(WVJBResponseCallback)responseCallback {
    
    NSArray *shareTypes = @[@"card", @"image", @"text", @"mix"];
    NSDictionary *sharePlatformDict = @{ @"weibo" : shareTypes,
                                @"moments" : @[@"card", @"image"],
                                @"weChat" : @[@"card", @"image"],
                                @"qq" : shareTypes,
                                @"qzone" : @[@"card"],
                                @"mifitZone" : @[@"image"],};
    
    NSArray *captureTypes = @[@(0), @(1), @(2)];
    
    // global 配置为必须的.
    if (!globalDict) {
        [WVJBUtils JBErrorWithCode:JSErrorCodeParamGlobalObjectIsRequired callBack:responseCallback];
        return NO;
    }
    
    // 删除不支持的分享渠道
    NSArray *platforms = [*especialDict allKeys];
    for (NSString *platform in platforms) {
        if (![sharePlatformDict.allKeys containsObject:platform]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeUnsupportedSharePlatform callBack:responseCallback];
            [*especialDict removeObjectForKey:platform];
        }
    }
    
    NSMutableArray *platformDicts = [NSMutableArray arrayWithArray:[*especialDict allValues]];
    [platformDicts addObject:globalDict];
    for (NSDictionary *platformDict in platformDicts) {
        NSString *type = platformDict[@"type"];
        NSNumber *capture = platformDict[@"capture"];
        // global 和 especial 结构中配置， type 和 capture 为必选参数。
        if (!type || !capture) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeParamTypeAndCaptureAreRequired callBack:responseCallback];
            return NO;
        }
        // 未知的截图类型
        if (![captureTypes containsObject:capture]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeUnknownCaptureValue callBack:responseCallback];
            return NO;
        }
        // 检查global或 especial 中每个渠道的分享支持的类型
        if (![shareTypes containsObject:type]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeUnsupportedShareType callBack:responseCallback];
            return NO;
        }
        // 截图参数设置为 1 (截可视区域)或 2 (截完整图) 时， 不可使用图片链接。
        if ([capture integerValue] != 0) {
            NSString *imageUrlString = platformDict[@"imgUrl"];
            if (imageUrlString) {
                [WVJBUtils JBErrorWithCode:JSErrorCodeCannotUseImgUrlAsShareImage callBack:responseCallback];
                return NO;
            }
        }
        // 特定分享类型对必选参数校验。
        NSString *missingParameter = [self getMissingParameterWithShareType:type platformShareDict:platformDict];
        if (missingParameter.length > 0) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeShareTypeMissParameter callBack:responseCallback];
            return NO;
        }
    }
    
    // 检查especial中配置的分享渠道是否支持其分享类型
    NSDictionary *especialShareDict = *especialDict;
    for (NSString *platform in especialShareDict.allKeys) {
        NSArray *supportShareTypes = sharePlatformDict[platform];
        NSString *shareType = especialShareDict[platform][@"type"];
        if (![supportShareTypes containsObject:shareType]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodePlatformUnsupportShareType callBack:responseCallback];
            return NO;
        }
    }
    // 检查especial中未配置的分享渠道是否支持global中配置的分享类型
    NSMutableArray *sharePlatforms = [NSMutableArray arrayWithArray:sharePlatformDict.allKeys];
    [sharePlatforms removeObjectsInArray:especialShareDict.allKeys];
    NSString *shareType = globalDict[@"type"];
    for (NSString *platform in sharePlatforms) {
        NSArray *supportShareTypes = sharePlatformDict[platform];
        if (![supportShareTypes containsObject:shareType]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodePlatformUnsupportShareType callBack:responseCallback];
            return NO;
        }
    }
    return YES;
}

- (NSString *)getMissingParameterWithShareType:(NSString *)shareType platformShareDict:(NSDictionary *)platformShareDict {
    NSString *title = platformShareDict[@"title"];
    NSString *desc = platformShareDict[@"desc"];
    NSString *link = platformShareDict[@"link"];
    NSString *imageUrl = platformShareDict[@"imgUrl"];
    NSNumber *capture = platformShareDict[@"capture"];
    NSString *missingParameter = @"";
    if ([shareType isEqualToString:JSBridgeShareTypeCard]) {
        if (title.length == 0) {
            missingParameter = @"title";
        } else if (desc.length == 0) {
            missingParameter = @"desc";
        } else if (link.length == 0) {
            missingParameter = @"link";
        } else if (imageUrl.length == 0 && [capture integerValue] == 0) {
            missingParameter = @"imgUrl";
        }
    } else if ([shareType isEqualToString:JSBridgeShareTypeImage]) {
        if (imageUrl.length == 0 && [capture integerValue] == 0) {
            missingParameter = @"imgUrl";
        }
    } else if ([shareType isEqualToString:JSBridgeShareTypeText]) {
        if (title.length == 0) {
            missingParameter = @"title";
        } else if (desc.length == 0) {
            missingParameter = @"desc";
        }
    } else if ([shareType isEqualToString:JSBridgeShareTypeMix]) {
        if (desc.length == 0) {
            missingParameter = @"desc";
        }
    }
    return missingParameter;
}

#pragma mark - JSApi Register

- (void)JBSetTitleBgColor {
    @weakify(self);
    [self regActionJSAPIHandler:@"setTitleBgColor" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        UIColor *color = [self setupNavColorData:rootDict isBGColor:YES callBack:responseCallback];
        if(!color){
            return ;
        }
        [WVJBUtils JBSuccessCallBack:responseCallback];
        self.navigationBgColor = color;
    }];
}

- (void)JBSetTitleFgColor {
    @weakify(self);
    [self regActionJSAPIHandler:@"setTitleFgColor" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        UIColor *color = [self setupNavColorData:rootDict isBGColor:NO callBack:responseCallback];
        if(!color){
            return ;
        }
        [WVJBUtils JBSuccessCallBack:responseCallback];
        self.navigationFgColor = color;
    }];
}

- (void)JBTitleVisibility {
    @weakify(self);
    [self regActionJSAPIHandler:@"setTitleVisibility" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        id display = rootDict[@"display"];
        if ([display isKindOfClass:[NSNumber class]]) {
            self.navigationVisible = [rootDict[@"display"] boolValue];
            [WVJBUtils JBSuccessCallBack:responseCallback];
        } else {
            [WVJBUtils JBErrorWithCode:JSErrorCodeParamDisplayMustBeBool callBack:responseCallback];
        }
    }];
}

- (void)JBSetCancelAuth {
    @weakify(self);
    [self regActionJSAPIHandler:@"setCancelAuth" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        self.isAuthorizeButtonDisplay = [rootDict[@"display"] boolValue];
        NSString *authorizeUrlString = rootDict[@"url"];
        if (self.isAuthorizeButtonDisplay) {
            // 检查取消授权的url是否合法
            if ([WVJBUtils isValidURL:authorizeUrlString]) {
                self.authorizeUrlString = rootDict[@"url"];
            } else {
                [WVJBUtils JBErrorWithCode:JSErrorCodeInvalidURL callBack:responseCallback];
                return;
            }
        }
        [WVJBUtils JBSuccessCallBack:responseCallback];
    }];
}

- (void)JBSetFunctionButton {
    @weakify(self);
    // {"share":{"display":1},"auth":{"display":1,"url":"https:\/\/hm.xiaomi.com\/cancel_auth?thrid_appid=123456"}}
    NSArray *buttonKeys = @[@"share", @"refresh", @"resize"];
    [self regActionJSAPIHandler:@"setFunctionButtons" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        // 未知的BUTTON_KEY
        for (NSString *key in rootDict.allKeys) {
            if (![buttonKeys containsObject:key]) {
                [WVJBUtils JBErrorWithCode:JSErrorCodeUnknownButtonKey callBack:responseCallback];
                return;
            }
        }
        
        NSDictionary *shareButtonDict = rootDict[@"share"];
        if (!shareButtonDict) {
            // 没有配置分享按钮
            [WVJBUtils JBSuccessCallBack:responseCallback];
            return;
        }
        if (![shareButtonDict isKindOfClass:[NSDictionary class]]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeInvalidJSON callBack:responseCallback];
            return;
        }
        BOOL isShareButtonDisplay = [shareButtonDict[@"display"] boolValue];
        NSDictionary *shareDict = shareButtonDict[@"config"];
        if (!shareDict || !isShareButtonDisplay) {
            [WVJBUtils JBSuccessCallBack:responseCallback];
            return;
        }
        // 需要分享，检查分享内容是否合法
        NSDictionary *globalDict = shareDict[@"global"];
        
        // global 配置为必须的.
        if (!globalDict) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeParamGlobalObjectIsRequired callBack:responseCallback];
            return;
        }
        
        NSMutableDictionary *especialDict = [NSMutableDictionary dictionaryWithDictionary:shareDict[@"especial"]];
        // 检查imgUrl是否合法
        NSMutableArray *platformDicts = [NSMutableArray arrayWithArray:[especialDict allValues]];
        [platformDicts addObject:globalDict];
        NSMutableArray *urlStrings = [NSMutableArray array];
        for (NSDictionary *platformDict in platformDicts) {
            NSString *urlString = platformDict[@"imgUrl"];
            if (urlString) {
                [urlStrings addObject:urlString];
            }
        }
        for (NSString *urlString in urlStrings) {
            if (![WVJBUtils isValidURL:urlString]) {
                [WVJBUtils JBErrorWithCode:JSErrorCodeInvalidURL callBack:responseCallback];
                return;
            }
        }
        
        if (![self isValidShareEventWithGlobalDict:globalDict especialDict:&especialDict responseCallback:responseCallback]) {
            return;
        }
        shareDict = @{ @"global" : globalDict,
                       @"especial" : especialDict ? especialDict : @{} };
        if ([self.delegate respondsToSelector:@selector(shareWithDict:isH5Share:)]) {
            // 分享内容配置成功，显示分享弹框
            self.isShareButtonDisplay = isShareButtonDisplay;
            [self.delegate shareWithDict:shareDict isH5Share:NO];
        }
        [WVJBUtils JBSuccessCallBack:responseCallback];
    }];
}

- (void)JBFunctionButtonEvent {
    [self regActionJSAPIHandler:@"functionButtonsEvent" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        
    }];
}

- (void)JBShare {
    @weakify(self);
    [self regActionJSAPIHandler:@"share" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSDictionary *globalDict = rootDict[@"global"];
        NSMutableDictionary *especialDict = [NSMutableDictionary dictionaryWithDictionary:rootDict[@"especial"]];
        
        if (![self isValidShareEventWithGlobalDict:globalDict especialDict:&especialDict responseCallback:responseCallback]) {
            return;
        }
        
        NSDictionary *shareDict = @{ @"global" : globalDict,
                                     @"especial" : especialDict ? especialDict : @{} };
        if ([self.delegate respondsToSelector:@selector(shareWithDict:isH5Share:)]) {
            [self.delegate shareWithDict:shareDict isH5Share:YES];
        }
        [WVJBUtils JBSuccessCallBack:responseCallback];
    }];
}

- (void)JBShareEvent {
    [self regActionJSAPIHandler:@"shareEvent" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        
    }];
}

- (void)JBExitWV {
    @weakify(self);
    [self regActionJSAPIHandler:@"exit" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(exitWebView)]) {
            [self.delegate exitWebView];
        }
    }];
}

- (void)JBNavigationToPosition {
    // {"fallbackEvent":"exit","position":"mine:friends"}
    @weakify(self);
    [self regActionJSAPIHandler:@"navigateTo" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSString *navigationEvent = rootDict[@"fallbackEvent"];
        NSString *navigationPosition = rootDict[@"position"];
        
        // 未定义的位置
        __block BOOL isContainParamsPosition = NO;
        [self.navigationParamsPositions enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([navigationPosition hasPrefix:obj]) {
                isContainParamsPosition = YES;
                *stop = YES;
            }
        }];
        if (![self.navigationPositions containsObject:navigationPosition] && !isContainParamsPosition) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeNotDefinedPosition callBack:responseCallback];
            return;
        }
        
        // 未知的 fallbackEvent 值
        if (![self.navigationEvents containsObject:navigationEvent]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeUnknownFallbackEvent callBack:responseCallback];
            return;
        }
        // position 为 Native 中 Tab 的首页 和 登录页时， 仅支持 exit 的 fallbackEvent
        if ([self.rootNavigationPositions containsObject:navigationPosition] &&
            ![navigationEvent isEqualToString:@"exit"]) {
            [WVJBUtils JBErrorWithCode:JSErrorCodeFallbackEventOfPositionUnsupported callBack:responseCallback];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(navigationToPage:)]) {
            [self.delegate navigationToPage:rootDict];
        }
        [WVJBUtils JBSuccessCallBack:responseCallback];
    }];
}

- (void)JBOpenExternalApp {
    // {"protocol":"alipay","behavior":"platformapi\/startapp?appId=20000001&_t=1481341679651"}
    [self regActionJSAPIHandler:@"openExternalApp" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        
        NSString *appName = rootDict[@"protocol"];
        NSString *behavior = rootDict[@"behavior"];
        NSString *urlString = [NSString stringWithFormat:@"%@://", appName];
        if (behavior.length > 0) {
            urlString = [urlString stringByAppendingString:behavior];
        }
        NSURL *appURL = [NSURL URLWithString:urlString];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:appURL];
        if (canOpen) {
            [[UIApplication sharedApplication] openURL:appURL];
            [WVJBUtils JBSuccessCallBack:responseCallback];
        } else {
            [WVJBUtils JBErrorWithCode:JSErrorCodeNotRegisteredProtocol callBack:responseCallback];
        }
    }];
}

- (void)JBCheckAppInstall {
    // {"packageName":"com.eg.android.AlipayGphone"}
    [self regActionJSAPIHandler:@"checkAppInstall" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        NSString *appName = rootDict[@"packageName"];
        NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", appName]];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:appURL];
        NSDictionary *resultDic = @{@"installed": @(canOpen)};
        NSString *resultString = [WVJBUtils JSONWithDict:resultDic];
        responseCallback(resultString);
    }];
}

- (void)JBOpenURLInBrowser {
    [self regActionJSAPIHandler:@"openInBrowser" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        NSString *urlString = rootDict[@"url"];
        urlString = [urlString stringByRemovingPercentEncoding];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        if (canOpen) {
            [[UIApplication sharedApplication] openURL:url];
            [WVJBUtils JBSuccessCallBack:responseCallback];
        } else {
            [WVJBUtils JBErrorWithCode:JSErrorCodeInvalidURL callBack:responseCallback];
        }
    }];
}

- (void)JBGetUserToken {
    @weakify(self);
    [self regActionJSAPIHandler:@"getUserToken" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(fetchMifitInfo:callBack:)]) {
            [self.delegate fetchMifitInfo:JBContentTypeUserToken callBack:responseCallback];
        }
    }];
}

- (void)JBGetLocation {
    @weakify(self);
    [self regActionJSAPIHandler:@"getLocation" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(fetchMifitInfo:callBack:)]) {
            [self.delegate fetchMifitInfo:JBContentTypeLocation callBack:responseCallback];
        }
    }];
}

- (void)JBGetDeviceInfo {
    @weakify(self);
    [self regActionJSAPIHandler:@"getDevicesInfo" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(fetchMifitInfo:callBack:)]) {
            [self.delegate fetchMifitInfo:JBContentTypeDeviceInfo callBack:responseCallback];
        }
    }];
}

- (void)JBGetUserInfo {
    @weakify(self);
    [self regActionJSAPIHandler:@"getUsersInfo" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(fetchMifitInfo:callBack:)]) {
            [self.delegate fetchMifitInfo:JBContentTypeUserInfo callBack:responseCallback];
        }
    }];
}

- (void)JBWeChatPay {
    @weakify(self);
    [self regActionJSAPIHandler:@"weixinPay" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(wechatPay:callBack:)]) {
            [self.delegate wechatPay:rootDict callBack:responseCallback];
        }
    }];
}

- (void)JBChooseImage {
    @weakify(self);
    [self regActionJSAPIHandler:@"chooseImage" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(chooseImage:callBack:)]) {
            [self.delegate chooseImage:rootDict callBack:responseCallback];
        }
    }];
}

- (void)JBSyncWatchSkin {
    @weakify(self);
    [self regActionJSAPIHandler:@"syncWatchSkin" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(syncWatchSkinWithConfig:callBack:)]) {
            [self.delegate syncWatchSkinWithConfig:rootDict callBack:responseCallback];
        }
    }];
}

- (void)JBPushDeviceNotice {
    @weakify(self);
    [self regActionJSAPIHandler:@"pushDeviceNotice" handlerCallBack:^(NSDictionary *rootDict, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(writeDeviceNoticeInfo:callBack:)]) {
            [self.delegate writeDeviceNoticeInfo:rootDict callBack:responseCallback];
        }
    }];
}
@end
