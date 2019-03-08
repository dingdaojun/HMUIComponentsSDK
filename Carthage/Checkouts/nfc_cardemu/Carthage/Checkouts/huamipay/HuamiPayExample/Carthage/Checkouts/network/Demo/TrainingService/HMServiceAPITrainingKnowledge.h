//
//  HMServiceAPITrainingKnowledge.h
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI.h"

// 训练知识
@protocol HMServiceAPITrainingKnowledge <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingKnowledgeID;                    // ID
@property (nonatomic, assign, readonly) NSUInteger api_trainingKnowledgeOrder;              // 排序，分页用
@property (nonatomic, copy, readonly) NSString *api_trainingKnowledgeTitle;                 // 标题
@property (nonatomic, copy, readonly) NSString *api_trainingKnowledgeDescription;           // 描述
@property (nonatomic, copy, readonly) NSString *api_trainingKnowledgeURL;                   // 链接
@property (nonatomic, copy, readonly) NSString *api_trainingKnowledgeImageURL;              // 图片链接

@end


