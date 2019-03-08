//
//  HMAccountSDK.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMAccountSDK.h"

#import "HMIDLoginRequestTask.h"
#import "HMIDLoginBySecurityRequestTask.h"
#import "HMIDReLoginRequestTask.h"
#import "HMIDRenewAppTokenRequestTask.h"
#import "HMIDRenewLoginTokenRequestTask.h"
#import "HMIDVerifyAppTokenRequestTask.h"
#import "HMIDReLoginRequestTask.h"
#import "HMIDLogoutRequestTask.h"
#import "HMIDForceLogoutRequestTask.h"

#import "HMIDBindAccountRequestTask.h"
#import "HMIDUnBindAccountRequestTask.h"
#import "HMIDBindAccountListRequestTask.h"
#import "HMIDGetPhoneNumberRequestTask.h"

#import "HMAccountKeyChainStore.h"
#import "HMIDHostStore.h"

#import "HMIDLoginTokenItem.h"
#import "HMIDAppTokenItem.h"

#import "NSError+HMAccountSDK.h"

static NSString *const HMIDMIThirdNameKey          = @"MI";
static NSString *const HMIDWechatThirdNameKey      = @"WeChat";
static NSString *const HMIDFacebookThirdNameKey    = @"Facebook";
static NSString *const HMIDGoogleThirdNameKey      = @"Google";
static NSString *const HMIDEmailThirdNameKey       = @"Email";
static NSString *const HMIDPhoneThirdNameKey       = @"Phone";
static NSString *const HMIDLineThirdNameKey        = @"Line";

@interface HMAccountSDK ()

@property (nonnull, nonatomic, copy) NSString *uniqueDeviceIdentifier;


@property (nonnull, nonatomic, copy) NSString *appName;

@property (nullable, nonatomic, strong) HMIDLoginTokenItem *loginTokenItem;

@property (nullable, nonatomic, strong) HMIDAppTokenItem *appTokenItem;

@property (nullable, nonatomic, strong) NSMutableArray *getAppTokenBlockArray;

@end

@implementation HMAccountSDK

+ (HMAccountSDK *)sharedInstance{
    static HMAccountSDK *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.getAppTokenBlockArray = [[NSMutableArray alloc] init];
        
        self.loginTokenItem = [[HMIDLoginTokenItem alloc] init];
        self.appTokenItem = [[HMIDAppTokenItem alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

+ (NSString *)appName {
    return [HMAccountSDK sharedInstance].appName;
}

+ (NSString *)userId {
    return [HMAccountSDK sharedInstance].userId;
}

+ (NSString *)uniqueDeviceIdentifier {
    return [HMAccountSDK sharedInstance].uniqueDeviceIdentifier;
}

+ (NSString *)loginToken {
    return [HMAccountSDK sharedInstance].loginToken;
}

+ (void)getAppTokenEventHandler:(HMIDAppTokenEventHandler)eventHandler {
    [[HMAccountSDK sharedInstance] getAppTokenEventHandler:eventHandler];
}

+ (BOOL)isLogin {
    return [[HMAccountSDK sharedInstance] isLogin];
}

+ (BOOL)loginWithPlatform:(HMIDLoginPlatForm)platForm
                     isCN:(BOOL)isCN
                 authItem:(HMIDAuthItem *)authItem
             eventHandler:(HMIDLoginEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] loginWithPlatform:platForm isCN:isCN authItem:authItem eventHandler:eventHandler];
}

+ (BOOL)loginWithPlatform:(HMIDLoginPlatForm)platForm
                   region:(NSString *)region
                 authItem:(HMIDAuthItem *)authItem
             eventHandler:(HMIDLoginEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] loginWithPlatform:platForm
                                                region:region
                                                   authItem:authItem
                                               eventHandler:eventHandler];
}

