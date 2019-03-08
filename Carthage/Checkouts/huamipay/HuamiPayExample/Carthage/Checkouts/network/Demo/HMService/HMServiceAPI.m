//
//  HMServiceAPI.m
//  HMNetworkLayer
//
//  Created by 李宪 on 13/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI.h"
#import <objc/runtime.h>
#import <HMNetworkLayer/HMNetworkLayer.h>

@interface HMServiceAPI ()
@property (nonatomic, strong, readwrite) id<HMServiceDelegate>delegate;
@property (nonatomic, strong, readwrite) dispatch_queue_t queue;
@end


@implementation HMServiceAPI

+ (void)setDefaultDelegate:(id<HMServiceDelegate>)defaultDelegate {
    objc_setAssociatedObject(self, "defaultDelegate", defaultDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (id<HMServiceDelegate>)defaultDelegate {
    return objc_getAssociatedObject(self, "defaultDelegate");
}

+ (instancetype)defaultService {
    static id service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] initWithDelegate:[self defaultDelegate]];
    });
    return service;
}

+ (instancetype)service {
    id<HMServiceDelegate>delegate = [self defaultDelegate];
    return [self serviceWithDelegate:delegate];
}

+ (instancetype)serviceWithDelegate:(id<HMServiceDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id<HMServiceDelegate>)delegate {
    NSParameterAssert(delegate);
    
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        NSString *queueName = [NSString stringWithFormat:@"hmservice.api.queue.%p", self];
        self.queue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (void)setDisableLog:(BOOL)disableLog {
    HMNetworkCore.disableLog = disableLog;
}
+ (BOOL)disableLog {
    return HMNetworkCore.disableLog;
}

@end
