//
//  HMConsoleLogger.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogger.h"

@protocol HMLogFormatter;

@interface HMConsoleLogger : HMLogger

@property (nonatomic, strong) id<HMLogFormatter>formatter;

@end