+ (BOOL)loginWithThirdname:(NSString *)thirdname
               region:(NSString *)region
                 grantType:(HMIDTokenGrantTypeOptionKey)grantType
                  authItem:(HMIDAuthItem *)authItem
              eventHandler:(HMIDLoginEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] loginWithThirdname:thirdname
                                                 region:region
                                                   grantType:grantType
                                                    authItem:authItem
                                                eventHandler:eventHandler];
}


+ (BOOL)verifyAppTokenEventHandler:(HMIDEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] verifyAppTokenEventHandler:eventHandler];
}

+ (BOOL)refreshApptokenEventHandler:(HMIDAppTokenEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] refreshApptokenEventHandler:eventHandler];
}

+ (BOOL)reLoginEventHandler:(HMIDAppTokenEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] reLoginEventHandler:eventHandler];
}

+ (BOOL)logoutForce:(BOOL)force eventHandler:(HMIDEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] logoutForce:force eventHandler:eventHandler];
}

+ (BOOL)allAppForceEventHandler:(HMIDEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] allAppForceEventHandler:eventHandler];
}

+ (BOOL)bindWithPlatForm:(HMIDLoginPlatForm)platForm
                    code:(NSString *)code
             region:(NSString *)regionc
            eventHandler:(HMIDBindEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] bindWithPlatForm:platForm code:code region:regionc eventHandler:eventHandler];
}

+ (BOOL)unbindWithPlatForm:(HMIDLoginPlatForm)platForm
                   thirdId:(NSString *)thirdId
              eventHandler:(HMIDEventHandler)eventHandler;{
    return [[HMAccountSDK sharedInstance] unbindWithPlatForm:platForm thirdId:thirdId eventHandler:eventHandler];
}

+ (BOOL)getAllBindAccountWithEventHandler:(HMIDBindListEventHandler)eventHandler {
    return [[HMAccountSDK sharedInstance] getAllBindAccountWithEventHandler:eventHandler];
}

+ (BOOL)getPhoneNumberWithEventHandler:(void(^)(NSString *phoneNumber, NSError *error))eventHandler {
    return [[HMAccountSDK sharedInstance] getPhoneNumberWithEventHandler:eventHandler];
}

#pragma mark -  Private Methods

- (BOOL)isLogin{
    BOOL hasLoginToken = [self.loginTokenItem hasLogin];
    BOOL hasAppToken = [self.appTokenItem hasLogin];
    return hasLoginToken && hasAppToken;
}

