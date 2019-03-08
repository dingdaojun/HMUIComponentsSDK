//
//  HMLogLevel.h
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#ifndef HMLogLevel_h
#define HMLogLevel_h

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, HMLogLevel) {
    HMLogLevelVerbose       = 0,
    HMLogLevelInfo,
    HMLogLevelDebug,
    HMLogLevelWarning,
    HMLogLevelError,
    HMLogLevelFatal
};

#endif /* HMLogLevel_h */
