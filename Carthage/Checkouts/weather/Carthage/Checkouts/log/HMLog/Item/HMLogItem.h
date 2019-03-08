//
//  HMLogItem.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMLogLevel.h"

@interface HMLogItem : NSObject

// 时间
@property (readonly) NSDate *time;

// Trace
@property (readonly) NSString *file;
@property (readonly) NSUInteger line;
@property (readonly) NSString *function;

// 级别
@property (readonly) HMLogLevel level;
@property (readonly) NSString *levelText;

// 标签
@property (readonly) NSString *tag;

// 文本内容
@property (readonly) NSString *content;

// 栈信息
@property (readonly) NSUInteger stackLevel;
@property (readonly) NSString *stackSymbols;

// 二进制数据记录
@property (readonly) NSString *dataFileName;
@property (readonly) NSData *data;


+ (instancetype)itemWithTime:(NSDate *)time
                        file:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function
                       level:(HMLogLevel)level
                         tag:(NSString *)tag
                     content:(NSString *)content
                  stackLevel:(NSUInteger)stackLevel
                dataFileName:(NSString *)dataFileName
                        data:(NSData *)data;

@end
