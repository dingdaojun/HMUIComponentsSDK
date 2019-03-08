//
//  HMServiceAPI+Feedback.h
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

@protocol HMServiceFeedbackAPI <HMServiceAPI>

/**
 用户反馈
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=115
 @param contact 联系方式
 @param content 反馈内容
 @param area 区域 e.g “美国”、“大陆”、“台湾”
 @param language 语言
 @param firmware 固件版本号
 @param shoe 鞋子固件版本号
 @param scale 体重秤固件版本号
 @param deviceNames 已绑定设备名称
 @param logFilePath NSURL or NSString
 */
- (id<HMCancelableAPI>)feedback_sendContact:(NSString *)contact
                                    content:(NSString *)content
                                 appVersion:(NSString *)appVersion
                                       area:(NSString *)area
                                   language:(NSString *)language
                            firmwareVersion:(NSString *)firmware
                        shoeFirmwareVersion:(NSString *)shoe
                       scaleFirmwareVersion:(NSString *)scale
                                  isDevelop:(BOOL)isDevelop
                           boundDeviceNames:(NSArray<NSString *> *)deviceNames
                                logFilePath:(id)logFilePath
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 用户反馈
 @see http://device-service.private.mi-ae.net/swagger-ui.html#!/diagnose-file-controller/postUsingPOST_4
 @param logFilePath log文件路径
 */
- (void)loginFailFeedback_logFilePath:(NSString *)logFilePath
                      completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;
@end

@interface HMServiceAPI (Feedback) <HMServiceFeedbackAPI>
@end
