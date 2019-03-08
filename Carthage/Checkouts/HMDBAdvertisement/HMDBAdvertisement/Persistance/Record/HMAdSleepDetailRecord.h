//  HMAdSleepDetailRecord.h
//  Created on 2018/5/30
//  Description 睡眠详情广告

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <CTPersistance/CTPersistance.h>

@interface HMAdSleepDetailRecord : CTPersistanceRecord

@property (copy, nonatomic) NSNumber *identifier;   // 数据库自生成主键
@property (copy, nonatomic) NSString *advertisementID;  // 广告 ID
@property (copy, nonatomic) NSString *logoImageURL; // 客户logo
@property (copy, nonatomic) NSString *topImageURL;   // 顶部背景图
@property (copy, nonatomic) NSString *analysisImageURL;  // 质量分析背景图
@property (copy, nonatomic) NSString *bannerImageURL;   // 通栏 banner 图
@property (copy, nonatomic) NSString *title;    // 广告标题
@property (copy, nonatomic) NSString *subTitle; // 广告副标题
@property (copy, nonatomic) NSString *backgroundColorHex;    //  背景颜色值十六进制
@property (copy, nonatomic) NSString *homeColorHex; // home 颜色值
@property (copy, nonatomic) NSString *themeColorHex;  // theme 颜色值
@property (copy, nonatomic) NSString *webviewLinkURL;   // 广告点击跳转地址
@property (copy, nonatomic) NSString *logoLinkURL;   // Logo 点击跳转地址
@property (copy, nonatomic) NSNumber *endMilliseconds;   // 广告结束时间，long long 类型

@end
