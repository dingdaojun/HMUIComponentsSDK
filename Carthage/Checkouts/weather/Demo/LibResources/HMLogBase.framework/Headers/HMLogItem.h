//
//  HMLogItem.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMLogTypes.h"

@interface HMLogItem : NSObject

@property (nonatomic, strong, readonly) NSDate *date;

@property (nonatomic, copy, readonly) NSString *file;
@property (nonatomic, assign, readonly) NSUInteger line;
@property (nonatomic, copy, readonly) NSString *function;

@property (nonatomic, assign, readonly) HMLogLevel level;
- (NSString *)levelText;

@property (nonatomic, copy, readonly) NSString *tag;
@property (nonatomic, copy, readonly) NSString *content;

@property (nonatomic, assign, readonly) NSUInteger stackLevel;
@property (nonatomic, copy, readonly) NSString *stackSymbols;

+ (instancetype)itemWithFile:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function
                       level:(HMLogLevel)level
                         tag:(NSString *)tag
                     content:(NSString *)content
                  stackLevel:(NSUInteger)stackLevel;

+ (instancetype)itemWithFile:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function
                       level:(HMLogLevel)level
                         tag:(NSString *)tag
                     content:(NSString *)content
                  stackLevel:(NSUInteger)stackLevel
                        date:(NSDate *)date;

@end
