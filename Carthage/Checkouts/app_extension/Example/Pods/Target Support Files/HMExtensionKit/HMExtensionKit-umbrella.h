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

#import "HMEShortcutExtension.h"
#import "HMEIntentHandler.h"
#import "HMETodayWidgetViewController.h"

FOUNDATION_EXPORT double HMExtensionKitVersionNumber;
FOUNDATION_EXPORT const unsigned char HMExtensionKitVersionString[];

