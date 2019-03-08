//
//  HMEIntentHandler.h
//  Pods
//
//  Created by 江杨 on 15/05/2017.
//
//

#import <Intents/Intents.h>

typedef NS_ENUM(NSInteger, HMESiriCommandType) {
    HMESiriCommandUnknown        = 0,
    HMESiriCommandOutdoorStart   = 1,         /**开始跑步*/
    HMESiriCommandIndoorStart    = 2,         /**开始跑步*/
    HMESiriCommandPause          = 3,         /**跑步暂停*/
    HMESiriCommandResume         = 4,         /**跑步继续*/
    HMESiriCommandStop           = 5,         /**跑步结束*/
    HMESiriCommandCancel         = 6,         /**跑步取消*/
};

@interface HMEIntentHandler : NSObject <INWorkoutsDomainHandling>

@end
