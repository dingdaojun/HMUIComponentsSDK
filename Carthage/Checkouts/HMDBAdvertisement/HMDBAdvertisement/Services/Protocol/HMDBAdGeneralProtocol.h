//  HMDBAdGeneralProtocol.h
//  Created on 2018/7/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>
#import "HMDBAdGeneralResourceProtocol.h"

typedef NS_ENUM(NSUInteger, HMDBAdModuleType) {
    HMDBAdModuleTypeSleep = 0,  // 睡眠模块
    HMDBAdModuleTypeBodyFit, // 体脂模块
};

@protocol HMDBAdGeneralProtocol <NSObject>

@property (nonatomic, readonly) NSString    *db_adID;  // 广告ID
@property (nonatomic, readonly) HMDBAdModuleType db_adModuleType;  // 广告模块
@property (nonatomic, readonly) NSString *db_adWebviewUrl;  // 广告跳转地址
@property (nonatomic, readonly) NSString *db_adLogoWebviewUrl;  // logo广告跳转地址
@property (nonatomic, readonly) NSString *db_adGeneralImage;  // 图片资源
@property (nonatomic, readonly) NSString *db_adTitle; // 广告标题
@property (nonatomic, readonly) NSString *db_adSubTitle; // 广告副标题
@property (nonatomic, readonly) NSDate *db_adEndTime; // 结束时间
@property (nonatomic, readonly) NSArray<id<HMDBAdGeneralResourceProtocol>> *db_adImages; // 广告图片
@property (nonatomic, readonly) NSArray<id<HMDBAdGeneralResourceProtocol>> *db_adColors; // 广告颜色

@end
