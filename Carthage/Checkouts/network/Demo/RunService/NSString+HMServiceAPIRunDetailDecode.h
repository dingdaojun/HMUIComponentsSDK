//
//  NSString+HMServiceAPIRunDetailDecode.h
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/7/3.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMServiceApiRunProtocol.h"
#import "HMServiceAPIRunPaceDataItem.h"



@interface NSString (HMServiceAPIRunDetailDecode)


- (NSArray<id<HMServiceAPIRunGPSData>> *)hm_stringByDecodingGpsWithstartTime:(NSTimeInterval)startTime
                                                               timeEncodeStr:(NSString *)timeEncodeStr
                                                               paceEncodeStr:(NSString *)paceEncodeStr
                                                           altitudeEncodeStr:(NSString *)altitudeEncodeStr
                                                            GPSFlagEncodeStr:(NSString *)GPSFlagEncodeStr
                                                        GPSAccuracyEncodeStr:(NSString *)GPSAccuracyEncodeStr;



- (NSArray<id<HMServiceAPIRunHeartRateData>> *)hm_stringByDecodingHeartRateWithStartTime:(NSTimeInterval)startTime;


- (NSArray<id<HMServiceAPIRunDistanceData>> *)hm_stringByDecodingDistanceWithStartTime:(NSTimeInterval)startTime;


- (NSArray<id<HMServiceAPIRunPressureData>> *)hm_stringByDecodingPressureWithStartTime:(NSTimeInterval)startTime;


- (NSArray<id<HMServiceAPIRunGaitData>> *)hm_stringByDecodingGaitWithStartTime:(NSTimeInterval)startTime;

- (NSArray<id<HMServiceAPIRunSpeedData>> *)hm_stringByDecodingSpeedWithStartTime:(NSTimeInterval)startTime;

- (NSArray<id<HMServiceAPIRunPauseData>> *)hm_stringByDecodingPause;


- (NSArray<id<HMServiceAPIRunPaceData>> *)hm_stringByDecodingPace;


- (NSArray<id<HMServiceAPIRunLapData>> *)hm_stringByDecodingLapWithStartTime:(NSTimeInterval)startTime;


- (NSArray<id<HMServiceAPIRunCorrectAltitudeData>> *)hm_stringByDecodingCorrectAltitudeWithStartTime:(NSTimeInterval)startTime;


- (NSArray<id<HMServiceAPIRunStrokeSpeedData>> *)hm_stringByDecodingStrokeSpeedWithStartTime:(NSTimeInterval)startTime;


- (NSArray<id<HMServiceAPIRunCadenceData>> *)hm_stringByDecodingCadenceWithStartTime:(NSTimeInterval)startTime;

- (NSArray<id<HMServiceAPIRunRopeSkippingFrequencyData>> *)hm_stringByDecodingRopeSkippingWithStartTime:(NSTimeInterval)startTime;

@end



