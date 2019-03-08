//
//  HMNetworkLogger.h
//  HMNetworkLayer
//
//  Created by 李宪 on 24/9/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HMNetworkLogLevel) {
    HMNetworkLogLevelInfo,
    HMNetworkLogLevelWarning,
    HMNetworkLogLevelError,
};


@protocol HMNetworkLogger <NSObject>

- (void)network_logWithLevel:(HMNetworkLogLevel)level
                     content:(NSString *)content
                        file:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function;
@end



void HMNetworkSetLogger(id<HMNetworkLogger> logger);
id<HMNetworkLogger> HMNetworkGetLogger(void);

#define HMNetworkLog(Level, Format, ...)                    do {    \
                                                                [HMNetworkGetLogger()       \
                                                                network_logWithLevel:Level     \
                                                                content:[NSString stringWithFormat:Format, ##__VA_ARGS__]     \
                                                                file:@(__FILE__).lastPathComponent      \
                                                                line:__LINE__   \
                                                                function:@(__FUNCTION__)];     \
                                                            } while(0)

#define HMNetworkLogInfo(format, ...)                       HMNetworkLog(HMNetworkLogLevelInfo, format, ##__VA_ARGS__)
#define HMNetworkLogWarning(format, ...)                    HMNetworkLog(HMNetworkLogLevelWarning, format, ##__VA_ARGS__)
#define HMNetworkLogError(format, ...)                      HMNetworkLog(HMNetworkLogLevelError, format, ##__VA_ARGS__)