//fixbug https://fabric.io/huami/ios/apps/hm.wristband/issues/59ad4bfcbe077a4dcc186270?time=last-thirty-days
//由于系统的NSMutable***不是线程安全的，故添加锁
- (void)getAppTokenEventHandler:(HMIDAppTokenEventHandler)eventHandler{
    if (!eventHandler) {
        return;
    }
    //1、logintoken必须存在，否则其他操作都是无效的
    if (![self.loginTokenItem hasLogin]) {
        NSError *underlyingError = [NSError errorWithDomain:@"local account error" code:105 userInfo:@{NSLocalizedDescriptionKey:@"local refresh token not found!"}];
        NSError *error = [NSError idErrorWithIDResponseObject:@{@"code":@"0105",NSUnderlyingErrorKey:underlyingError}];
        eventHandler(self.appTokenItem, error);        
        return;
    }
    
    BOOL loginTokenValid = [self.loginTokenItem isValided];
    BOOL appTokenValid = [self.appTokenItem isValided] && [self.appTokenItem hasLogin];
    if (loginTokenValid && appTokenValid) {
        //都没过期直接返回本地
        eventHandler(self.appTokenItem, nil);
        return;
    }
    @synchronized(self.getAppTokenBlockArray){
        [self.getAppTokenBlockArray addObject:eventHandler];
    }
    if ([self.getAppTokenBlockArray count] >= 2) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSError *refreshError = nil;
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        if (!loginTokenValid) {
            //loginToken过期了重新renew
            HMIDRenewLoginTokenRequestTask *renewLoginRequestTask = [[HMIDRenewLoginTokenRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken];
            [renewLoginRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
                if (!error) {
                    HMIDLoginTokenItem *loginTokenItem = request.resultItem;
                    [self.loginTokenItem copyFromItem:loginTokenItem];
                    [self save:&refreshError];
                } else {
                    refreshError = error;
                }
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        if (refreshError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @synchronized(self.getAppTokenBlockArray){
                    for (HMIDAppTokenEventHandler handler in self.getAppTokenBlockArray) {
                        handler(self.appTokenItem, refreshError);
                    }
                    [self.getAppTokenBlockArray removeAllObjects];
                }
            });
            return;
        }
        
        //appToken过期了重新renew
        HMIDRenewAppTokenRequestTask *renewAppTokenRequestTask = [[HMIDRenewAppTokenRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken appName:self.appName];
        [renewAppTokenRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
            if (!error) {
                [self.appTokenItem copyFromItem:request.resultItem];
                [self save:&refreshError];
            } else {
                refreshError = error;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{

            @synchronized(self.getAppTokenBlockArray){
                for (HMIDAppTokenEventHandler handler in self.getAppTokenBlockArray) {
                    handler(self.appTokenItem, refreshError);
                }
                [self.getAppTokenBlockArray removeAllObjects];
            }
        });
    });
}

- (BOOL)loginWithPlatform:(HMIDLoginPlatForm)platForm
                     isCN:(BOOL)isCN
                 authItem:(HMIDAuthItem *)authItem
             eventHandler:(HMIDLoginEventHandler)eventHandler{
    if (!eventHandler) {
        return NO;
    }
    NSString *cacheHostURL = @"";
    if (isCN) {
        cacheHostURL = [HMAccountConfig idAccountCNServerHost];
    } else {
        cacheHostURL = [HMAccountConfig idAccountUSServerHost];
    }
    [HMIDHostStore setCurrentUseHost:cacheHostURL];
    
    NSString *thirdName = [[self class] thirdNameWithPlatForm:platForm];
    HMIDLoginBySecurityRequestTask *securityRequestTask = [[HMIDLoginBySecurityRequestTask alloc] initWithAppName:self.appName thirdName:thirdName security:authItem.thirdToken thirdId:authItem.thirdId deviceIdType:self.uniqueDeviceIdentifier deviceId:@"uuid"];
    [securityRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        if (error) {
            eventHandler(nil,error);
        } else {
            HMIDLoginBySecurityRequestTask *tmpRequest = (HMIDLoginBySecurityRequestTask *)request;
            [self.appTokenItem copyFromItem:tmpRequest.loginItem.appTokenItem];
            [self.loginTokenItem copyFromItem:tmpRequest.loginTokenItem];
            eventHandler(tmpRequest.loginItem,nil);
        }
    }];
    return YES;
}

- (BOOL)loginWithPlatform:(HMIDLoginPlatForm)platForm
              region:(NSString *)region
                 authItem:(HMIDAuthItem *)authItem
             eventHandler:(HMIDLoginEventHandler)eventHandler{
    NSString *thirdName = [[self class] thirdNameWithPlatForm:platForm];
    
    HMIDTokenGrantTypeOptionKey grantType = HMIDTokenGrantTypeOptionKeyAccessToken;
    if (platForm == HMIDLoginPlatFormMI ||
        platForm == HMIDLoginPlatFormWeChat ||
        platForm == HMIDLoginPlatFormGoogle) {
        grantType = HMIDTokenGrantTypeOptionKeyRequestToken;
    }
    return [self loginWithThirdname:thirdName region:region grantType:grantType authItem:authItem eventHandler:eventHandler];
}

