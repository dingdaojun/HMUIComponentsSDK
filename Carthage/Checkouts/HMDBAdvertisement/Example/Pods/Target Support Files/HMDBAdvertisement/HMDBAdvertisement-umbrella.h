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

#import "HMDBAdvertisementConfig.h"
#import "HMDBAdServices.h"
#import "HMDBAdGeneralProtocol.h"
#import "HMDBAdGeneralResourceProtocol.h"
#import "HMDBAdSleepDetailProtocol.h"
#import "HMDBAdServices+General.h"
#import "HMDBAdServices+SleepDetail.h"

FOUNDATION_EXPORT double HMDBAdvertisementVersionNumber;
FOUNDATION_EXPORT const unsigned char HMDBAdvertisementVersionString[];

