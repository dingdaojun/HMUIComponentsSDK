//
//  HMConsoleLogger.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogger.h"

@protocol HMConsoleLogFormatter;

@interface HMConsoleLogger : NSObject <HMLogger>

+ (instancetype)sharedLogger;


@property (nonatomic, strong) id<HMConsoleLogFormatter>formatter;

// The log levels which can be output to console, if unset all log levels will be output to console. Default is nil.
@property (nonatomic, strong) NSSet<NSNumber *> *filterLevels;

// The log tags which can be output to console, if unset all log tags will be output to console. Default is nil.
@property (nonatomic, strong) NSSet<NSString *> *filterTags;

@end
