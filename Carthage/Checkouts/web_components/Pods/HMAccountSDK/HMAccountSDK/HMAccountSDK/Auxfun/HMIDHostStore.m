//
//  HMIDHostStore.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDHostStore.h"

static NSString *const HMIDBaseURLKey = @"HMIDBaseURL";

static NSString *currentUseHost = nil;

@implementation HMIDHostStore

+ (NSString *)currentUseHost{
    if (!currentUseHost) {
        currentUseHost = [[NSUserDefaults standardUserDefaults] objectForKey:HMIDBaseURLKey];
    }
    return currentUseHost;
}

+ (void)setCurrentUseHost:(NSString *)host{
    if (!host || [host length] == 0) {
        return;
    }
    currentUseHost = host;
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:HMIDBaseURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
