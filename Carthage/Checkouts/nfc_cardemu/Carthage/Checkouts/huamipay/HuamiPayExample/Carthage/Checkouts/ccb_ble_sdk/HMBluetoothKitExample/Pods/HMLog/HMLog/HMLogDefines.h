//
//  HMLogDefines.h
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#ifndef HMLogDefines_h
#define HMLogDefines_h

#import "HMLogTypes.h"
#import "HMLogManager.h"

// define const NSString key macros
#define HM_KEY(key)                                     NSString * const key = @#key;
#define HM_CUSTOM_KEY(key, value)                       NSString * const key = @#value;
#define HM_EXTERN_KEY(key)                              FOUNDATION_EXPORT NSString * const key;


// general log
#define HMLog(Level, Tag, StackLevel, format, ...)      do {    \
                                                            HMLogManager *manager = [HMLogManager sharedInstance]; \
                                                            [manager recordLogWithLevel:Level \
                                                                                  tag:@#Tag  \
                                                                                 file:@(__FILE__)  \
                                                                                 line:__LINE__ \
                                                                             function:@(__FUNCTION__)   \
                                                                              content:[NSString stringWithFormat:format, ##__VA_ARGS__] \
                                                                           stackLevel:StackLevel];   \
                                                        } while(0)

// verbose
#define HMLogV(tag, format, ...)                        HMLog(HMLogLevelVerbose, tag, 0, format, ##__VA_ARGS__)
// info
#define HMLogI(tag, format, ...)                        HMLog(HMLogLevelInfo, tag, 0, format, ##__VA_ARGS__)
// debug
#define HMLogD(tag, format, ...)                        HMLog(HMLogLevelDebug, tag, 0, format, ##__VA_ARGS__)
// warning
#define HMLogW(tag, format, ...)                        HMLog(HMLogLevelWarning, tag, 0, format, ##__VA_ARGS__)
// error
#define HMLogE(tag, format, ...)                        HMLog(HMLogLevelError, tag, 0, format, ##__VA_ARGS__)
// fatal
#define HMLogF(tag, format, ...)                        HMLog(HMLogLevelFatal, tag, 0, format, ##__VA_ARGS__)

// NSLog redefine
#define NSLog(format, ...)                              HMLogD(App, format, ##__VA_ARGS__)

#endif /* HMLogDefines_h */
