//
//  HMAccountKeyChainStore.m
//  HMAuthDemo
//
//  Created by 李林刚 on 2017/4/21.
//  Copyright © 2017年 李林刚. All rights reserved.
//

#import "HMAccountKeyChainStore.h"
#import <SAMKeychain/SAMKeychain.h>
#import <UIKit/UIKit.h>

/**设备唯一ID，账号需要的参数*/
static NSString *const HMAccountKeyChainDeviceIdentifier = @"phoneDeviceIdentifier";

/**keychain中存储的server名字*/
static NSString *const HMAccountKeyChainStoreServiceName = @"com.huami.keychain.service1";

@implementation HMAccountKeyChainStore

+ (NSString *)uniqueDeviceIdentifier{
    NSString *uniqueDeviceIdentifier = [[self class] passwordForAccount:HMAccountKeyChainDeviceIdentifier error:nil];
    if (!uniqueDeviceIdentifier) {
        uniqueDeviceIdentifier = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [[self class] setPassword:uniqueDeviceIdentifier forAccount:HMAccountKeyChainDeviceIdentifier error:nil];
    }
    return uniqueDeviceIdentifier;
}

+ (NSString *)passwordForAccount:(NSString *)account error:(NSError **)error{
    [self configKeychainStore];
    return [SAMKeychain passwordForService:HMAccountKeyChainStoreServiceName account:account error:error];
}

+ (BOOL)deletePasswordForAccount:(NSString *)account error:(NSError **)error{
    [self configKeychainStore];
    return [SAMKeychain deletePasswordForService:HMAccountKeyChainStoreServiceName account:account error:error];
}

+ (BOOL)setPassword:(NSString *)password forAccount:(NSString *)account error:(NSError **)error{
    [self configKeychainStore];
    return [SAMKeychain setPassword:password forService:HMAccountKeyChainStoreServiceName account:account error:error];
}

+ (NSArray<NSDictionary<NSString *, id> *> *)allAccounts:(NSError **)error{
    [self configKeychainStore];
    return [SAMKeychain allAccounts:error];
}

#pragma mark - Private Methods

+ (void)configKeychainStore{
    CFTypeRef accessibilityType = [SAMKeychain accessibilityType];
    //设置keychain的权限为kSecAttrAccessibleAfterFirstUnlock，默认为kSecAttrAccessibleWhenUnlocked，导致锁屏情况下读取失败errSecInteractionNotAllowed错误
    if (accessibilityType == NULL || (accessibilityType != NULL && accessibilityType != kSecAttrAccessibleAfterFirstUnlock)) {
        [SAMKeychain setAccessibilityType:kSecAttrAccessibleAfterFirstUnlock];
    }
}

@end
