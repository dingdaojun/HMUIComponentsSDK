//
//  HMServiceAPITrainingArticle.h
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMServiceAPITrainingArticle <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingArticleID;                    // ID
@property (nonatomic, assign, readonly) NSUInteger api_trainingArticleOrder;              // 排序，分页用
@property (nonatomic, copy, readonly) NSString *api_trainingArticleTitle;                 // 标题
@property (nonatomic, copy, readonly) NSString *api_trainingArticleDescription;           // 描述
@property (nonatomic, copy, readonly) NSString *api_trainingArticleURL;                   // 链接
@property (nonatomic, copy, readonly) NSString *api_trainingArticleImageURL;              // 图片链接

@end
