//
//  Created on 2017/10/31
//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

@protocol HMServiceAPIDevelopmentEditionQueryData <NSObject>

@property (nonatomic, assign, readonly) BOOL  api_developmentEditionQueryDataQuotaFull;              // 名额已满
@property (nonatomic, assign, readonly) BOOL  api_developmentEditionQueryDataHavejoined;             // 已经加入

@end



@interface HMServiceAPI (DevelopmentEdition)

/**
 查询是否可以参加开发版本
 @see http://device-service.private.mi-ae.net/swagger-ui.html#!/public-preview-controller/getAppPublicPreviewUsingGET
 */
- (id<HMCancelableAPI>)development_queryWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIDevelopmentEditionQueryData> developmentEditionQueryData))completionBlock;

/**
 参加开发版本
 @see http://device-service.private.mi-ae.net/swagger-ui.html#!/public-preview-controller/joinAppPublicPreviewUsingPOST
 */
- (id<HMCancelableAPI>)development_updateWithEmail:(NSString *)email
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 取消开发版本
 @see http://device-service.private.mi-ae.net/swagger-ui.html#!/public-preview-controller/leaveAppPublicPreviewUsingDELETE
 */
- (id<HMCancelableAPI>)development_deleteWithCompletionBlock:(void (^)(BOOL success, NSString *message))completionBlock;


@end

