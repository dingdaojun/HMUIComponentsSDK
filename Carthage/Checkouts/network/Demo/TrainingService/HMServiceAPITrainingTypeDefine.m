//
//  HMServiceAPITrainingTypeDefine.m
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingTypeDefine.h"

@implementation NSNumber (HMServiceAPITrainingBMIType)

- (NSString *)hms_trainingBMITypeString {
    HMServiceAPITrainingBMIType type = self.unsignedIntegerValue;
    HMServiceAPIBMITypeParameterAssert(type);
    
    switch (type) {
        case HMServiceAPITrainingBMIAny: return @"";
        case HMServiceAPITrainingBMIObesity: return @"OBESITY";
        case HMServiceAPITrainingBMIFat: return @"FAT";
        case HMServiceAPITrainingBMINormal: return @"NORMAL";
        case HMServiceAPITrainingBMIThin: return @"THIN";
    }
}

@end
