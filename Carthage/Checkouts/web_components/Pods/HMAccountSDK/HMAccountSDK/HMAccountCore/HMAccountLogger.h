//
//  HMAccountLogger.h
//  HMNetworkLayer
//
//  Created by 李宪 on 24/9/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HMAccountLogLevel) {
    HMAccountLogLevelInfo,
    HMAccountLogLevelWarning,
    HMAccountLogLevelError,
};


@protocol HMAccountLogger <NSObject>

- (void)account_logWithLevel:(HMAccountLogLevel)level
                     content:(NSString *)content
                        file:(NSString *)file
                        line:(NSUInteger)line
                    function:(NSString *)function;
@end



void HMAccountSetLogger(id<HMAccountLogger> logger);
id<HMAccountLogger> HMAccountGetLogger(void);

#define HMAccountLog(Level, Format, ...)                    do {    \
                                                                [HMAccountGetLogger()       \
                                                                account_logWithLevel:Level     \
                                                                content:[NSString stringWithFormat:Format, ##__VA_ARGS__]     \
                                                                file:@(__FILE__).lastPathComponent      \
                                                                line:__LINE__   \
                                                                function:@(__FUNCTION__)];     \
                                                            } while(0)

#define HMAccountLogInfo(format, ...)                       HMAccountLog(HMAccountLogLevelInfo, format, ##__VA_ARGS__)
#define HMAccountLogWarning(format, ...)                    HMAccountLog(HMAccountLogLevelWarning, format, ##__VA_ARGS__)
#define HMAccountLogError(format, ...)                      HMAccountLog(HMAccountLogLevelError, format, ##__VA_ARGS__)



