//
//  HMServiceAPITrainingBanner.h
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingTypeDefine.h"


// 轮播图类型
typedef NS_ENUM(NSUInteger, HMServiceAPITrainingBannerType) {
    HMServiceAPITrainingBannerTypeTrainingCollection,       // 合集
    HMServiceAPITrainingBannerTypeSingleTraining,           // 单次训练
    HMServiceAPITrainingBannerTypeArticle,                  // 文章
};

// 轮播图
@protocol HMServiceAPITrainingBanner <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingBannerID;                                   // 轮播图ID

@property (nonatomic, copy, readonly) NSString *api_trainingBannerName;                                 // 轮播图名称
@property (nonatomic, copy, readonly) NSString *api_trainingBannerImageURL;                             // 图片链接
@property (nonatomic, assign, readonly) HMServiceAPITrainingBannerType api_trainingBannerType;          // 轮播图类型

// type == HMServiceAPITrainingBannerTypeTrainingCollection 时有值
@property (nonatomic, copy, readonly) NSString *api_trainingBannerTrainingCollectionID;                 // 训练专题ID
@property (nonatomic, copy, readonly) NSString *api_trainingBannerTrainingCollectionName;               // 训练专题名称

// type == HMServiceAPITrainingBannerTypeSingleTraining 时有值
@property (nonatomic, copy, readonly) NSString *api_trainingBannerSingleTrainingID;                     // 单次训练ID
@property (nonatomic, copy, readonly) NSString *api_trainingBannerSingleTrainingName;                   // 单次训练名称

// type == HMServiceAPITrainingBannerTypeArticle时有值
@property (nonatomic, copy, readonly) NSString *api_trainingBannerArticleURL;                           // 文章链接

@end
