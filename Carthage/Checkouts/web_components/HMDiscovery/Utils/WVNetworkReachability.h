//  WVNetworkReachability.h
//  Created on 2018/6/14
//  Description 网络状态监听Tool.

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WVReachabilityStatus) {
    WVReachabilityStatusNotReachable     = 0,
    WVReachabilityStatusWWAN2G           = 1,
    WVReachabilityStatusWWAN3G           = 2,
    WVReachabilityStatusWWAN4G           = 3,
    WVReachabilityStatusWiFi             = 4,
};
typedef NS_ENUM(NSInteger, WVNetWorkAccessStatus) {
    WVNetWorkAccessStatusUnknown        = 0,
    WVNetWorkAccessStatusRestricted     = 1,
    WVNetWorkAccessStatusNotRestricted  = 2,
};

@interface WVNetworkReachability : NSObject

+ (WVNetworkReachability *)sharedInstance;

@property (readonly, nonatomic, assign) WVReachabilityStatus status;
@property (readonly, nonatomic, assign) WVNetWorkAccessStatus netAccessStatus;
@property (readonly, nonatomic, assign) BOOL networkAccessEnable;
@property (readonly, nonatomic, assign) BOOL reachable;
@property (readonly, nonatomic, assign) BOOL reachableViaWWAN;
@property (readonly, nonatomic, assign) BOOL reachableViaWiFi;

-(void)addObserver:(NSObject*)observer statusChanged:(void (^)(WVReachabilityStatus status))statusChanged;
-(void)addObserver:(NSObject*)observer reachableChanged:(void (^)(BOOL reachable))reachableChanged;

-(void)removeObserver:(NSObject*)observer;

@end
