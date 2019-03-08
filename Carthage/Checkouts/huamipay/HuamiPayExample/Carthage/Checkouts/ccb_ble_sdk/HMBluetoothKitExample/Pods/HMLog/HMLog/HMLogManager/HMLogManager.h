//
//  HMLogManager.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HMLogTypes.h"

@class HMLogItem;
@class HMLogConfiguration;

@protocol HMLogger;

@interface HMLogManager : NSObject

+ (void)setupDefaultConfiguration:(HMLogConfiguration *)configuration;

// singleton
+ (instancetype)sharedInstance;

//startup
- (void)startup;

// loggers
- (NSArray<id<HMLogger>> *)allLoggers;
- (void)addLogger:(id<HMLogger>)logger;
- (void)removeLogger:(id<HMLogger>)logger;
- (void)removeAllLoggers;

// record log
- (void)recordLogWithLevel:(HMLogLevel)level
                       tag:(NSString *)tag
                      file:(NSString *)file
                      line:(NSUInteger)line
                  function:(NSString *)function
                   content:(NSString *)content
                stackLevel:(NSUInteger)stackLevel;

- (void)recordLogItem:(HMLogItem *)item;

@end
