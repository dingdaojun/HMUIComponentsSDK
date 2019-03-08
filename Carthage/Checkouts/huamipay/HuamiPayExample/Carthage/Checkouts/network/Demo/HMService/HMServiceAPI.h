//
//  HMServiceAPI.h
//  HMNetworkLayer
//
//  Created by 李宪 on 13/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSError+HMServiceAPI.h"

@protocol HMServiceDelegate;

@protocol HMServiceAPI <NSObject>
@property (readonly) id<HMServiceDelegate>delegate;
@end


@interface HMServiceAPI : NSObject <HMServiceAPI>

#pragma mark - Singleton

@property (class, nonatomic, strong) id<HMServiceDelegate>defaultDelegate;
+ (instancetype)defaultService;


#pragma mark - Factory

+ (instancetype)service;
+ (instancetype)serviceWithDelegate:(id<HMServiceDelegate>)delegate;


#pragma mark - Initializer

- (instancetype)initWithDelegate:(id<HMServiceDelegate>)delegate;


#pragma mark - Log Toggle

@property (class, nonatomic, assign) BOOL disableLog;

@end


@protocol HMServiceDelegate <NSObject>

@required
- (NSString *)userIDForService:(id<HMServiceAPI>)service;

- (NSString *)absoluteURLForService:(id<HMServiceAPI>)service referenceURL:(NSString *)referenceURL;
- (NSDictionary<NSString *, NSString *> *)uniformHeaderFieldValuesForService:(id<HMServiceAPI>)service error:(NSError **)error;
- (NSDictionary<NSString *, NSString *> *)uniformHeaderFieldValuesForService:(id<HMServiceAPI>)service auth:(BOOL)auth error:(NSError **)error;
- (NSDictionary<NSString *, id> *)uniformParametersForService:(id<HMServiceAPI>)service error:(NSError **)error;

- (void)service:(id<HMServiceAPI>)service didDetectError:(NSError *)error inAPI:(NSString *)apiName localizedMessage:(NSString *__autoreleasing *)message;

@optional
- (NSDictionary<NSString *, NSString *> *)uniformWalletHeaderFieldValues;

@end


@protocol HMCancelableAPI <NSObject>

- (void)cancel;
- (void)printCURL;

@end

