//
//  HMFileLogger.h
//  Mac
//
//  Created by 李宪 on 2018/5/25.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMLogger.h"

@protocol HMFileLogFormatter;


@interface HMFileLogger : NSObject <HMLogger>

+ (instancetype)sharedLogger;


@property (nonatomic, copy) NSString *directory;
@property (nonatomic, strong) id<HMFileLogFormatter>formatter;

@end
