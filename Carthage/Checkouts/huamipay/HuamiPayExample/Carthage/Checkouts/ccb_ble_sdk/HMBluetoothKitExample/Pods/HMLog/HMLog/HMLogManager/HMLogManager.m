//
//  HMLogManager.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogManager.h"
#import <objc/runtime.h>

#import "HMLogItem.h"
#import "HMLogger.h"
#import "HMConsoleLogger.h"
#import "HMDatabaseLogger.h"
#import "HMLogConfiguration+Keys.h"


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
        HMLogConfiguration *configuration = [HMLogManager defaultConfiguration];
        if (!configuration) {
            configuration = [HMLogConfiguration defaultConfiguration];
        }
        
        HMDatabaseLogger *databaseLogger = [HMDatabaseLogger loggerWithConfiguration:configuration];
        [self.loggers addObject:databaseLogger];
        
        HMConsoleLogger *consoleLogger = [HMConsoleLogger loggerWithConfiguration:configuration];
        [self.loggers addObject:consoleLogger];
        
        _ioQueue = dispatch_queue_create("HMLogManager.ioQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)startup {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSAssert(infoPlist, @"主Bundle下查找不到info.plist文件");
    NSString *appVersion = [infoPlist objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuild = [infoPlist objectForKey:@"CFBundleVersion"];
    NSString *content = [NSString stringWithFormat:@"App Launch_%@_%@",appVersion,appBuild];

    [self recordLogWithLevel:HMLogLevelWarning
                         tag:@"App"
                        file:@""
                        line:0
                    function:@""
                     content:content
                  stackLevel:0];
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_ioQueue);
#endif
}

#pragma mark - configuration

+ (void)setupDefaultConfiguration:(HMLogConfiguration *)configuration {
    objc_setAssociatedObject(self, "configuration", configuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSArray *loggers = [HMLogManager sharedInstance].loggers;
    for (id<HMLogger>logger in loggers) {
        if ([logger respondsToSelector:@selector(setConfiguration:)]) {
            [logger performSelector:@selector(setConfiguration:) withObject:configuration];
        }
    }
}

+ (HMLogConfiguration *)defaultConfiguration {
    return objc_getAssociatedObject(self, "configuration");
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
    
    NSMutableArray *loggers = [NSMutableArray new];
    
    dispatch_sync(_ioQueue, ^{
        [loggers addObjectsFromArray:self.loggers];
    });
    
    return loggers;
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
                stackLevel:(NSUInteger)stackLevel {

    HMLogItem *item = [HMLogItem itemWithFile:file
                                         line:line
                                     function:function
                                        level:level
                                          tag:tag
                                      content:content
                                   stackLevel:stackLevel];

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
