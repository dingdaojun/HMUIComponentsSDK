//
//  HMLogManager.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogManager.h"

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

#import <objc/runtime.h>

#import "HMLogItem.h"
#import "HMLogger.h"


@interface HMLogManager ()

@property (nonatomic, strong) NSMutableArray<id<HMLogger>> *loggers;

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#else
@property (nonatomic, assign) dispatch_queue_t ioQueue;
#endif  /* OS_OBJECT_USE_OBJC */

@end


@implementation HMLogManager

+ (instancetype)sharedInstance {
    
    static id instance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[self class] new];
    });

    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("HMLogManager.ioQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)startup {

    NSString *launchingMessage      = @"============================================================\n";


    NSDictionary *infoPlist = [NSBundle mainBundle].infoDictionary;
    NSParameterAssert(infoPlist.count > 0);

    launchingMessage                = [launchingMessage stringByAppendingFormat:@"app name: %@\n", infoPlist[@"CFBundleDisplayName"]];
    launchingMessage                = [launchingMessage stringByAppendingFormat:@"app version: %@\n", infoPlist[@"CFBundleShortVersionString"]];
    launchingMessage                = [launchingMessage stringByAppendingFormat:@"app build: %@\n", infoPlist[@"CFBundleVersion"]];
    launchingMessage                = [launchingMessage stringByAppendingFormat:@"country: %@\n", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    launchingMessage                = [launchingMessage stringByAppendingFormat:@"language: %@\n", [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];

#if TARGET_OS_IPHONE

    launchingMessage                = [launchingMessage stringByAppendingFormat:@"system version: %@\n", [UIDevice currentDevice].systemVersion];
    launchingMessage                = [launchingMessage stringByAppendingFormat:@"device model: %@\n", [UIDevice currentDevice].model];

#endif

    [self recordLogWithLevel:HMLogLevelWarning
                         tag:@"App"
                        file:@""
                        line:0
                    function:@""
                     content:launchingMessage
                  stackLevel:0
                dataFileName:nil
                        data:nil];
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_ioQueue);
#endif
}

#pragma mark - setters and getters

- (NSMutableArray<id<HMLogger>> *)loggers {
    if (!_loggers) {
        _loggers = [NSMutableArray new];
    }
    return _loggers;
}

#pragma mark - public

- (NSArray<id<HMLogger>> *)allLoggers {
    return self.loggers.copy;
}

- (void)addLogger:(id<HMLogger>)logger {
    
    dispatch_async(_ioQueue, ^{
        [self.loggers addObject:logger];
    });
}

- (void)removeLogger:(id<HMLogger>)logger {
    
    dispatch_async(_ioQueue, ^{
        [self.loggers removeObject:logger];
    });
}

- (void)removeAllLoggers {
    
    dispatch_async(_ioQueue, ^{
        [self.loggers removeAllObjects];
    });
}

// record log
- (void)recordLogWithLevel:(HMLogLevel)level
                       tag:(NSString *)tag
                      file:(NSString *)file
                      line:(NSUInteger)line
                  function:(NSString *)function
                   content:(NSString *)content
                stackLevel:(NSUInteger)stackLevel
              dataFileName:(NSString *)dataFileName
                      data:(NSData *)data {

    HMLogItem *item = [HMLogItem itemWithTime:[NSDate date]
                                         file:file
                                         line:line
                                     function:function
                                        level:level
                                          tag:tag
                                      content:content
                                   stackLevel:stackLevel
                                 dataFileName:dataFileName
                                         data:data];

    [self recordLogItem:item];
}

- (void)recordLogItem:(HMLogItem *)item {
    
    dispatch_sync(_ioQueue, ^{
        for (id<HMLogger> logger in self.loggers) {
            [logger recordLogItem:item];
        }
    });
}

@end