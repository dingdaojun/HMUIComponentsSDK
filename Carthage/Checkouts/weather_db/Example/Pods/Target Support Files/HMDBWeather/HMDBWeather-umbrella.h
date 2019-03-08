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

#import "HMDBWeatherBaseConfig.h"
#import "HMDBWeatherService+AQI.h"
#import "HMDBWeatherService+Current.h"
#import "HMDBWeatherService+EarlyWarning.h"
#import "HMDBWeatherService+Forecast.h"
#import "HMDBWeatherService.h"
#import "HMDBCurrentWeatherProtocol.h"
#import "HMDBWeatherAQIProtocol.h"
#import "HMDBWeatherEarlyWarningProtocol.h"
#import "HMDBWeatherForecastProtocol.h"

FOUNDATION_EXPORT double HMDBWeatherVersionNumber;
FOUNDATION_EXPORT const unsigned char HMDBWeatherVersionString[];

