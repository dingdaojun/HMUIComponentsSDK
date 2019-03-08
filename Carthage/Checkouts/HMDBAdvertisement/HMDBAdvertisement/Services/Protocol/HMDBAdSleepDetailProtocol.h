//  HMDBAdSleepDetailProtocol.h
//  Created on 2018/5/31
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@protocol HMDBAdSleepDetailProtocol <NSObject>

@property (copy, nonatomic, readonly) NSString *db_advertisementID;  // 广告ID
@property (copy, nonatomic, nullable, readonly) NSString *db_logoImageURL; // 客户logo
@property (copy, nonatomic, nullable, readonly) NSString *db_topImageURL;   // 顶部背景图
@property (copy, nonatomic, nullable, readonly) NSString *db_analysisImageURL;  // 质量分析背景图
@property (copy, nonatomic, nullable, readonly) NSString *db_bannerImageURL;   // 通栏banner图
@property (copy, nonatomic, nullable, readonly) NSString *db_title;    // 广告标题
@property (copy, nonatomic, nullable, readonly) NSString *db_subTitle; // 广告副标题
@property (copy, nonatomic, nullable, readonly) NSString *db_backgroundColorHex;  // 颜色值十六进制
@property (copy, nonatomic, nullable, readonly) NSString *db_homeColorHex;   // home 颜色值
@property (copy, nonatomic, nullable, readonly) NSString *db_themeColorHex;  // theme 颜色值
@property (copy, nonatomic, nullable, readonly) NSString *db_webviewLinkURL;   // 广告点击跳转地址
@property (copy, nonatomic, nullable, readonly) NSString *db_logoLinkURL;   // Logo 点击跳转地址
@property (copy, nonatomic, nullable, readonly) NSDate *db_endDate;   // 广告结束时间

@end