- (BOOL)loginWithThirdname:(NSString *)thirdname
               region:(NSString *)region
                 grantType:(HMIDTokenGrantTypeOptionKey)grantType
                  authItem:(HMIDAuthItem *)authItem
              eventHandler:(HMIDLoginEventHandler)eventHandler{
    if (!eventHandler) {
        return NO;
    }
    HMIDLoginRequestTask *loginRequestTask = [[HMIDLoginRequestTask alloc] initWithGrantType:grantType appName:self.appName thirdName:thirdname code:authItem.thirdToken region:region deviceIdType:@"uuid" deviceId:self.uniqueDeviceIdentifier];
    [loginRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        if (!error) {
            [self.appTokenItem copyFromItem:loginRequestTask.loginItem.appTokenItem];
            [self.loginTokenItem copyFromItem:loginRequestTask.loginTokenItem];
            [HMIDHostStore setCurrentUseHost:loginRequestTask.domain];
            NSError *saveError = nil;
            [self save:&saveError];
            eventHandler(loginRequestTask.loginItem, saveError);
        } else {
            eventHandler(loginRequestTask.loginItem, error);
        }
    }];
    return YES;
}

- (BOOL)verifyAppTokenEventHandler:(HMIDEventHandler)eventHandler{
    if (!eventHandler) {
        return NO;
    }
    HMIDVerifyAppTokenRequestTask *requestTask = [[HMIDVerifyAppTokenRequestTask alloc] initWithAppName:self.appName appToken:self.appTokenItem.appToken];
    [requestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        eventHandler(error);
    }];
    return YES;
}

- (BOOL)refreshApptokenEventHandler:(HMIDAppTokenEventHandler)eventHandler {
    if (!eventHandler) {
        return NO;
    }
    //1、logintoken必须存在，否则其他操作都是无效的
    if (![self.loginTokenItem hasLogin]) {
        NSError *underlyingError = [NSError errorWithDomain:@"local account error" code:105 userInfo:@{NSLocalizedDescriptionKey:@"local refresh token not found!"}];
        NSError *error = [NSError idErrorWithIDResponseObject:@{@"code":@"0105",NSUnderlyingErrorKey:underlyingError}];
        eventHandler(self.appTokenItem, error);
        return NO;
    }
    
    @synchronized(self.getAppTokenBlockArray){
        [self.getAppTokenBlockArray addObject:eventHandler];
    }
    if ([self.getAppTokenBlockArray count] >= 2) {
        return YES;
    }
    BOOL loginTokenValid = [self.loginTokenItem isValided];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSError *refreshError = nil;
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        if (!loginTokenValid) {
            //loginToken过期了重新renew
            HMIDRenewLoginTokenRequestTask *renewLoginRequestTask = [[HMIDRenewLoginTokenRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken];
            [renewLoginRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
                if (!error) {
                    HMIDLoginTokenItem *loginTokenItem = request.resultItem;
                    [self.loginTokenItem copyFromItem:loginTokenItem];
                    [self save:&refreshError];
                } else {
                    refreshError = error;
                }
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        if (refreshError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                eventHandler(self.appTokenItem, refreshError);
                @synchronized(self.getAppTokenBlockArray){
                    [self.getAppTokenBlockArray removeAllObjects];
                }
            });
            return;
        }
        
        //强制刷新appToken
        HMIDRenewAppTokenRequestTask *renewAppTokenRequestTask = [[HMIDRenewAppTokenRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken appName:self.appName];
        [renewAppTokenRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
            if (!error) {
                [self.appTokenItem copyFromItem:request.resultItem];
                [self save:&refreshError];
            } else {
                refreshError = error;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (refreshError) {
                eventHandler(self.appTokenItem, refreshError);
            } else {
                @synchronized(self.getAppTokenBlockArray){
                    for (HMIDAppTokenEventHandler handler in self.getAppTokenBlockArray) {
                        handler(self.appTokenItem, refreshError);
                    }
                }
            }
            @synchronized(self.getAppTokenBlockArray){
                [self.getAppTokenBlockArray removeAllObjects];
            }
        });
    });
    return YES;
}


