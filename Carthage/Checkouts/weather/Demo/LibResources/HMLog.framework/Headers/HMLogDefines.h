//
//  HMLogDefines.h
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#ifndef HMLogDefines_h
#define HMLogDefines_h

#import "HMLogLevel.h"
#import "HMLogManager.h"

// Define const NSString key macros
#define HM_KEY(key)                                     NSString * const key = @#key;
#define HM_CUSTOM_KEY(key, value)                       NSString * const key = @#value;
#define HM_EXTERN_KEY(key)                              FOUNDATION_EXPORT NSString * const key;


// General log method
#define HMLog(Level, Tag, StackLevel, Format, ...)    \
do {    \
    HMLogManager *manager = [HMLogManager sharedInstance]; \
    [manager recordLogWithLevel:Level \
    tag:@#Tag  \
    file:@(__FILE__)  \
    line:__LINE__ \
    function:@(__FUNCTION__)   \
    content:[NSString stringWithFormat:Format, ##__VA_ARGS__] \
    stackLevel:StackLevel   \
    dataFileName:nil   \
    data:nil];   \
} while(0)

// Verbose
#define HMLogV(tag, format, ...)                        HMLog(HMLogLevelVerbose, tag, 0, format, ##__VA_ARGS__)
// Info
#define HMLogI(tag, format, ...)                        HMLog(HMLogLevelInfo, tag, 0, format, ##__VA_ARGS__)
// Debug
#define HMLogD(tag, format, ...)                        HMLog(HMLogLevelDebug, tag, 0, format, ##__VA_ARGS__)
// Warning
#define HMLogW(tag, format, ...)                        HMLog(HMLogLevelWarning, tag, 0, format, ##__VA_ARGS__)
// Error
#define HMLogE(tag, format, ...)                        HMLog(HMLogLevelError, tag, 0, format, ##__VA_ARGS__)
// Fatal
#define HMLogF(tag, format, ...)                        HMLog(HMLogLevelFatal, tag, 0, format, ##__VA_ARGS__)

// NSLog redefine
#define NSLog(format, ...)                              HMLogD(App, format, ##__VA_ARGS__)


// Data log
#define HMDataLog(Level, Tag, StackLevel, DataFileName, Data, Format, ...)    \
do {    \
HMLogManager *manager = [HMLogManager sharedInstance]; \
[manager recordLogWithLevel:Level \
tag:@#Tag  \
file:@(__FILE__)  \
line:__LINE__ \
function:@(__FUNCTION__)   \
content:[NSString stringWithFormat:Format, ##__VA_ARGS__] \
stackLevel:StackLevel   \
dataFileName:DataFileName   \
data:Data];   \
} while(0)

// verbose
#define HMDataLogV(tag, dataFileName, data, format, ...)                HMDataLog(HMLogLevelVerbose, tag, 0, dataFileName, data, format, ##__VA_ARGS__)
// info
#define HMDataLogI(tag, dataFileName, data, format, ...)                HMDataLog(HMLogLevelInfo, tag, 0, dataFileName, data, format, ##__VA_ARGS__)
// debug
#define HMDataLogD(tag, dataFileName, data, format, ...)                HMDataLog(HMLogLevelDebug, tag, 0, dataFileName, data, format, ##__VA_ARGS__)
// warning
#define HMDataLogW(tag, dataFileName, data, format, ...)                HMDataLog(HMLogLevelWarning, tag, 0, dataFileName, data, format, ##__VA_ARGS__)
// error
#define HMDataLogE(tag, dataFileName, data, format, ...)                HMDataLog(HMLogLevelError, tag, 0, dataFileName, data, format, ##__VA_ARGS__)
// fatal
#define HMDataLogF(tag, dataFileName, data, format, ...)                HMDataLog(HMLogLevelFatal, tag, 0, dataFileName, data, format, ##__VA_ARGS__)

#endif /* HMLogDefines_h */
