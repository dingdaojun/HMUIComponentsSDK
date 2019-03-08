//
//  HMServiceAPITask.m
//  HMNetworkLayer
//
//  Created by 李宪 on 10/7/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITask.h"
#import "NSURLSessionTask+CURL.h"
#import "HMNetworkLogger.h"


@interface HMServiceAPITask ()
@property (class, readonly) dispatch_queue_t queue;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, assign) BOOL shouldPrintCURL;
@end

@implementation HMServiceAPITask

+ (instancetype)taskWithConcreteBlock:(HMServiceAPIConcreteBlock)block {
    
    HMServiceAPITask *task = [HMServiceAPITask new];
    
    dispatch_async(self.queue, ^{
        NSURLSessionTask *sessionTask = block();
        
        if (task.cancelled) {
            [sessionTask cancel];
            return;
        }
        
        task.sessionTask = sessionTask;
        
        if (task.shouldPrintCURL) {
            HMNetworkLogInfo(@"%@", sessionTask.CURLCommand);
        }
    });
    
    return task;
}

+ (dispatch_queue_t)queue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("hmservice.api.task.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

#pragma mark - HMCancelableAPI

- (void)cancel {
    self.cancelled = YES;
    [self.sessionTask cancel];
}

- (void)printCURL {
    if (self.sessionTask) {
        HMNetworkLogInfo(@"%@", self.sessionTask.CURLCommand);
        return;
    }
    
    self.shouldPrintCURL = YES;
}

@end
