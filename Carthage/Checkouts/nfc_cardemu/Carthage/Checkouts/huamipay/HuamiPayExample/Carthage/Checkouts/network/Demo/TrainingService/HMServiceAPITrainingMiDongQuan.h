//
//  HMServiceAPITrainingMiDongQuan.h
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 米动圈
@protocol HMServiceAPITrainingMiDongQuan <NSObject>

@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanID;                   // 米动圈ID
@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanImageURL;             // 图片链接
@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanDetailURL;            // 米动圈详情页链接

@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanUserID;               // 用户ID
@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanUserNickname;         // 用户昵称
@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanUserAvatar;           // 用户头像
@property (nonatomic, copy, readonly) NSString *api_trainingMiDongQuanUserProfileURL;       // 用户主页链接

@end

