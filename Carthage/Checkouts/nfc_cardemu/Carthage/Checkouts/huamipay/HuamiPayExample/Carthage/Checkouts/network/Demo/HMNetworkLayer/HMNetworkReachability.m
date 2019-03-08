//
//  HMNetworkReachability.m
//  HMNetworkLayer
//
//  Created by 李宪 on 17/7/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>


NSString * const HMNetworkCoreReachabilityDidChangeNotification = @"HMNetworkCoreReachabilityDidChangeNotification";
NSString * const HMNetworkCoreReachabilityNotificationStatusKey = @"HMNetworkCoreReachabilityNotificationStatusKey";


@implementation HMNetworkReachability

+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

+ (HMNetworkReachabilityStatus)reachabilityStatus {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            return HMNetworkReachabilityStatusUnknown;
        case AFNetworkReachabilityStatusNotReachable:
            return HMNetworkReachabilityStatusNotReachable;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return HMNetworkReachabilityStatusReachableViaWWAN;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return HMNetworkReachabilityStatusReachableViaWiFi;
    }
}

+ (BOOL)reachable {
    return self.reachabilityStatus == HMNetworkReachabilityStatusReachableViaWWAN ||
    self.reachabilityStatus == HMNetworkReachabilityStatusReachableViaWiFi;
}

+ (void)reachabilityDidChange:(NSNotification *)notificaion {

    NSDictionary *userInfo = @{HMNetworkCoreReachabilityNotificationStatusKey : @([self reachabilityStatus])};
    [[NSNotificationCenter defaultCenter] postNotificationName:HMNetworkCoreReachabilityDidChangeNotification
                                                        object:self
                                                      userInfo:userInfo];
}

@end