- (BOOL)reLoginEventHandler:(HMIDAppTokenEventHandler)eventHandler{
    if (!eventHandler) {
        return NO;
    }
    HMIDReLoginRequestTask *requestTask = [[HMIDReLoginRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken appName:self.appName deviceIdType:@"uuid" deviceId:self.uniqueDeviceIdentifier];
    [requestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        if (error) {
            eventHandler(nil, error);
        } else {
            HMIDReLoginRequestTask *tmpRequest = (HMIDReLoginRequestTask *)request;
            [self.appTokenItem copyFromItem:tmpRequest.appTokenItem];
            [self.loginTokenItem copyFromItem:tmpRequest.loginTokenItem];
            NSError *saveAccountError = nil;
            [self save:&saveAccountError];
            eventHandler(self.appTokenItem,saveAccountError);
        }
    }];
    return YES;
}

- (BOOL)logoutForce:(BOOL)force eventHandler:(HMIDEventHandler)eventHandler{
    if (![self isLogin]) {
        [self clear];
        if (eventHandler) {
            eventHandler(nil);
        }
        return YES;
    }
    HMIDLogoutRequestTask *requestTask = [[HMIDLogoutRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken];
    [requestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        if (!error || force) {
            [self clear];
        }
        if (eventHandler) {
            eventHandler(error);
        }
    }];
    return YES;
}

- (BOOL)allAppForceEventHandler:(HMIDEventHandler)eventHandler{
    if (![self.loginTokenItem hasLogin]) {
        if (eventHandler) {
            eventHandler(nil);
        }
        return NO;
    }
    HMIDForceLogoutRequestTask *requestTask = [[HMIDForceLogoutRequestTask alloc] initWithLoginToken:self.loginTokenItem.loginToken appName:self.appName scope:HMIDForceLogoutScopeKeyAll];
    [requestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        if (!error) {
            [self clear];
        }
        if (eventHandler) {
            eventHandler(error);
        }
    }];
    return YES;
}

#pragma mark - bind & unbind

- (BOOL)bindWithPlatForm:(HMIDLoginPlatForm)platForm
                    code:(NSString *)code
             region:(NSString *)region
             eventHandler:(HMIDBindEventHandler)eventHandler {
    if (!eventHandler) {
        return NO;
    }
    NSString *thirdName = [[self class] thirdNameWithPlatForm:platForm];
    HMIDTokenGrantTypeOptionKey grantType = HMIDTokenGrantTypeOptionKeyAccessToken;
    if (platForm == HMIDLoginPlatFormMI ||
        platForm == HMIDLoginPlatFormWeChat ||
        platForm == HMIDLoginPlatFormGoogle) {
        grantType = HMIDTokenGrantTypeOptionKeyRequestToken;
    }
    HMIDBindAccountRequestTask *bindRequestTask = [[HMIDBindAccountRequestTask alloc] initWithThirdName:thirdName code:code region:region grantType:grantType appToken:self.appTokenItem.appToken];
    [bindRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        eventHandler(request.resultItem, error);
    }];
    return YES;
}

- (BOOL)unbindWithPlatForm:(HMIDLoginPlatForm)platForm
                   thirdId:(NSString *)thirdId
              eventHandler:(HMIDEventHandler)eventHandler{
    if (!eventHandler) {
        return NO;
    }
    NSString *thirdName = [[self class] thirdNameWithPlatForm:platForm];
    HMIDUnBindAccountRequestTask *unbindRequestTask = [[HMIDUnBindAccountRequestTask alloc] initWithThirdName:thirdName thirdId:thirdId appToken:self.appTokenItem.appToken];
    [unbindRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        eventHandler(error);
    }];
    return YES;
}

- (BOOL)getAllBindAccountWithEventHandler:(HMIDBindListEventHandler)eventHandler {
    if (!eventHandler) {
        return NO;
    }
    HMIDBindAccountListRequestTask *accountListRequestTask = [[HMIDBindAccountListRequestTask alloc] initWithAppToken:self.appTokenItem.appToken];
    [accountListRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        eventHandler(request.resultItems, error);
    }];
    return YES;
}

