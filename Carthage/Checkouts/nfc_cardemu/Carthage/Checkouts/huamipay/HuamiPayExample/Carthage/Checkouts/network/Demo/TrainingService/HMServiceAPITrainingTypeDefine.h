//
//  HMServiceAPITrainingTypeDefine.h
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI.h"

/**
 训练中心数据类型定义
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 类型定义
 */

// 性别
typedef NS_ENUM(NSUInteger, HMServiceAPITrainingUserGender) {
    HMServiceAPITrainingUserGenderFemale,       // 女性
    HMServiceAPITrainingUserGenderMale,         // 男性
    HMServiceAPITrainingUserGenderBoth,         // 男性+女性，只用于接口返回值解析
};
// 性别作为参数，必须明确指定男性还是女性
#define HMServiceAPITrainingUserGenderParameterAssert(x)        NSParameterAssert(x == HMServiceAPITrainingUserGenderMale ||    \
                                                                                    x == HMServiceAPITrainingUserGenderFemale)

// BMI类型
typedef NS_ENUM(NSUInteger, HMServiceAPITrainingBMIType) {
    HMServiceAPITrainingBMIAny,                 // 任意的
    HMServiceAPITrainingBMIObesity,             // 肥胖
    HMServiceAPITrainingBMIFat,                 // 偏胖
    HMServiceAPITrainingBMINormal,              // 正常
    HMServiceAPITrainingBMIThin,                // 偏瘦
};
#define HMServiceAPIBMITypeParameterAssert(x)           NSParameterAssert(x == HMServiceAPITrainingBMIAny || \
                                                                            x == HMServiceAPITrainingBMIObesity || \
                                                                            x == HMServiceAPITrainingBMIFat ||  \
                                                                            x == HMServiceAPITrainingBMINormal ||  \
                                                                            x == HMServiceAPITrainingBMIThin)

@interface NSNumber (HMServiceAPITrainingBMIType)
@property (nonatomic, copy, readonly) NSString *hms_trainingBMITypeString;
@end
