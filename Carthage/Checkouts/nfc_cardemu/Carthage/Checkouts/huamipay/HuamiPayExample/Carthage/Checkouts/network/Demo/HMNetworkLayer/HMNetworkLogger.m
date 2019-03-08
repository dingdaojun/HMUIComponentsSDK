//
//  HMNetworkLogger.m
//  HMNetworkLayer
//
//  Created by 李宪 on 24/9/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMNetworkLogger.h"

@interface HMNetworkLogger : NSObject <HMNetworkLogger>
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation HMNetworkLogger

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter  = [NSDateFormatter new];
        dateFormatter.calendar          = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        dateFormatter.dateFormat        = @"yyyy-MM-dd HH:mm:ss:SSSSSS";
        self.dateFormatter = dateFormatter;
    }
    return self;
}

- (void)network_logWithLevel:(HMNetworkLogLevel)level
                     content:(NSString *)content
                        file:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function {
    
    NSString *levelText;
    switch (level) {
        case HMNetworkLogLevelInfo:
            levelText = @"INFO   ";
            break;
        case HMNetworkLogLevelWarning:
            levelText = @"WARNING";
            break;
        case HMNetworkLogLevelError:
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



static id<HMNetworkLogger> glogger;

void HMNetworkSetLogger(id<HMNetworkLogger> logger) {
    glogger = logger;
}

id<HMNetworkLogger> HMNetworkGetLogger() {
    if (!glogger) {
        glogger = [HMNetworkLogger new];
        HMNetworkSetLogger(glogger);
    }
    return glogger;
}
