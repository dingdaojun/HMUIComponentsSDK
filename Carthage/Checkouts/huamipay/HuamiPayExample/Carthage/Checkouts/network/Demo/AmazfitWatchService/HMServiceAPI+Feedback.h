//
//  HMServiceAPI+Feedback.h
//  HuamiWatch
//
//  Created by dingdaojun on 31/7/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMFeedbackServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)feedback_sendContact:(NSString *)contact
                                   question:(NSString *)question
                            firmwareVersion:(NSString *)firmware
                                logFilePath:(id)logFilePath
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 登录失败用户反馈
 @see http://watch-production.private.mi-ae.cn/swagger-ui.html#!/diagnose45file45controller/
 */
- (id<HMCancelableAPI>)feedback_sendLoginFailLogWithContact:(NSString *)contact
                                                   question:(NSString *)question
                                                logFilePath:(NSString *)logFilePath
                                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end


@interface HMServiceAPI (Feedback) <HMFeedbackServiceAPI>
@end
