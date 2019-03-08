//
//  HMLogManager.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HMLogLevel.h"

@class HMLogItem;
@protocol HMLogger;


@interface HMLogManager : NSObject


+ (instancetype)sharedInstance;

- (void)startup;


#pragma mark - loggers

- (NSArray<id<HMLogger>> *)allLoggers;
- (void)addLogger:(id<HMLogger>)logger;
- (void)removeLogger:(id<HMLogger>)logger;
- (void)removeAllLoggers;


#pragma mark - record log

- (void)recordLogWithLevel:(HMLogLevel)level
                       tag:(NSString *)tag
                      file:(NSString *)file
                      line:(NSUInteger)line
                  function:(NSString *)function
                   content:(NSString *)content
                stackLevel:(NSUInteger)stackLevel
              dataFileName:(NSString *)dataFileName
                      data:(NSData *)data;

- (void)recordLogItem:(HMLogItem *)item;

@end
