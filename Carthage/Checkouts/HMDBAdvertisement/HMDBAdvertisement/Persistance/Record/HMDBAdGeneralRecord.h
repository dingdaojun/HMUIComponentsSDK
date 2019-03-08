//  HMDBAdGeneralRecord.h
//  Created on 2018/7/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <CTPersistance/CTPersistance.h>

@interface HMDBAdGeneralRecord : CTPersistanceRecord

@property (copy, nonatomic) NSNumber *identifier;   // 数据库自生成主键
@property (copy, nonatomic) NSString *adID;  // 广告ID
@property (assign, nonatomic) NSInteger adModuleType;  // 广告模块
@property (copy, nonatomic) NSString *adWebviewUrl;  // 广告跳转地址
@property (copy, nonatomic) NSString *adLogoWebviewUrl;  // logo广告跳转地址
@property (copy, nonatomic) NSString *adGeneralImage;  // 图片
@property (copy, nonatomic) NSString *adTitle; // 广告标题
@property (copy, nonatomic) NSString *adSubTitle; // 广告副标题
@property (copy, nonatomic) NSNumber *adEndTime; // 结束时间，毫秒数取整

@end
