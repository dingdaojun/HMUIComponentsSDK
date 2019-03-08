//
//  HMServiceAPI+Medal.h
//  HMServiceAPI+MIFit
//
//  Created by 单军龙 on 2017/10/24.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIMedalData <NSObject>

@property (nonatomic, copy, readonly) NSString *api_medalDataID;
@property (nonatomic, copy, readonly) NSString *api_medalDataTitle;
@property (nonatomic, copy, readonly) NSString *api_medalDataSubTitle;

@property (nonatomic, copy, readonly) NSString *api_medalDataTitleImageUrl;
@property (nonatomic, copy, readonly) NSString *api_medalDataNotObtainIconUrl;
@property (nonatomic, copy, readonly) NSString *api_medalDataNotObtainText;
@property (nonatomic, copy, readonly) NSString *api_medalDataObtainIconUrl;
@property (nonatomic, copy, readonly) NSString *api_medalDataObtainText;
@property (nonatomic, copy, readonly) NSString *api_medalDataCategory;          //勋章类型


@end


@protocol HMServiceMedalAPI <HMServiceAPI>

/**
 获取勋章信息
 @see http://10.1.18.110/docs/activity-api/site/incentive/medal/user_medals/
 */
- (id<HMCancelableAPI>)medal_dataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIMedalData>> *medalDatas))completionBlock;


/**
 领取勋章信息
 @see http://10.1.18.110/docs/activity-api/site/incentive/medal/take_medal/
 */
- (id<HMCancelableAPI>)medal_uploadDataWithMedalID:(NSString *)medalID
                                   completionBlock:(void (^)(BOOL success, NSInteger statusCode, NSString *message))completionBlock;


@end

@interface HMServiceAPI (Medal) <HMServiceMedalAPI>

@end
