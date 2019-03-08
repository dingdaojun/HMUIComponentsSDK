//
//  HMServiceAPITrainingCollection.h
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMServiceAPITrainingData;

// 训练专题
@protocol HMServiceAPITrainingCollection <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingCollectionID;           // 专题ID
@property (nonatomic, copy, readonly) NSString *api_trainingCollectionName;         // 专题名称

@property (nonatomic, copy, readonly) NSArray<id<HMServiceAPITrainingData>> *api_trainingCollectionTrainings;   // 专题的训练列表

@end
