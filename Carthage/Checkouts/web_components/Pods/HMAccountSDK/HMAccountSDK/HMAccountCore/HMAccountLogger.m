//
//  HMAccountLogger.m
//  HMNetworkLayer
//
//  Created by 李宪 on 24/9/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMAccountLogger.h"

@interface HMAccountLogger : NSObject <HMAccountLogger>
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation HMAccountLogger

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSSSSS";
        self.dateFormatter = dateFormatter;
    }
    return self;
}

- (void)account_logWithLevel:(HMAccountLogLevel)level
                     content:(NSString *)content
                        file:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function {
    
    NSString *levelText;
    switch (level) {
        case HMAccountLogLevelInfo:
            levelText = @"INFO   ";
            break;
        case HMAccountLogLevelWarning:
            levelText = @"WARNING";
            break;
        case HMAccountLogLevelError:
            levelText = @"ERROR  ";
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
    
    NSDate *time = [NSDate date];
    NSString *timeText = [self.dateFormatter stringFromDate:time];
    
    NSString *formattedContent = [NSString stringWithFormat:
                                  @"%@ HMNetworkKit: %@ | %@ : %d\t| %@\t| %@\n",
                                  timeText,
                                  levelText,
                                  file,
                                  (int)line,
                                  function,
                                  content ?: @""];
    fprintf(stderr, "%s", formattedContent.UTF8String);
}

@end



static id<HMAccountLogger> glogger;

void HMAccountSetLogger(id<HMAccountLogger> logger) {
    glogger = logger;
}

id<HMAccountLogger> HMAccountGetLogger() {
    if (!glogger) {
        glogger = [HMAccountLogger new];
        HMAccountSetLogger(glogger);
    }
    return glogger;
}
