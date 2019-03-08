//
//  HMServiceAPI+PublicReview.h
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMPublicPreviewServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)publicReview_checkWithCompletionBlock:(void (^)(BOOL success, NSString *message, BOOL joined, NSString *email))completionBlock;

- (id<HMCancelableAPI>)publicReview_applyWithRomSerialNumber:(NSString *)romSerialNumber
                                             completionBlock:(void (^)(BOOL success, NSString *message, BOOL joined))completionBlock;

- (id<HMCancelableAPI>)publicReview_quitWithCompletionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

- (id<HMCancelableAPI>)publicReview_submitEmail:(NSString *)email
                                       userName:(NSString *)userName
                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end

@interface HMServiceAPI (PublicReview) <HMPublicPreviewServiceAPI>
@end
