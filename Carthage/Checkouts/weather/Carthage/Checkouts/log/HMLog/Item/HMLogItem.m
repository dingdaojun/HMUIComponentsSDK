//
//  HMLogItem.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogItem.h"

#import <execinfo.h>

@interface HMLogItem ()

@property (nonatomic, strong, readwrite) NSDate *time;

@property (nonatomic, copy, readwrite) NSString *file;
@property (nonatomic, assign, readwrite) NSUInteger line;
@property (nonatomic, copy, readwrite) NSString *function;

@property (nonatomic, assign, readwrite) HMLogLevel level;

@property (nonatomic, copy, readwrite) NSString *tag;
@property (nonatomic, copy, readwrite) NSString *content;

@property (nonatomic, assign, readwrite) NSUInteger stackLevel;
@property (nonatomic, copy, readwrite) NSString *stackSymbols;

@property (nonatomic, copy, readwrite) NSString *dataFileName;
@property (nonatomic, strong, readwrite) NSData *data;

@end


@implementation HMLogItem

- (NSString *)levelText {
    switch (self.level) {
        case HMLogLevelVerbose:
            return @"VERBOSE";
        case HMLogLevelInfo:
            return @"INFO";
        case HMLogLevelDebug:
            return @"DEBUG";
        case HMLogLevelWarning:
            return @"WARNING";
        case HMLogLevelError:
            return @"ERROR";
        case HMLogLevelFatal:
            return @"FATAL";
    }
}

- (NSString *)stackSymbols {
    if (self.stackLevel == 0) {
        return @"";
    }
    
    if (_stackSymbols.length == 0) {
        NSMutableString *symbols = [NSMutableString string];
        void *array = malloc(sizeof(void *) * (self.stackLevel + 5));
        int size = backtrace(array, (int)(self.stackLevel + 5));
        char **strings = backtrace_symbols(array, size);
        if (strings) {
            for (int i = 5; i < size; i++) {
                [symbols appendFormat:@"%s\n", strings[i]];
            }
            free(strings);
        }
        free(array);
        
        _stackSymbols = symbols;
    }
    return _stackSymbols;
}


+ (instancetype)itemWithTime:(NSDate *)time
                        file:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function
                       level:(HMLogLevel)level
                         tag:(NSString *)tag
                     content:(NSString *)content
                  stackLevel:(NSUInteger)stackLevel
                dataFileName:(NSString *)dataFileName
                        data:(NSData *)data {

    HMLogItem *item = [[HMLogItem alloc] init];

    item.time           = time;
    item.file           = file.lastPathComponent;
    item.line           = line;
    item.function       = function;
    item.level          = level;
    item.tag            = tag;
    item.content        = content;
    item.stackLevel     = stackLevel;
    item.dataFileName   = dataFileName;
    item.data           = data;
    
    return item;
}

@end