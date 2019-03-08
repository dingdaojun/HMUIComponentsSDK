//
//  HMNetworkReachability.h
//  HMNetworkLayer
//
//  Created by 李宪 on 17/7/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HMNetworkReachabilityStatus) {
    HMNetworkReachabilityStatusUnknown          = -1,
    HMNetworkReachabilityStatusNotReachable     = 0,
    HMNetworkReachabilityStatusReachableViaWWAN = 1,
    HMNetworkReachabilityStatusReachableViaWiFi = 2,
};


FOUNDATION_EXPORT NSString * const HMNetworkCoreReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString * const HMNetworkCoreReachabilityNotificationStatusKey;

@interface HMNetworkReachability : NSObject
@property (class, readonly) HMNetworkReachabilityStatus reachabilityStatus;
@property (class, readonly) BOOL reachable;
@end
