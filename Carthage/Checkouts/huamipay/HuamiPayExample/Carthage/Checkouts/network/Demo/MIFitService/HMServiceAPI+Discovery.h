//
//  HMServiceAPI+Discovery.h
//  HMNetworkLayer
//
//  Created by 李宪 on 17/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

NS_ASSUME_NONNULL_BEGIN


/**
 发现模块类别
 @see model for 'mifitDotDismissInfos' at
 http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/legacy45mifit45dot45info45controller/postUsingPOST_17
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIDiscoveryModule) {
    HMServiceAPIModuleEntrance          = 1,    // 跑步圈入口
    HMServiceAPIModuleAdsBanner,                // 轮播图
    HMServiceAPIModuleIcon,                     // 8个窗格
    HMServiceAPIModuleActivity,                 // 活动
    HMServiceAPIModuleRunInfo,                  // 跑步咨询
    HMServiceAPIModuleTrainingCenter,           // 训练中心
    HMServiceAPIModuleMedal,                    // 勋章
    HMServiceAPIModuleDataReport,               // 数据报告，周报
    HMServiceAPIModuleHealthService,            // 健康服务
    HMServiceAPIModuleSportEvent,               // 运动赛事
    HMServiceAPIModuleShoppingMall,             // 商城
    HMServiceAPIModuleEnterpriseService,        // 企业服务
    HMServiceAPIModuleMoreLink,                 // 更多（后台管理使用）
    HMServiceAPIModuleDiscoveryHome,            // 发现主页(发现页面打点使用
    HMServiceAPIModuleRunCircle,                // 跑圈？
    HMServiceAPIModuleChaohuSkin,               // 巢湖手表表盘
    HMServiceAPIModuleMessageCenter,            // 消息箱
    HMServiceAPIModuleTempoWatchSkin,           // tempo皮肤
    HMServiceAPIModuleMyTab,                    // 我的tab
    HMServiceAPIModuleMyDevice,                 // 主设备入口 （目前只支持表盘更新提醒）
};

typedef NS_ENUM(NSUInteger, HMServiceAPIAdvertisementType) {
    HMServiceAPIAdvertisementTypeSleep,                 // 睡眠广告
    HMServiceAPIAdvertisementTypeBodyFat                // 体脂广告
};


@protocol HMServiceAPIDiscoveryDotDismissData <NSObject>

@property (readonly) NSDate *api_discoveryDotDismissTime;
@property (readonly) HMServiceAPIDiscoveryModule api_discoveryDotModule;

@end

@protocol HMServiceAPIDiscoveryDotData <NSObject>

@property (readonly) BOOL api_discoveryDotDataUpdate;
@property (readonly) NSInteger api_discoveryDotDataMessageCount;
@property (readonly) HMServiceAPIDiscoveryModule api_discoveryDotDataModule;

@end


@protocol HMServiceAPIDiscoverySleepAdvertisementData <NSObject>


@property (readonly) NSString *api_discoverySleepAdvertisementLogoImageUrl;         // 客户logo

@property (readonly) NSString *api_discoverySleepAdvertisementTopImageUrl;          // 顶部背景图

@property (readonly) NSString *api_discoverySleepAdvertisementBGImageUrl;           // 质量分析背景图

@property (readonly) NSString *api_discoverySleepAdvertisementBannerImageUrl;       // 通栏banner图

@property (readonly) NSString *api_discoverySleepAdvertisementWebviewUrl;           // 广告跳转地址

@property (readonly) NSString *api_discoverySleepAdvertisementLogoWebviewUrl;       // logo广告跳转地址

@property (readonly) NSString *api_discoverySleepAdvertisementTitle;                // 广告标题

@property (readonly) NSString *api_discoverySleepAdvertisementSubTitle;             // 广告副标题

@property (readonly) NSString *api_discoverySleepAdvertisementID;                   // 广告ID

@property (readonly) NSDate *api_discoverySleepAdvertisementEndTime;                // 结束时间

@property (readonly) UIColor *api_discoverySleepAdvertisementHomeColor;             // home颜色值

@property (readonly) UIColor *api_discoverySleepAdvertisementThemeColor;            // theme颜色值

@property (readonly) UIColor *api_discoverySleepAdvertisementBGColor;               // bg颜色值

@end


@protocol HMServiceAPIAdvertisementImageData <NSObject>

@property (readonly) NSString *api_advertisementImageUrl;               // 图片的URL

@property (readonly) NSString *api_advertisementImagePosition;          // 图片的类型

@end

@protocol HMServiceAPIAdvertisementColorData <NSObject>

@property (readonly) NSString *api_advertisementColor;                  // 颜色值（hex格式的）

@property (readonly) NSString *api_advertisementColorPosition;          // 颜色值所在的位置类型

@end

@protocol HMServiceAPIAdvertisementData <NSObject>

@property (readonly) NSString *api_advertisementWebviewUrl;                                     // 广告跳转地址

@property (readonly) NSString *api_advertisementLogoWebviewUrl;                                 // logo广告跳转地址

@property (readonly) NSString *api_advertisementTitle;                            // 广告标题

@property (readonly) NSString *api_advertisementSubTitle;                                       // 广告副标题

@property (readonly) NSString *api_advertisementID;                                             // 广告ID

@property (readonly) NSDate *api_advertisementEndTime;                                          // 结束时间

@property (readonly) NSString *api_advertisementImage;                                          // 图片

@property (readonly) NSArray<id<HMServiceAPIAdvertisementImageData>> *api_advertisementImages;  // 图片资源

@property (readonly) NSArray<id<HMServiceAPIAdvertisementColorData>> *api_advertisementColors;  // 颜色资源

@end


@protocol HMServiceDiscoveryAPI <HMServiceAPI>

/**
 发现消除红点
 @see http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/mifit-dot-info-controller/postUsingPOST_22
 */
- (id<HMCancelableAPI>)discovery_dismissDots:(NSArray<id<HMServiceAPIDiscoveryDotDismissData>> *)disMissDots
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDiscoveryDotData>> *dots))completionBlock;

/**
 *  @brief  睡眠广告页
 *
 *  @param  adcode         行政区编码
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://aos-docs.private.mi-ae.net/aos-api/discovery/app_discovery/
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)discovery_sleepAdvertisementWithAdcode:(NSString *)adcode
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIDiscoverySleepAdvertisementData>> *datas))completionBlock;

/**
 *  @brief  广告
 *
 *  @param  adcode          行政区编码
 *
 *  @param  type            广告类型
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://10.1.18.125:3000/project/49/interface/api/430
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)discovery_advertisementWithAdcode:(NSString *)adcode
                                                    type:(HMServiceAPIAdvertisementType)type
                                         completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIAdvertisementData>> *datas))completionBlock;


@end


@interface HMServiceAPI (Discovery) <HMServiceDiscoveryAPI>
@end

NS_ASSUME_NONNULL_END
