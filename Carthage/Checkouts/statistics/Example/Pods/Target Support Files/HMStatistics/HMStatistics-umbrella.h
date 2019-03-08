#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HMStatisticsConfig.h"
#import "HMStatisticsLog.h"
#import "HMStatisticsLog+BothChannel.h"
#import "HMStatisticsPageAutoTracker.h"

FOUNDATION_EXPORT double HMStatisticsVersionNumber;
FOUNDATION_EXPORT const unsigned char HMStatisticsVersionString[];

