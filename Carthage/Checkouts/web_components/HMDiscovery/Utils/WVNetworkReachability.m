//  WVNetworkReachability.m
//  Created on 2018/6/14
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "WVNetworkReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
@import CoreTelephony;

typedef void (^WVReachabilityStatusBlock)(WVReachabilityStatus status);

static WVReachabilityStatus getTelephonyNetworkStatus() {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    if (info == nil) {
        return WVReachabilityStatusNotReachable;
    }
    NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    NSArray *radioAccessTechnology3G = @[CTRadioAccessTechnologyHSDPA,
                                         CTRadioAccessTechnologyWCDMA,
                                         CTRadioAccessTechnologyHSUPA,
                                         CTRadioAccessTechnologyCDMAEVDORev0,
                                         CTRadioAccessTechnologyCDMAEVDORevA,
                                         CTRadioAccessTechnologyCDMAEVDORevB,
                                         CTRadioAccessTechnologyeHRPD];
    NSArray *radioAccessTechnology4G = @[CTRadioAccessTechnologyLTE];
    WVReachabilityStatus status;
    if ([radioAccessTechnology4G containsObject:currentRadioAccessTechnology]) {
        status = WVReachabilityStatusWWAN4G;
    } else if ([radioAccessTechnology3G containsObject:currentRadioAccessTechnology]) {
        status = WVReachabilityStatusWWAN3G;
    } else if (currentRadioAccessTechnology == nil) {
        status = WVReachabilityStatusNotReachable;
    } else {
        status = WVReachabilityStatusWWAN2G;
    }
    return status;
}

static WVReachabilityStatus WVReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    WVReachabilityStatus status = WVReachabilityStatusNotReachable;
    if (isNetworkReachable == NO) {
        status = WVReachabilityStatusNotReachable;
    }
#if    TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = getTelephonyNetworkStatus();
        if (status == WVReachabilityStatusNotReachable) {
            status = WVReachabilityStatusWWAN2G;
        }
    }
#endif
    else {
        status = WVReachabilityStatusWiFi;
    }
    
    return status;
}

static void WVPostReachabilityStatusChange(SCNetworkReachabilityFlags flags, WVReachabilityStatusBlock block) {
    WVReachabilityStatus status = WVReachabilityStatusForFlags(flags);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(status);
        }
    });
}

static void WVReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    WVPostReachabilityStatusChange(flags, (__bridge WVReachabilityStatusBlock)info);
}

static const void * WVReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void WVReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

@interface WVNetworkReachability()

@property (assign, nonatomic) BOOL lastReachable;
@property (assign, nonatomic) SCNetworkReachabilityRef reachability;
@property (strong, nonatomic) NSMutableDictionary *statusChangedDictionary;
@property (strong, nonatomic) NSMutableDictionary *reachableChangedDictionary;
@property (strong, nonatomic) NSMutableDictionary *observerDictionary;
@property (strong, nonatomic) CTCellularData *cellularData API_AVAILABLE(ios(9.0));//iOS9+
@end

@implementation WVNetworkReachability

+ (WVNetworkReachability *)sharedInstance {
    static dispatch_once_t onceQueue;
    static WVNetworkReachability *sharedInstance = nil;
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statusChangedDictionary = [NSMutableDictionary dictionary];
        _reachableChangedDictionary = [NSMutableDictionary dictionary];
        _observerDictionary = [NSMutableDictionary dictionary];
        _status = getTelephonyNetworkStatus();
        _lastReachable = [self reachable];
        if (@available(iOS 9.0, *)) {
            _cellularData = [[CTCellularData alloc] init];
        }
        [self startMonitoring];
    }
    return self;
}

-(void)addObserver:(NSObject*)observer statusChanged:(void (^)(WVReachabilityStatus status))statusChanged {
    if (observer) {
        self.statusChangedDictionary[@(observer.hash)] = statusChanged;
        self.observerDictionary[@(observer.hash)] = observer;
    }
}

-(void)addObserver:(NSObject*)observer reachableChanged:(void (^)(BOOL reachable))reachableChanged {
    if (observer) {
        self.reachableChangedDictionary[@(observer.hash)] = reachableChanged;
        self.observerDictionary[@(observer.hash)] = observer;
    }
}

-(void)removeObserver:(NSObject*)observer {
    if (observer) {
        [self.statusChangedDictionary removeObjectForKey:@(observer.hash)];
        [self.reachableChangedDictionary removeObjectForKey:@(observer.hash)];
        [self.observerDictionary removeObjectForKey:@(observer.hash)];
    }
}

-(void)dealloc {
    [self stopMonitoring];
}

- (void)startMonitoring {
    [self stopMonitoring];
    
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    self.reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)(&address));
    
    WVReachabilityStatusBlock callback = ^(WVReachabilityStatus status) {
        _status = status;
        for (id object in self.statusChangedDictionary.allValues) {
            void (^statusChanged)(WVReachabilityStatus) = object;
            statusChanged(status);
        }
        if (self.lastReachable != self.reachable) {
            self.lastReachable = self.reachable;
            for (id object in self.reachableChangedDictionary.allValues) {
                void (^reachableChanged)(BOOL) = object;
                reachableChanged(self.reachable);
            }
        }
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, WVReachabilityRetainCallback, WVReachabilityReleaseCallback, NULL};
    
    SCNetworkReachabilitySetCallback(self.reachability, WVReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.reachability, &flags)) {
            WVPostReachabilityStatusChange(flags, callback);
        }
    });
    
    if (@available(iOS 9.0, *)) {
        self.cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            switch (state)
            {
                case kCTCellularDataRestricted:
                    _netAccessStatus = WVNetWorkAccessStatusRestricted; break;
                case kCTCellularDataNotRestricted:
                    _netAccessStatus = WVNetWorkAccessStatusNotRestricted; break;
                case kCTCellularDataRestrictedStateUnknown:
                    //第一次请求网络权限
                    _netAccessStatus = WVNetWorkAccessStatusUnknown; break;
                default: break;
            };
        };
    }
}

- (void)stopMonitoring {
    if (self.reachability) {
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
}

-(BOOL)reachable {
    return self.status != WVReachabilityStatusNotReachable;
}

-(BOOL)reachableViaWWAN {
    return self.status == WVReachabilityStatusWWAN2G || self.status == WVReachabilityStatusWWAN3G || self.status == WVReachabilityStatusWWAN4G;
}

-(BOOL)reachableViaWiFi {
    return self.status == WVReachabilityStatusWiFi;
}

- (BOOL)networkAccessEnable {
    //CTCellularData  只能检测蜂窝权限，不能检测WiFi权限
    if ([WVNetworkReachability isSIMInstalled]) {
        if (self.netAccessStatus == WVNetWorkAccessStatusRestricted && self.status != WVReachabilityStatusWiFi) {
            return NO;
        } else {
            return YES;
        }
    } else {   // 没有SIM卡  默认接受了4G权限 否则UI层会提示网络权限的问题
        return YES;
    }
}

// 判断设备是否安装sim卡
+ (BOOL)isSIMInstalled {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (!carrier.isoCountryCode) {
        return NO;
    }
    return YES;
}

@end