- (BOOL)getPhoneNumberWithEventHandler:(void(^)(NSString *phoneNumber, NSError *error))eventHandler {
    if (!eventHandler) {
        return NO;
    }
    HMIDGetPhoneNumberRequestTask *phoneRequestTask = [[HMIDGetPhoneNumberRequestTask alloc] initWithUserId:self.userId appToken:self.appTokenItem.appToken];
    [phoneRequestTask loadWithComplateHandle:^(WSRequestTask *request, BOOL isLocalResult, NSError *error) {
        eventHandler(request.resultItem, error);
    }];
    return YES;
}

#pragma mark -  Private Methods

- (BOOL)save:(NSError **)error{
    BOOL saveSuccess = [self.loginTokenItem save:error];
    if (saveSuccess) {
        saveSuccess = [self.appTokenItem save];
        if (!saveSuccess) {
            *error = [NSError idErrorWithIDResponseObject:@{@"code":@"0102"}];
        }
    } else {
        if (*error) {
            *error = [NSError idErrorWithIDResponseObject:@{@"code":@"0105",NSUnderlyingErrorKey:*error}];
        } else {
            *error = [NSError idErrorWithIDResponseObject:@{@"code":@"0105"}];
        }
    }
    return saveSuccess;
}

- (void)clear{
    [self.loginTokenItem clear];
    [self.appTokenItem clear];
}

+ (NSString *)thirdNameWithPlatForm:(HMIDLoginPlatForm)platForm{
    NSDictionary *configureInfo = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"HMAccountSDK"];
    NSDictionary *thirdNameInfo = [configureInfo objectForKey:@"ThirdName"];
    if (!thirdNameInfo) {
        return nil;
    }
    if (platForm == HMIDLoginPlatFormMI) {
        return [thirdNameInfo objectForKey:HMIDMIThirdNameKey];
    } else if (platForm == HMIDLoginPlatFormWeChat){
        return [thirdNameInfo objectForKey:HMIDWechatThirdNameKey];
    } else if (platForm == HMIDLoginPlatFormFacebook){
        return [thirdNameInfo objectForKey:HMIDFacebookThirdNameKey];
    } else if (platForm == HMIDLoginPlatFormGoogle){
        return [thirdNameInfo objectForKey:HMIDGoogleThirdNameKey];
    } else if (platForm == HMIDLoginPlatFormEmail){
        return [thirdNameInfo objectForKey:HMIDEmailThirdNameKey];
    } else if (platForm == HMIDLoginPlatFormPhone){
        return [thirdNameInfo objectForKey:HMIDPhoneThirdNameKey];
    } else if (platForm == HMIDLoginPlatFormLine){
        return [thirdNameInfo objectForKey:HMIDLineThirdNameKey];
    } else {
        return nil;
    }
}

#pragma mark -  Getter and Setter

- (NSString *)appName{
    if (!_appName) {
        NSArray *urlTypesArray = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
        NSArray *urlSchemes;
        for (NSDictionary *dict in urlTypesArray) {
            if ([[dict objectForKey:@"CFBundleURLName"] isEqualToString:@"HMAccount"]) {
                urlSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
                break;
            }
        }
        if ([urlSchemes count] == 0) {
            NSAssert(NO, @"请在info.plist中添加CFBundleURLTypes并配置在米动账号系统中申请的AppName(CFBundleURLName must be v)e.g.<dict><key>CFBundleTypeRole</key><string>HM</string> <key>CFBundleURLName</key> <string>HMAccount</string> <key>CFBundleURLSchemes</key> <array> <string>appname</string> </array> </dict>");
        }
        _appName = [urlSchemes firstObject];
    }
    return _appName;
}

- (NSString *)userId{
    return self.appTokenItem.userId;
}

- (NSString *)uniqueDeviceIdentifier{
    if (!_uniqueDeviceIdentifier) {
        _uniqueDeviceIdentifier = [HMAccountKeyChainStore uniqueDeviceIdentifier];
    }
    return _uniqueDeviceIdentifier;
}

- (NSString *)loginToken {
    return self.loginTokenItem.loginToken;
}
@end
