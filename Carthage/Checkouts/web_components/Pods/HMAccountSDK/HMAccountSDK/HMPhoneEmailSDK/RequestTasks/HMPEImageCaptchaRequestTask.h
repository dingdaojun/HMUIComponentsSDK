//
//  HMPEImageCaptchaRequestTask.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/11/20.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMPEBaseRequestTask.h"

/**
 API-2
 图片验证码
 200: OK
 400: 参数错误
 429: Too many requests
 500: Internal Server Error such as storage or remote regions
 */
@interface HMPEImageCaptchaRequestTask : WSRequestTask

/**
 获取图片验证码
 
 @param codeType HMPEImageCodeType
 @return HMPEImageCaptchaRequestTask 实例
 */
+ (nonnull HMPEImageCaptchaRequestTask *)captchTaskWithCodeType:(nonnull HMPEImageCodeType *)codeType;

@end
